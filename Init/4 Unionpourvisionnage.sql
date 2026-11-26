INSERT INTO visionnage (title, platform_netflix, platform_hulu, platform_amazon, platform_disney, date_added, listed_in)
SELECT
    MIN(title),
    BOOL_OR(plateforme = 'netflix'),
    BOOL_OR(plateforme = 'hulu'),
    BOOL_OR(plateforme = 'amazon_prime'),
    BOOL_OR(plateforme = 'disney_plus'),
    MIN(date_added),
    MIN(listed_in)
FROM (
    SELECT title, date_added, listed_in, type, 'netflix'      AS plateforme FROM netflix
    UNION ALL
    SELECT title, date_added, listed_in, type, 'hulu'         FROM hulu
    UNION ALL
    SELECT title, date_added, listed_in, type, 'amazon_prime' FROM amazon_prime
    UNION ALL
    SELECT title, date_added, listed_in, type, 'disney_plus'  FROM disney_plus
) t
WHERE title IS NOT NULL AND date_added IS NOT NULL AND listed_in IS NOT NULL
GROUP BY lower(trim(title)), type;