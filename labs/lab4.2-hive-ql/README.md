# Lab 4.2 - Requêtes HiveQL sur IMDb

Requêtes sur les tables IMDb (`title_basics`, `title_ratings`, `title_crew`, `name_basics`). Rapport : [rapport_lab4.2.pdf](rapport_lab4.2.pdf), requêtes : [requetes.hql](requetes.hql).

1. Nombre de titres de plus de 2 h : 151 676.
2. Durée moyenne des titres qui contiennent le mot « world » : 25,6 min. J'ai utilisé `RLIKE` avec des délimiteurs pour ne garder que le mot entier (« World War Z » oui, « Underworld » non).
3. Note moyenne des comédies : 6,89. La colonne `genres` est un tableau, d'où `array_contains`.
4. Note moyenne hors comédies : 6,97.
5. Top 5 des films de Quentin Tarantino, avec une jointure sur 4 tables. Je récupère d'abord son identifiant (`nm0000233`), puis je trie ses films par note et par nombre de votes. On obtient Kill Bill: The Whole Bloody Affair et Pulp Fiction (8,8), Django Unchained (8,5), Inglourious Basterds (8,4) et Reservoir Dogs (8,3) ([capture](captures/top5_tarantino.png)).
