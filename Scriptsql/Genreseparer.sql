WITH RECURSIVE MultiGenre AS (-- ceux script nous permet de prendre chaque genre aprés la virgule car avec une seule boucle on aura accées seulement a un genre alors que la il va allez premier puis deuxieme jusqu'a ce qu'il rencontre plus rien
select title,1 AS n,
trim(split_part(listed_in,',',1)) AS Premiergenre,listed_in
From film
UNION ALL


select 
title,n+1,trim(split_part(listed_in,',',n+1)),listed_in
from Multigenre
where trim(split_part(listed_in,',',n+1)) <> '' -- Zone d'arret 
)

select * 
from Multigenre
order by title