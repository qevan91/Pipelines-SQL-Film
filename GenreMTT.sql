WITH RECURSIVE MultiGenre AS (
select title,1 AS n,
trim(split_part(listed_in,',',1)) AS Premiergenre,listed_in
From film
UNION ALL

--

select 
title,n+1,trim(split_part(listed_in,',',n+1)),listed_in
from Multigenre
where trim(split_part(listed_in,',',n+1)) <> ''
)

select premiergenre,
count(premiergenre) as mtt
from Multigenre
group by premiergenre