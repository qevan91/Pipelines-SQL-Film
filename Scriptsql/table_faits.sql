DROP TABLE IF EXISTS visionner;

CREATE TABLE visionner (
    id_visionner           SERIAL PRIMARY KEY,
    title                  TEXT NOT NULL,
    date_added             DATE,
    listed_in              TEXT,
    plateforme_netflix     TEXT,
    plateforme_amazon_plus TEXT,
    plateforme_disney_plus TEXT,
    plateforme_hulu        TEXT
);

WITH titres_uniques AS (
    SELECT DISTINCT ON (LOWER(TRIM(title)))
        title,
        date_added,
        listed_in
    FROM film
    WHERE title IS NOT NULL AND TRIM(title) <> ''
    ORDER BY LOWER(TRIM(title)), date_added DESC NULLS LAST
)
INSERT INTO visionner (
    title,
    date_added,
    listed_in,
    plateforme_netflix,
    plateforme_amazon_plus,
    plateforme_disney_plus,
    plateforme_hulu
)
SELECT
    t.title,
    t.date_added,
    t.listed_in,
    CASE WHEN EXISTS (
        SELECT 1 FROM netflix n WHERE LOWER(TRIM(n.title)) = LOWER(TRIM(t.title))
    ) THEN 'Netflix' ELSE NULL END AS plateforme_netflix,
    CASE WHEN EXISTS (
        SELECT 1 FROM amazon_prime a WHERE LOWER(TRIM(a.title)) = LOWER(TRIM(t.title))
    ) THEN 'Amazon Prime' ELSE NULL END AS plateforme_amazon_plus,
    CASE WHEN EXISTS (
        SELECT 1 FROM disney_plus d WHERE LOWER(TRIM(d.title)) = LOWER(TRIM(t.title))
    ) THEN 'Disney+' ELSE NULL END AS plateforme_disney_plus,
    CASE WHEN EXISTS (
        SELECT 1 FROM hulu h WHERE LOWER(TRIM(h.title)) = LOWER(TRIM(t.title))
    ) THEN 'Hulu' ELSE NULL END AS plateforme_hulu
FROM titres_uniques t;