SELECT
    title,
    CASE -- verifie si la colonne est vrai elle sera afficher seulement apres le where du coup on a que si il s'agit de la platform unique
        WHEN platform_netflix THEN 'netflix'
        WHEN platform_hulu    THEN 'hulu'
        WHEN platform_amazon  THEN 'amazon'
        WHEN platform_disney  THEN 'disney'
    END AS platform, -- création de colonne platform pour via les condition verifier dans quel platform le film est unique
    date_added,
    listed_in
FROM visionnage
WHERE COALESCE(platform_netflix::int,0) + COALESCE(platform_hulu::int,0) -- coalesce converti les bool en int
    + COALESCE(platform_amazon::int,0)  + COALESCE(platform_disney::int,0) = 1;