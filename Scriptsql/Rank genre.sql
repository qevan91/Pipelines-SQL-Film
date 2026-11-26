WITH RECURSIVE MultiGenre AS ( -- ceux script nous permet de prendre chaque genre aprés la virgule car avec une seule boucle on aura accées seulement a un genre alors que la il va allez premier puis deuxieme jusqu'a ce qu'il rencontre plus rien
select title,1 AS n,
trim(split_part(listed_in,',',1)) AS Premiergenre,listed_in
From film
UNION ALL

-- l'ajout de trim a etait faite pour la cohésion sr la donnée car des fois il posséder des espace 

select 
title,n+1,trim(split_part(listed_in,',',n+1)),listed_in
from Multigenre
where trim(split_part(listed_in,',',n+1)) <> ''
), -- une deuxieme with pour pouvoir récuperer le resultat des mtt par genre pour ainsi faire les rang sans cela il est  impossible de récuperer le tableau

mttotale AS (
	select premiergenre,
		count(premiergenre) as mtt
	from Multigenre
	group by premiergenre
)
select *,
ROW_NUMBER() OVER (ORDER BY mtt DESC NULLS LAST ) AS Rang
From mttotale