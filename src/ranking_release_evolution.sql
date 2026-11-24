WITH Laglist AS (
select release_year,
count(release_year) AS mttactuelle,
LAG(count(release_year)) OVER (ORDER BY release_year) AS annee_count,
ROUND(count(release_year) - LAG(count(release_year)) OVER (ORDER BY release_year)) AS evolution
from netflix
group by (release_year)
)
Select release_year,evolution,mttactuelle,
ROW_NUMBER() OVER  (ORDER BY evolution DESC NULLS LAST) AS Rang
FROM Laglist