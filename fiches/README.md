# 📝 Fiches de synthèse

Ce sont mes notes de révision, rédigées avec mes propres mots, sur les briques de l'écosystème Hadoop vues en cours.

## Orchestration avec Oozie

- **Rôle** : planificateur de workflows pour Hadoop. Il enchaîne automatiquement des actions (HDFS, Hive, MapReduce, Spark…).
- **Workflow** : un graphe orienté acyclique (DAG) décrit dans `workflow.xml`. Il contient :
  - des nœuds de contrôle : `start`, `end`, `kill`, et `decision` / `fork` / `join` pour les branches ;
  - des nœuds d'action, chacun avec deux sorties : `ok` vers l'étape suivante, `error` vers `kill`.
- **`job.properties`** : les variables du workflow (NameNode, ResourceManager, URL JDBC Hive, utilisateur…). Elles sont séparées du code, ce qui permet de réutiliser le même workflow dans plusieurs environnements.
- **Coordinator** : déclenche un workflow à intervalle régulier ou dès que des données sont disponibles.
- **Suivi** : `oozie job -run`, `oozie job -info` pour voir l'état de chaque action, `yarn logs` pour lire les logs d'une action.
- **Alternatives modernes** : Apache Airflow, Luigi.

## Streaming avec Kafka

- **Streaming** : traitement de données **non bornées**, en continu et avec une faible latence (par opposition au batch).
- **Kafka** : plateforme distribuée pour publier/consommer et stocker durablement des flux d'enregistrements (clé, valeur, horodatage).
- **Topics et partitions** : un topic est découpé en partitions répliquées. L'**ordre est garanti à l'intérieur d'une partition**, et les données sont conservées pendant une durée de rétention.
- **Producteurs** : ils choisissent le topic et la partition (round-robin, par clé…).
- **Groupes de consommateurs** : chaque partition est lue par un seul consommateur du groupe, ce qui permet de monter en charge et de tolérer les pannes. Chaque groupe a son propre offset.
- **Brokers** : pour chaque partition, un broker *leader* gère les lectures et écritures, et des *followers* répliquent les données.
- **Notions de traitement de flux** : temps de l'événement ou temps de traitement, **fenêtres** d'agrégation, **watermark** (le moment à partir duquel on considère avoir reçu toutes les données jusqu'à un instant donné), **triggers** (le moment où un résultat est émis).
- **Moteurs** : Spark Structured Streaming, Flink, Kafka Streams.

## NoSQL avec HBase

- **Familles NoSQL** : clé-valeur (Redis), orientée colonnes (HBase, Cassandra), documents (MongoDB), graphes (Neo4j).
- **HBase** : la base de données de Hadoop, inspirée de Google BigTable. Elle offre un accès aléatoire en lecture/écriture en temps réel et stocke ses données sur HDFS.
- **Théorème CAP** : HBase privilégie la **cohérence (CP)**, Cassandra la **disponibilité (AP)**.
- **Modèle** : une table contient des lignes identifiées par une clé. Les **familles de colonnes** sont fixées à la création, mais chaque famille peut contenir un nombre quelconque de colonnes. Chaque famille est stockée séparément.
- **Stockage** : une table est découpée en **régions** (des plages de clés), chacune servie par un **RegionServer**. Le **HMaster** attribue les régions, et **ZooKeeper** détecte les pannes.
- **Chemin d'écriture** : les données sont écrites dans le **WAL** (sur HDFS) et dans la **MemStore** (en RAM), puis vidées dans des **HFiles** sur HDFS. Des compactions ont lieu régulièrement. En cas de panne, le WAL permet de rejouer les écritures.
- **Requêtes** : shell HBase, Apache Phoenix (SQL), Hive.
