# Lab 4.1 - Hive Warehouse

Chargement d'un CSV (liste de chauffeurs) dans Hive, d'abord dans une table externe, puis dans une table managée au format ORC. Rapport : [rapport_lab4.1.pdf](rapport_lab4.1.pdf), requêtes : [requetes.hql](requetes.hql).

1. Lecture des premières lignes du CSV dans HDFS pour repérer les colonnes, puis copie dans mon dossier.
2. Création de la table externe `_nyc_drivers_ext` (OpenCSVSerde, en-tête ignoré). Les données restent là où elles sont : un `DROP TABLE` ne supprime pas le fichier.
3. Création de la table managée ORC `_nyc_drivers`. Hive la range dans son warehouse (`/warehouse/tablespace/managed/hive/`).
4. `INSERT ... SELECT` avec quelques transformations : `name` est découpé en `first_name` et `last_name`, `location` devient `address`, et `certified` passe en booléen.

Remarque : dans le CSV, `certified` vaut `Y` ou `N`. Ma première version testait `'true'` et `'false'`, donc la colonne est ressortie à `NULL` partout (on le voit dans le rapport). La requête du fichier `requetes.hql` est corrigée.
