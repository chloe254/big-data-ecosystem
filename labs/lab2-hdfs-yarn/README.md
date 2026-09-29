# Lab 2 - HDFS, YARN et Kerberos

Prise en main du cluster Hadoop de l'école. Rapport : [rapport_lab2.pdf](rapport_lab2.pdf), commandes : [commandes.sh](commandes.sh).

- HDFS : création de mon dossier dans l'espace du groupe, envoi d'un fichier, puis `hdfs fsck` pour voir les blocs. Le fichier est répliqué 2 fois, sur 2 DataNodes ([capture](captures/hdfs_fsck.png)).
- YARN : lancement du job d'exemple `pi`, puis suivi avec `yarn app -list`.
- WordCount : lancement de l'exemple MapReduce sur les fichiers du lab et lecture du résultat dans `part-r-00000` ([capture](captures/wordcount_resultat.png)).
- SSH : connexion sans mot de passe avec une clé RSA et `ssh-copy-id`.
- Kerberos : configuration de `krb5.ini`, création d'un ticket avec MIT Kerberos et réglage de Firefox pour accéder à l'interface web de YARN.

J'ai lancé le job `pi` trois fois de suite. Il a mis 31 s, puis 9 s, puis 19 s. La différence vient de la charge du cluster au moment où le job est soumis : YARN n'attribue pas toujours les mêmes ressources.
