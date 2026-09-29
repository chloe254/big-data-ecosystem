# Lab 3 - MapReduce en Python

Le but : trouver le mot le plus fréquent de Moby Dick, en lançant un second job MapReduce sur la sortie du job `word_count`. Rapport : [rapport_lab3.pdf](rapport_lab3.pdf).

- [mapper.py](most_frequent/mapper.py) lit les lignes `mot<TAB>nombre` et envoie tout sous une même clé `MAX`, pour que toutes les lignes arrivent dans le même reducer.
- [reducer.py](most_frequent/reducer.py) garde le mot qui a le plus grand nombre d'occurrences. En cas d'égalité, il prend le premier dans l'ordre alphabétique.
- [run_most_frequent.sh](run_most_frequent.sh) lance le job avec `mapred streaming`.

Résultat : « the », avec 13 604 occurrences ([capture](resultat.png)).

Comme Hadoop Streaming passe simplement par stdin et stdout, on peut tester le job sans cluster :

```bash
./test_local.sh
```

Envoyer tout vers une seule clé est simple, mais un seul reducer fait tout le travail. Sur un gros volume, il faudrait d'abord calculer un maximum local dans chaque mapper (ou avec un combiner).
