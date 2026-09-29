# Notes de révision

## Oozie

- Oozie est un ordonnanceur de workflows pour Hadoop. Il enchaîne des actions HDFS, Hive, MapReduce ou Spark.
- Un workflow est un DAG décrit dans `workflow.xml`. Il contient des nœuds de contrôle (`start`, `end`, `kill`, et `decision` / `fork` / `join` pour les branches) et des actions. Chaque action a une sortie `ok` et une sortie `error`.
- `job.properties` contient les variables (NameNode, ResourceManager, URL JDBC, utilisateur…). On peut donc réutiliser le même workflow d'un environnement à l'autre.
- Un coordinator lance un workflow à intervalle régulier, ou quand des données arrivent.
- Pour le suivi : `oozie job -run`, `oozie job -info`, puis `yarn logs` pour lire les logs d'une action.
- Alternatives : Airflow, Luigi.

## Kafka

- Le streaming, c'est traiter des données en continu, sans fin définie, avec peu de latence.
- Kafka publie, stocke et distribue des flux de messages (clé, valeur, timestamp).
- Un topic est découpé en partitions, qui sont répliquées. L'ordre des messages n'est garanti qu'à l'intérieur d'une partition. Les messages sont gardés pendant une durée de rétention.
- C'est le producteur qui choisit la partition (round-robin, par clé…).
- Dans un groupe de consommateurs, chaque partition est lue par un seul consommateur, ce qui permet de répartir la charge. Chaque groupe garde son propre offset.
- Pour chaque partition, un broker est leader (lectures et écritures) et les autres sont followers (réplication).
- En traitement de flux, il faut distinguer le temps de l'événement du temps de traitement. On agrège par fenêtres. Le watermark marque le moment où l'on considère avoir reçu toutes les données jusqu'à un instant donné, et les triggers décident quand émettre un résultat.
- Moteurs : Spark Structured Streaming, Flink, Kafka Streams.

## HBase

- Il existe plusieurs familles de bases NoSQL : clé-valeur (Redis), colonnes (HBase, Cassandra), documents (MongoDB), graphes (Neo4j).
- HBase est une base orientée colonnes, construite sur HDFS et inspirée de BigTable. On y accède en lecture et en écriture en temps réel.
- Selon le théorème CAP, HBase est CP, alors que Cassandra est plutôt AP.
- Une table contient des lignes, identifiées par une clé. Les familles de colonnes sont fixées à la création de la table, mais on peut ajouter autant de colonnes qu'on veut dans chaque famille.
- Une table est découpée en régions (des plages de clés), chacune gérée par un RegionServer. Le HMaster répartit les régions, et ZooKeeper détecte les pannes.
- À l'écriture, les données vont dans le WAL (sur HDFS) et dans la MemStore (en RAM), puis sont vidées dans des HFiles. En cas de panne, on rejoue le WAL.
- On l'interroge avec le shell HBase, Phoenix (SQL) ou Hive.
