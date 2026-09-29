-- Étape 2 : table externe Hive sur le CSV brut (couche "raw")
-- Les dates restent en STRING pour ne rien perdre du fichier source.
-- Usage : beeline ... --hivevar db=<base> --hivevar raw_path=/education/<groupe>/<user>/project_bike/raw -f 02_table_externe.hql

USE ${hivevar:db};

DROP TABLE IF EXISTS bike_trips_ext;
CREATE EXTERNAL TABLE bike_trips_ext (
  ride_id            STRING,
  started_at         STRING,
  ended_at           STRING,
  start_station_name STRING,
  end_station_name   STRING,
  start_lat          DOUBLE,
  start_lng          DOUBLE,
  end_lat            DOUBLE,
  end_lng            DOUBLE,
  member_casual      STRING,
  rideable_type      STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES ('separatorChar' = ',', 'quoteChar' = '"', 'escapeChar' = '\\')
STORED AS TEXTFILE
LOCATION '${hivevar:raw_path}'
TBLPROPERTIES ('skip.header.line.count' = '1');
