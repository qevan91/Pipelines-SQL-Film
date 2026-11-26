WITH Laglist AS ( -- Le script disponible ici est un script qui verifie les evolution de sortis entre deux date
select release_year, -- le with permet de faire un tableau temp car c'est le seul moyen d'utiliser des colonne issus de partitionning
count(release_year) AS mttactuelle,

LAG(count(release_year)) OVER (ORDER BY release_year) AS annee_count,
ROUND(count(release_year) - LAG(count(release_year)) OVER (ORDER BY release_year)) AS evolution 
-- ici et plus haut on récupere la difference entre l'année actuelle et celle precedente pour ensuite plus bas faire un classement des écart entre les année
-- on a rajouté aussi un classement des année ou ils y a eu le plus sortis du coup on compare les date et on les expose a des evenement liée au année COVID/CRISE des subprime par exemple
from film

group by (release_year) -- permet de garder juste les année du tableau 
)
Select release_year,evolution,mttactuelle,
ROW_NUMBER() OVER  (ORDER BY evolution DESC NULLS LAST) AS Rang_evolution,
ROW_NUMBER() OVER (ORDER BY Mttactuelle DESC NULLS LAST) AS rang_mtt
FROM Laglist -- le resultat démontre que la période du COVID n'as pas entacher la production de film mais a augmenter les sortis