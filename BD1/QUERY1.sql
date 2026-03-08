-- Para cada una de las últimas cinco temporadas de segunda división almacenadas en la base de datos
-- se quiere averiguar en qué jornada de cada temporada se marcaron más goles. Listar las temporadas
-- junto al número de jornada obtenido y el número de goles marcados en dicha jornada.

-- Formato de salida: temporada | jornada | total_goles
SELECT p.temporada, p.jornada, SUM(p.golesLocal + p.golesVisitante) TotalGoles
FROM PARTIDO p              --    partidos...
WHERE p.division = '2'      -- ...de segunda división...
AND p.temporada IN (        -- ...jugados en las últimas cinco temporadas
    SELECT DISTINCT p1.temporada
    FROM PARTIDO p1
    WHERE p1.division = '2'
    AND (
        SELECT COUNT(*) -- Para cada temporada, contamos cuántas temporadas posteriores hay.
        FROM ( 
			SELECT DISTINCT p2.temporada
			FROM PARTIDO p2
			WHERE p2.division = '2'
			AND p2.temporada > p1.temporada
        )
    ) < 5 -- Solo temporadas que tienen menos de 5 temporadas posteriores (las 5 últimas)
)
GROUP BY p.temporada, p.jornada
HAVING SUM(p.golesLocal + p.golesVisitante) = ( -- Solo mostramos la jornada de cada temporada con el máximo número de goles
    SELECT MAX(GolesPorJornada)
    FROM (
		-- Para cada temporada, calculamos el número de goles por jornada
        SELECT SUM(p3.golesLocal + p3.golesVisitante) GolesPorJornada
        FROM PARTIDO p3
        WHERE p3.temporada = p.temporada AND p3.division = '2'
        GROUP BY p3.jornada
    )
)
ORDER BY p.temporada DESC;