-- Étape 4 : requêtes d'analyse métier sur la table nettoyée

USE ${hivevar:db};

-- Top 10 des stations de départ
SELECT start_station_name, COUNT(*) AS nb_trips
FROM bike_trips_clean
GROUP BY start_station_name
ORDER BY nb_trips DESC
LIMIT 10;

-- Top 10 des stations d'arrivée
SELECT end_station_name, COUNT(*) AS nb_trips
FROM bike_trips_clean
GROUP BY end_station_name
ORDER BY nb_trips DESC
LIMIT 10;

-- Heures de pointe
SELECT HOUR(started_at_ts) AS trip_hour, COUNT(*) AS nb_trips
FROM bike_trips_clean
GROUP BY HOUR(started_at_ts)
ORDER BY nb_trips DESC;

-- Durée moyenne d'un trajet (minutes)
SELECT ROUND(AVG(trip_duration_min), 2) AS avg_duration_min
FROM bike_trips_clean;

-- Répartition par type de vélo
SELECT rideable_type, COUNT(*) AS nb_trips
FROM bike_trips_clean
GROUP BY rideable_type;
