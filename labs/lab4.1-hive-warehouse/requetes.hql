-- Lab 4.1 : Hive Warehouse
-- Ingestion d'un CSV via une table externe, puis transformation vers une table managée ORC.
-- Préparation (shell) :
--   hdfs dfs -cat /education/$GROUP/resources/lab4/nyc_drivers/drivers.csv | head -n 5
--   hdfs dfs -cp  /education/$GROUP/resources/lab4/nyc_drivers /user/$USER/
-- Puis dans beeline :
--   SET hivevar:user=<user>; SET hivevar:group=<groupe>; SET hivevar:hiveUsername=<user_hive>;

USE ${hivevar:group};

-- PARTIE 1 : table externe sur le CSV (les données restent dans /user/<user>/nyc_drivers)
CREATE EXTERNAL TABLE ${hivevar:hiveUsername}_nyc_drivers_ext (
  driverId    INT,
  name        STRING,
  ssn         STRING,
  location    STRING,
  certified   STRING,
  `wage-plan` STRING
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
STORED AS TEXTFILE
LOCATION '/user/${hivevar:user}/nyc_drivers'
TBLPROPERTIES ('skip.header.line.count' = '1');

SHOW TABLES;
SELECT * FROM ${hivevar:hiveUsername}_nyc_drivers_ext LIMIT 10;   -- vérifier qu'il n'y a pas de NULL

-- PARTIE 2 : table managée au format ORC (fichiers gérés par Hive dans le warehouse)
CREATE TABLE ${hivevar:hiveUsername}_nyc_drivers (
  driverId    INT,
  first_name  STRING,
  last_name   STRING,
  ssn         STRING,
  address     STRING,
  certified   BOOLEAN,
  `wage-plan` STRING
)
STORED AS ORC;
-- Vérification côté HDFS (dossier vide tant que la table n'est pas remplie) :
--   hdfs dfs -ls /warehouse/tablespace/managed/hive/<groupe>.db/<user_hive>_nyc_drivers

-- PARTIE 3 : chargement avec transformations
--   name      -> first_name + last_name
--   location  -> address
--   certified -> BOOLEAN
INSERT INTO TABLE ${hivevar:hiveUsername}_nyc_drivers
SELECT
  driverId,
  split(name, ' ')[0] AS first_name,
  split(name, ' ')[1] AS last_name,
  ssn,
  location AS address,
  -- Correction : le CSV encode certified en 'Y' / 'N' (et non 'true' / 'false'),
  -- la première version du lab renvoyait donc NULL pour toutes les lignes.
  CASE
    WHEN upper(certified) IN ('Y', 'TRUE')  THEN true
    WHEN upper(certified) IN ('N', 'FALSE') THEN false
    ELSE NULL
  END AS certified,
  `wage-plan`
FROM ${hivevar:hiveUsername}_nyc_drivers_ext;

SELECT * FROM ${hivevar:hiveUsername}_nyc_drivers LIMIT 10;
-- Après insertion, un dossier delta ORC apparaît dans le warehouse (tables transactionnelles ACID)
