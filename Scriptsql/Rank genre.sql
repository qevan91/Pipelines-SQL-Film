WITH RECURSIVE MultiGenre AS (
select title,1 AS n,
trim(split_part(listed_in,',',1)) AS Premiergenre,listed_in
From film
UNION ALL

-- l'ajout de trim a etait faite pour la cohésion sr la donnée car des fois il posséder des espace 

select 
title,n+1,trim(split_part(listed_in,',',n+1)),listed_in
from Multigenre
where trim(split_part(listed_in,',',n+1)) <> ''
),

mttotale AS (
	select premiergenre,
		count(premiergenre) as mtt
	from Multigenre
	group by premiergenre
)
select *,
ROW_NUMBER() OVER (ORDER BY mtt DESC NULLS LAST ) AS Rang
From mttotale