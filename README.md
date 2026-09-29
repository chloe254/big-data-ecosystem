# 🐘 Écosystème Big Data : Hadoop, Hive et pipeline de données

Travaux du cours **Big Data Ecosystem** (ECE Paris), réalisés sur un cluster Hadoop multi-nœuds sécurisé par Kerberos. On y trouve un projet de pipeline de données de bout en bout, les labs pratiques et mes fiches de synthèse.

![Hadoop](https://img.shields.io/badge/Hadoop-HDFS_·_YARN-66CCFF?style=flat&logo=apachehadoop&logoColor=black)
![Hive](https://img.shields.io/badge/Hive-HiveQL-FDEE21?style=flat&logo=apachehive&logoColor=black)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=flat&logo=postgresql&logoColor=white)
![Oozie](https://img.shields.io/badge/Oozie-orchestration-555?style=flat)
![Kafka](https://img.shields.io/badge/Kafka-streaming-231F20?style=flat&logo=apachekafka&logoColor=white)
![HBase](https://img.shields.io/badge/HBase-NoSQL-555?style=flat)

## ⭐ Projet : pipeline d'analyse des trajets Citi Bike (New York)

➡️ **[projet-velos-nyc](projet-velos-nyc/)**, réalisé avec Edouard Menut.

Il s'agit d'un pipeline batch complet qui traite **1,9 million de trajets** :

- nettoyage des données en Python ;
- ingestion dans HDFS ;
- table externe Hive, puis table analytique au format ORC ;
- analyses HiveQL : stations les plus utilisées, heures de pointe, durée moyenne, part des vélos électriques ;
- en bonus, une **architecture hybride** qui réunit l'historique et des données simulées « temps réel » (3,9 millions de lignes).

**Résultats principaux** : l'usage est surtout domicile-travail (pics à 8 h et 17 h), les trajets durent en moyenne 11 minutes, et 64 % sont faits en vélo électrique. Ces résultats donnent des recommandations concrètes de répartition des vélos entre les stations.

## 🧪 Labs

| Lab | Thème | Contenu |
|---|---|---|
| [Lab 2](labs/lab2-hdfs-yarn/) | HDFS, YARN, Kerberos | Stockage et réplication (`fsck`), soumission de jobs YARN, WordCount, accès aux interfaces web via Kerberos |
| [Lab 3](labs/lab3-mapreduce/) | MapReduce en Python | Job Hadoop Streaming enchaîné sur la sortie de WordCount pour trouver le mot le plus fréquent (« the », 13 604 occurrences), testable en local |
| [Lab 4.1](labs/lab4.1-hive-warehouse/) | Hive Warehouse | Table externe sur un CSV, puis table managée ORC avec des transformations (`split`, `CASE`, typage) |
| [Lab 4.2](labs/lab4.2-hive-ql/) | Hive Query Language | Requêtes analytiques sur IMDb : expressions régulières, tableaux (`array_contains`), jointures sur 4 tables |

## 📝 Fiches de synthèse

[Mes fiches de révision](fiches/) sur l'orchestration (**Oozie**), le streaming (**Kafka**) et le NoSQL (**HBase**).

## 🎯 Compétences mobilisées

- **Cluster Hadoop** : HDFS (blocs, réplication), YARN (soumission et suivi de jobs), sécurité Kerberos.
- **Traitement distribué** : MapReduce, jobs Hadoop Streaming en Python enchaînés.
- **Stockage distribué** : HDFS, organisation en zones *raw* et *clean*.
- **Data warehousing** : tables externes et tables gérées, SerDe CSV, format colonne ORC, CTAS.
- **SQL analytique** : agrégations, jointures multiples, fonctions de date, expressions régulières, types complexes.
- **Qualité des données** : nettoyage, contrôles de cohérence, traçabilité de la source.
- **Architecture** : batch, puis évolution vers une architecture hybride ; notions d'orchestration et de streaming.

---

*Réalisé par [Chloé Lestic](https://github.com/chloe254), élève ingénieure à l'ECE Paris.*
