SELECT DISTINCT ON (LOWER(TRIM(title)))
    TRIM(title) AS titre,
    date_added AS date_ajout,
    NULLIF(TRIM(listed_in), '') AS genres_bruts,
    COALESCE(platform_netflix, FALSE) AS est_sur_netflix,
    COALESCE(platform_hulu, FALSE) AS est_sur_hulu,
    COALESCE(platform_amazon, FALSE) AS est_sur_amazon,
    COALESCE(platform_disney, FALSE) AS est_sur_disney
FROM {{ source('streaming_raw', 'visionnage') }}
WHERE title IS NOT NULL AND TRIM(title) <> ''
ORDER BY LOWER(TRIM(title)), date_added DESC NULLS LAST