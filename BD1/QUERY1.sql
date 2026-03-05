-- Para cada una de las últimas cinco temporadas de segunda división almacenadas en la base de datos
-- se quiere averiguar en qué jornada de cada temporada se marcaron más goles. Listar las temporadas
-- junto al número de jornada obtenido y el número de goles marcados en dicha jornada.

-- Seleccionamos las últimas cinco temporadas de segunda división
WITH UltimasTemporadas AS (
    SELECT DISTINCT p1.temporada
    FROM PARTIDO p1
    WHERE p1.division = '2' -- Solo segunda división
    AND ( 
        SELECT COUNT(*) -- Para cada temporada, contamos cuántas temporadas posteriores hay
        FROM ( 
                SELECT DISTINCT p2.temporada
                FROM PARTIDO p2
                WHERE p2.division = '2'
                AND p2.temporada > p1.temporada
        )
    ) < 5 -- Solo temporadas que tienen menos de 5 temporadas posteriores (las 5 últimas)
)
SELECT p1.temporada, p1.jornada, SUM(p1.golesLocal + p1.golesVisitante) TotalGoles
FROM PARTIDO p1, UltimasTemporadas u
WHERE p1.temporada = u.temporada -- Solo partidos de las últimas cinco temporadas
AND p1.division = '2' -- Solo segunda división
GROUP BY p1.temporada, p1.jornada -- Agrupamos por temporada y jornada para sumar los goles
HAVING SUM(p1.golesLocal + p1.golesVisitante) = ( 
    SELECT MAX(SUM(p2.golesLocal + p2.golesVisitante)) -- Partido con el mayor número de goles en cada temporada
    FROM PARTIDO p2
    WHERE p2.temporada = p1.temporada -- Misma temporada
    AND p2.division = '2' -- Segunda división
    GROUP BY p2.temporada, p2.jornada
) -- Seleccionamos solo la/s jornada/s de cada temporada con el máximo número de goles
ORDER BY p1.temporada DESC;