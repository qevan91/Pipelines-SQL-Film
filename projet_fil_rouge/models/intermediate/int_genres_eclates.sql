WITH RECURSIVE genres_par_titre AS (
    SELECT
        titre,
        1 AS rang_genre,
        TRIM(SPLIT_PART(genres_bruts, ',', 1)) AS genre,
        genres_bruts
    FROM {{ ref('stg_film__titres') }}
    WHERE genres_bruts IS NOT NULL

    UNION ALL

    SELECT
        titre,
        rang_genre + 1,
        TRIM(SPLIT_PART(genres_bruts, ',', rang_genre + 1)),
        genres_bruts
    FROM genres_par_titre
    WHERE TRIM(SPLIT_PART(genres_bruts, ',', rang_genre + 1)) <> ''
)
SELECT
    titre,
    rang_genre,
    genre
FROM genres_par_titre