# Lab 4.1 : Hive Warehouse (table externe → table ORC)

**Objectif** : construire une petite chaîne d'entrepôt de données avec Hive. On expose un fichier CSV brut via une **table externe**, puis on le transforme et on le charge dans une **table managée au format ORC**.

📄 [Rapport avec captures (PDF)](rapport_lab4.1.pdf) · 🧾 [Requêtes (`requetes.hql`)](requetes.hql)

## Étapes

1. **Exploration** du CSV dans HDFS (`hdfs dfs -cat … | head`) pour identifier les colonnes et le format, puis copie dans mon espace personnel.
2. **Table externe** `…_nyc_drivers_ext` avec `OpenCSVSerde` et en-tête ignoré. Les données restent à leur emplacement : supprimer la table ne supprime pas le fichier.
3. **Vérification** de la lecture (`SELECT *`) : on voit les vraies valeurs, pas des `NULL`.
4. **Table managée ORC** `…_nyc_drivers`, créée vide. Son dossier apparaît dans `/warehouse/tablespace/managed/hive/`.
5. **Chargement avec transformations** (`INSERT … SELECT`) :
   - `name` découpé en `first_name` et `last_name` avec `split()` ;
   - `location` renommé en `address` ;
   - `certified` converti de texte en `BOOLEAN` avec `CASE WHEN`.
6. **Contrôle** : les données sont bien présentes dans la table, et un dossier `delta_…` au format ORC est créé dans le warehouse.

## 💡 À retenir

| | Table externe | Table managée |
|---|---|---|
| Emplacement des données | Choisi par l'utilisateur (`LOCATION`) | Warehouse Hive |
| `DROP TABLE` | Supprime seulement les métadonnées | Supprime aussi les données |
| Usage typique | Couche **brute** (raw) | Couche **nettoyée / analytique** |

- **ORC** est un format **colonne** et compressé : les requêtes analytiques ne lisent que les colonnes utiles. Sous HDP 3, les tables managées ORC sont **transactionnelles (ACID)**, d'où les dossiers `delta_…`.
- **Correction après coup** : dans le CSV, la colonne `certified` vaut `Y` ou `N`, et non `true` ou `false`. La version rendue du lab produisait donc des `NULL` pour cette colonne. Le fichier [`requetes.hql`](requetes.hql) contient la version corrigée. C'est un bon rappel qu'il faut toujours **profiler les valeurs réelles** avant d'écrire une règle de conversion.
