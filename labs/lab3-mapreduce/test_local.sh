#!/usr/bin/env bash
# Test local sans cluster : simule map -> shuffle/sort -> reduce avec des pipes Unix
set -euo pipefail
cd "$(dirname "$0")"

# Données d'exemple au format de sortie de word_count (mot<TAB>nombre)
printf 'whale\t1685\nthe\t13604\nof\t6587\nand\t6016\n' \
  | python3 most_frequent/mapper.py \
  | sort \
  | python3 most_frequent/reducer.py
# Sortie attendue : the	13604
