# Big Data Ecosystem

Travaux du cours Big Data Ecosystem à l'ECE Paris, faits sur le cluster Hadoop de l'école (HDP 3, sécurisé par Kerberos).

## Projet

[projet-velos-nyc](projet-velos-nyc/) : pipeline batch sur les données Citi Bike de New York, fait avec Edouard Menut. Le CSV est nettoyé en Python, déposé dans HDFS, exposé par une table externe Hive puis transformé dans une table ORC, et enfin analysé en HiveQL. En bonus, on a ajouté un second fichier pour simuler des données qui arrivent après coup, et on a réuni les deux dans une vue commune.

## Labs

| Lab | Sujet |
|---|---|
| [lab2-hdfs-yarn](labs/lab2-hdfs-yarn/) | Prise en main du cluster : HDFS, jobs YARN, WordCount, accès aux interfaces web avec Kerberos |
| [lab3-mapreduce](labs/lab3-mapreduce/) | Job MapReduce en Python (Hadoop Streaming) pour trouver le mot le plus fréquent |
| [lab4.1-hive-warehouse](labs/lab4.1-hive-warehouse/) | Table externe sur un CSV, puis chargement dans une table ORC |
| [lab4.2-hive-ql](labs/lab4.2-hive-ql/) | Requêtes HiveQL sur les données IMDb |

## Notes de cours

[fiches](fiches/) : mes notes de révision sur Oozie, Kafka et HBase.
