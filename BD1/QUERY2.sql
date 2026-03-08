-- Equipo(s) que han estado en primera división un mínimo de veinticinco temporadas y que no han
-- ganado ninguna liga.

-- Alias con los puntos de cada equipo en cada temporada de primera división
-- Formato: temporada | equipo | puntos
WITH PuntosTemporada AS (
    SELECT p.temporada, e.nombreOficial equipo, ((
			-- Victorias ( +3 puntos )
			-- Por cada equipo y temporada, contamos cuántas victorias ha tenido ese equipo en esa temporada (mas goles que el rival)
			SELECT COUNT(*) FROM PARTIDO pV
             WHERE pV.temporada = p.temporada AND pV.division = '1'
               AND ((pV.equipoLocal = e.nombreOficial AND pV.golesLocal > pV.golesVisitante) OR   -- Como local
                    (pV.equipoVisitante = e.nombreOficial AND pV.golesVisitante > pV.golesLocal)) -- Como visitante
		) * 3 + (
			-- Empates ( +1 punto )
			-- Por cada equipo y temporada, contamos cuántos empates ha tenido ese equipo en esa temporada (mismos goles que el rival)
			SELECT COUNT(*) FROM PARTIDO pE
             WHERE pE.temporada = p.temporada AND pE.division = '1'
               AND (pE.equipoLocal = e.nombreOficial OR pE.equipoVisitante = e.nombreOficial)
               AND (pE.golesLocal = pE.golesVisitante) -- Da igual si es local o visitante, el empate es empate
		)) puntos
    FROM EQUIPO e, PARTIDO p
    WHERE (p.equipoLocal = e.nombreOficial OR p.equipoVisitante = e.nombreOficial)
    AND p.division = '1'
    GROUP BY p.temporada, e.nombreOficial
)
SELECT pt1.equipo
FROM PuntosTemporada pt1
GROUP BY pt1.equipo
HAVING COUNT(*) >= 25 -- Al menos 25 apariciones en primera
AND pt1.equipo NOT IN ( -- No está entre los que han sido campeones (máximos puntos de su año)
	SELECT DISTINCT pt2.equipo
	FROM PuntosTemporada pt2
	WHERE pt2.puntos = ( -- Los puntos de ese equipo son los máximos de su temporada
		SELECT MAX(puntos) 
		FROM PuntosTemporada pt3 
		WHERE pt3.temporada = pt2.temporada
	)
)
ORDER BY pt1.equipo ASC;