# Analyse des trajets Citi Bike avec Hadoop et Hive

Projet du cours Big Data Ecosystem (ECE Paris), fait en binôme avec Edouard Menut.

La question de départ : à partir de l'historique des trajets d'un réseau de vélos en libre-service, peut-on voir quelles stations sont les plus utilisées, à quelles heures, et en tirer des idées pour mieux répartir les vélos ?

Rapport complet : [rapport_projet.pdf](rapport_projet.pdf)

## Pipeline

```
CSV Citi Bike -> nettoyage Python (local) -> HDFS (raw) -> table externe Hive -> table ORC nettoyée -> requêtes HiveQL
```

1. Nettoyage en local avec Python. On a fusionné deux extractions Citi Bike, puis supprimé les lignes vides, les dates invalides, les durées négatives ou supérieures à 24 h et les doublons. Il reste environ 1,9 million de trajets (à peu près 320 Mo).
2. Dépôt du fichier dans HDFS ([01_ingestion_hdfs.sh](sql/01_ingestion_hdfs.sh)).
3. Création de la table externe `bike_trips_ext` sur le CSV ([02_table_externe.hql](sql/02_table_externe.hql)). Les dates restent en `STRING` à ce stade, pour garder le fichier source tel quel.
4. Création de la table `bike_trips_clean` au format ORC ([03_table_clean.hql](sql/03_table_clean.hql)) : conversion des dates, calcul de la durée en minutes et filtrage des lignes incohérentes.
5. Requêtes d'analyse ([04_analyses.hql](sql/04_analyses.hql)).
6. Bonus ([05_bonus_hybride.hql](sql/05_bonus_hybride.hql)) : un second fichier, déposé dans un autre dossier HDFS, simule de nouvelles données. Il passe par les mêmes étapes, puis la vue `bike_trips_hybrid` réunit les deux sources avec une colonne `data_source`.

Les scripts prennent la base et les chemins en variables :

```bash
beeline -u "<jdbc-url>" --hivevar db=<base> --hivevar raw_path=<chemin_hdfs>/raw -f sql/02_table_externe.hql
```

## Résultats

Sur les 1 886 318 trajets de l'historique :

- Les stations les plus utilisées sont les mêmes au départ et à l'arrivée (9 sur 10 en commun). W 21 St & 6 Ave arrive en tête, avec 8 335 départs et 8 309 arrivées. Les usagers rééquilibrent donc une bonne partie du réseau eux-mêmes. Broadway & W 58 St est dans le top des départs mais pas des arrivées : c'est la station qu'il faudrait surveiller et réapprovisionner.
- Il y a deux pics d'utilisation, vers 8-9 h et entre 16 h et 18 h (165 967 trajets à 17 h). Les vélos servent surtout pour aller au travail et en revenir.
- Un trajet dure en moyenne 11 minutes environ.
- 64 % des trajets sont faits en vélo électrique (1 213 279 contre 673 039 en vélo classique).

Captures : [stations de départ](resultats/top_stations_depart.png), [stations d'arrivée](resultats/top_stations_arrivee.png), [heures](resultats/heures_de_pointe.png), [types de vélo](resultats/types_de_velo.png), [aperçu de la table clean](resultats/table_clean_apercu.png).

## Vérifications

- Le fichier est présent et lisible dans HDFS.
- La table externe a le bon schéma et l'en-tête est bien ignoré.
- On retrouve le même nombre de lignes avant et après nettoyage (1 886 318), ce qui est normal puisque le CSV était déjà nettoyé en Python. Il reste 0 ligne avec une valeur nulle ou une durée négative ([capture](resultats/controle_qualite.png)).
- La vue hybride contient 1 886 318 + 1 997 530 = 3 883 848 lignes ([capture](resultats/hybride_repartition_sources.png)).

## Ce qu'on pourrait améliorer

- Orchestrer les étapes avec Oozie ou Airflow au lieu de les lancer à la main.
- Partitionner la table ORC par date.
- Remplacer le faux « flux » par un vrai flux Kafka avec Spark Streaming.

## Données

Les données viennent de [Citi Bike](https://citibikenyc.com/system-data). Les CSV ne sont pas dans le dépôt, ils sont trop gros.
