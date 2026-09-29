-- Bonus : passage à une architecture hybride
-- Un second fichier (bike_ny_live.csv), déposé dans un dossier HDFS séparé,
-- simule l'arrivée de nouvelles données. Même traitement que le batch historique,
-- puis union des deux sources dans une vue unique.
-- Usage : --hivevar db=<base> --hivevar live_path=/education/<groupe>/<user>/project_bike/live

USE ${hivevar:db};

-- Couche brute des nouvelles données
DROP TABLE IF EXISTS bike_trips_live_ext;
CREATE EXTERNAL TABLE bike_trips_live_ext (
  ride_id STRING, started_at STRING, ended_at STRING,
  start_station_name STRING, end_station_name STRING,
  start_lat DOUBLE, start_lng DOUBLE, end_lat DOUBLE, end_lng DOUBLE,
  member_casual STRING, rideable_type STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES ('separatorChar' = ',', 'quoteChar' = '"', 'escapeChar' = '\\')
STORED AS TEXTFILE
LOCATION '${hivevar:live_path}'
TBLPROPERTIES ('skip.header.line.count' = '1');

-- Couche nettoyée des nouvelles données (même logique que 03_table_clean.hql)
DROP TABLE IF EXISTS bike_trips_live_clean;
CREATE TABLE bike_trips_live_clean
STORED AS ORC
AS
SELECT
  ride_id,
  CAST(from_unixtime(unix_timestamp(regexp_replace(started_at, 'T', ' '), 'yyyy-MM-dd HH:mm:ss')) AS TIMESTAMP) AS started_at_ts,
  CAST(from_unixtime(unix_timestamp(regexp_replace(ended_at,   'T', ' '), 'yyyy-MM-dd HH:mm:ss')) AS TIMESTAMP) AS ended_at_ts,
  start_station_name, end_station_name,
  start_lat, start_lng, end_lat, end_lng,
  member_casual, rideable_type,
  (unix_timestamp(regexp_replace(ended_at,   'T', ' '), 'yyyy-MM-dd HH:mm:ss')
   - unix_timestamp(regexp_replace(started_at, 'T', ' '), 'yyyy-MM-dd HH:mm:ss')) / 60.0 AS trip_duration_min
FROM bike_trips_live_ext
WHERE ride_id IS NOT NULL
  AND started_at IS NOT NULL
  AND ended_at IS NOT NULL
  AND start_station_name IS NOT NULL
  AND end_station_name IS NOT NULL
  AND unix_timestamp(regexp_replace(ended_at,   'T', ' '), 'yyyy-MM-dd HH:mm:ss')
    > unix_timestamp(regexp_replace(started_at, 'T', ' '), 'yyyy-MM-dd HH:mm:ss');

-- Vue hybride : historique + nouvelles données, avec traçabilité de la source
DROP VIEW IF EXISTS bike_trips_hybrid;
CREATE VIEW bike_trips_hybrid AS
SELECT *, 'historical_batch' AS data_source FROM bike_trips_clean
UNION ALL
SELECT *, 'simulated_live'   AS data_source FROM bike_trips_live_clean;

-- Vérifications
SELECT COUNT(*) AS nb_rows_hybrid FROM bike_trips_hybrid;

SELECT data_source, COUNT(*) AS nb_rows
FROM bike_trips_hybrid
GROUP BY data_source;

SELECT start_station_name, COUNT(*) AS nb_trips
FROM bike_trips_hybrid
GROUP BY start_station_name
ORDER BY nb_trips DESC
LIMIT 10;
