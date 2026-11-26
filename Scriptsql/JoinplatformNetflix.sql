SELECT n.title
FROM netflix n -- ici c'est juste pour voir les exclusivité chez netflix
LEFT JOIN disney_plus  d ON lower(trim(d.title)) = lower(trim(n.title))
LEFT JOIN hulu         h ON lower(trim(h.title)) = lower(trim(n.title))
LEFT JOIN amazon_prime a ON lower(trim(a.title)) = lower(trim(n.title))
WHERE d.title IS NULL AND h.title IS NULL AND a.title IS NULL; --
