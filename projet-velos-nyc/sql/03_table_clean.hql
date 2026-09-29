-- Étape 3 : table analytique nettoyée (couche "clean"), stockée en ORC
-- Conversion des horodatages, calcul de la durée en minutes, filtrage des lignes invalides.

USE ${hivevar:db};

DROP TABLE IF EXISTS bike_trips_clean;
CREATE TABLE bike_trips_clean
STORED AS ORC
AS
SELECT
  ride_id,
  CAST(from_unixtime(unix_timestamp(regexp_replace(started_at, 'T', ' '), 'yyyy-MM-dd HH:mm:ss')) AS TIMESTAMP) AS started_at_ts,
  CAST(from_unixtime(unix_timestamp(regexp_replace(ended_at,   'T', ' '), 'yyyy-MM-dd HH:mm:ss')) AS TIMESTAMP) AS ended_at_ts,
  start_station_name,
  end_station_name,
  start_lat, start_lng, end_lat, end_lng,
  member_casual,
  rideable_type,
  (unix_timestamp(regexp_replace(ended_at,   'T', ' '), 'yyyy-MM-dd HH:mm:ss')
   - unix_timestamp(regexp_replace(started_at, 'T', ' '), 'yyyy-MM-dd HH:mm:ss')) / 60.0 AS trip_duration_min
FROM bike_trips_ext
WHERE ride_id IS NOT NULL
  AND started_at IS NOT NULL
  AND ended_at IS NOT NULL
  AND start_station_name IS NOT NULL
  AND end_station_name IS NOT NULL
  AND unix_timestamp(regexp_replace(ended_at,   'T', ' '), 'yyyy-MM-dd HH:mm:ss')
    > unix_timestamp(regexp_replace(started_at, 'T', ' '), 'yyyy-MM-dd HH:mm:ss');

-- Contrôles qualité
SELECT COUNT(*) AS nb_rows_ext   FROM bike_trips_ext;
SELECT COUNT(*) AS nb_rows_clean FROM bike_trips_clean;

SELECT COUNT(*) AS nb_invalid_remaining
FROM bike_trips_clean
WHERE ride_id IS NULL
   OR started_at_ts IS NULL
   OR ended_at_ts IS NULL
   OR start_station_name IS NULL
   OR end_station_name IS NULL
   OR trip_duration_min <= 0;
