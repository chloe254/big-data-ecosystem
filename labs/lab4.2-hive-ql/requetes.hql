-- Lab 4.2 : Hive Query Language sur le jeu de données IMDb
-- Tables : imdb_title_basics, imdb_title_ratings, imdb_title_crew, imdb_name_basics

USE ${hivevar:db};
SHOW TABLES;

-- Q1. Nombre de titres de plus de 2 h
SELECT COUNT(*) AS nb_titles_over_2h
FROM imdb_title_basics
WHERE runtimeMinutes > 120;
-- Résultat : 151 676

-- Q2. Durée moyenne des titres contenant le mot entier "world"
--     ("World War Z" oui, "Underworld" non) grâce à une expression régulière
SELECT AVG(runtimeMinutes) AS avg_duration_world
FROM imdb_title_basics
WHERE primaryTitle  RLIKE '(^|[^A-Za-z])world([^A-Za-z]|$)'
   OR originalTitle RLIKE '(^|[^A-Za-z])world([^A-Za-z]|$)';
-- Résultat : 25,6 minutes

-- Q3. Note moyenne des titres dont les genres contiennent "Comedy"
--     (genres est un tableau : array_contains plutôt qu'une égalité)
SELECT AVG(r.averageRating) AS avg_rating_comedy
FROM imdb_title_basics b
JOIN imdb_title_ratings r ON b.tconst = r.tconst
WHERE array_contains(b.genres, 'Comedy');
-- Résultat : 6,89

-- Q4. Même calcul en excluant les comédies
SELECT AVG(r.averageRating) AS avg_rating_non_comedy
FROM imdb_title_basics b
JOIN imdb_title_ratings r ON b.tconst = r.tconst
WHERE NOT array_contains(b.genres, 'Comedy');
-- Résultat : 6,97

-- Q5. Top 5 des films réalisés par Quentin Tarantino (jointure sur 4 tables)
-- Étape 1 : identifiant de la personne
SELECT *
FROM imdb_name_basics
WHERE primaryName = 'Quentin Tarantino';
-- nconst = nm0000233

-- Étape 2 : ses films les mieux notés
SELECT b.primaryTitle, r.averageRating, r.numVotes
FROM imdb_title_crew c
JOIN imdb_title_basics  b ON c.tconst = b.tconst
JOIN imdb_title_ratings r ON b.tconst = r.tconst
WHERE array_contains(c.director, 'nm0000233')
  AND b.titleType = 'movie'
ORDER BY r.averageRating DESC, r.numVotes DESC
LIMIT 5;
-- Résultat : Kill Bill: The Whole Bloody Affair (8,8), Pulp Fiction (8,8),
--            Django Unchained (8,5), Inglourious Basterds (8,4), Reservoir Dogs (8,3)
