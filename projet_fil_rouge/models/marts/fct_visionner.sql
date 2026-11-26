-- Grain : 1 ligne = 1 titre unique du catalogue avec ses booléens de présence par plateforme
SELECT
    v.titre,
    v.date_ajout,
    f.type_contenu,
    f.annee_sortie,
    f.pays,
    f.classification,
    f.duree,
    v.genres_bruts,
    v.est_sur_netflix,
    v.est_sur_hulu,
    v.est_sur_amazon,
    v.est_sur_disney,
    (
        CASE WHEN v.est_sur_netflix THEN 1 ELSE 0 END +
        CASE WHEN v.est_sur_hulu    THEN 1 ELSE 0 END +
        CASE WHEN v.est_sur_amazon  THEN 1 ELSE 0 END +
        CASE WHEN v.est_sur_disney  THEN 1 ELSE 0 END
    ) AS nb_plateformes
FROM {{ ref('stg_visionner__catalogue') }} v
LEFT JOIN (
    SELECT DISTINCT ON (LOWER(titre))
        LOWER(titre) AS titre_cle,
        type_contenu,
        annee_sortie,
        pays,
        classification,
        duree
    FROM {{ ref('stg_film__titres') }}
    ORDER BY LOWER(titre), date_ajout DESC NULLS LAST
) f
    ON LOWER(v.titre) = f.titre_cle