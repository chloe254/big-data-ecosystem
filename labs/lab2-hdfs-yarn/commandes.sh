#!/usr/bin/env bash
# Lab 2 : premiers pas sur le cluster Hadoop (HDFS + YARN)
# Prérequis : variables d'environnement GROUP et USER définies (ex. dans ~/.bashrc)
set -euo pipefail

LAB="/education/${GROUP}/${USER}/lab2"
EXAMPLES_JAR="/usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-examples-3.1.1.3.1.0.0-78.jar"

# --- HDFS : création de l'espace personnel et dépôt d'un fichier ---
hdfs dfs -mkdir -p "${LAB}"
mkdir -p ~/lab1
echo "HDFS is a distributed file system used in the Hadoop ecosystem." > ~/lab1/sentence.txt
hdfs dfs -put ~/lab1/sentence.txt "${LAB}/"
hdfs dfs -ls "${LAB}"

# Blocs, facteur de réplication et localisation sur les DataNodes
hdfs fsck "${LAB}/sentence.txt"

# --- YARN : soumission d'une application MapReduce (estimation de Pi) ---
yarn jar "${EXAMPLES_JAR}" pi 6 100000000
yarn app -list -appStates FINISHED

# --- WordCount sur les fichiers du dossier lab2 ---
yarn jar "${EXAMPLES_JAR}" wordcount "${LAB}" "${LAB}/output-wordcount"
hdfs dfs -ls "${LAB}/output-wordcount"
hdfs dfs -cat "${LAB}/output-wordcount/part-r-00000"
