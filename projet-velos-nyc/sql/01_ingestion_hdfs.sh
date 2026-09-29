#!/usr/bin/env bash
# Étape 1 : dépôt du CSV nettoyé dans la zone brute HDFS
# À exécuter sur le nœud edge du cluster, après transfert du fichier par scp.
set -euo pipefail

HDFS_BASE="/education/${GROUP}/${USER}/project_bike"

hdfs dfs -mkdir -p "${HDFS_BASE}/raw"
hdfs dfs -put -f ~/bike_ny.csv "${HDFS_BASE}/raw/"

# Vérifications
hdfs dfs -ls "${HDFS_BASE}/raw"
hdfs dfs -du -h "${HDFS_BASE}/raw"
hdfs dfs -cat "${HDFS_BASE}/raw/bike_ny.csv" | head
