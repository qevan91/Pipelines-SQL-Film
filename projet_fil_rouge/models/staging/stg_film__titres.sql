SELECT
    TRIM(title) AS titre,
    LOWER(TRIM(type)) AS type_contenu,
    NULLIF(TRIM(director), '') AS realisateur,
    NULLIF(TRIM("cast"), '') AS casting,
    COALESCE(NULLIF(TRIM(country), ''), 'Inconnu') AS pays,
    date_added AS date_ajout,
    release_year AS annee_sortie,
    NULLIF(TRIM(rating), '') AS classification,
    NULLIF(TRIM(duration), '') AS duree,
    NULLIF(TRIM(listed_in), '') AS genres_bruts,
    description
FROM {{ source('streaming_raw', 'film') }}
WHERE title IS NOT NULL AND TRIM(title) <> ''