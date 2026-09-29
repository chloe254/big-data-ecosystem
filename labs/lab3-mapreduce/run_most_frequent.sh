#!/usr/bin/env bash
# Lance le job Hadoop Streaming "most_frequent" sur la sortie du job word_count
set -euo pipefail

BASE="/education/${GROUP}/${USER}/lab3"

mapred streaming -D stream.non.zero.exit.is.failure=false \
  -files most_frequent/mapper.py,most_frequent/reducer.py \
  -input  "${BASE}/word-count" \
  -output "${BASE}/most-frequent" \
  -mapper  "python3 mapper.py" \
  -reducer "python3 reducer.py"

hdfs dfs -cat "${BASE}/most-frequent/part-*"
