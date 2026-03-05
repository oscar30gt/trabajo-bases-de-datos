-- Equipo(s) que han estado en primera división un mínimo de veinticinco temporadas y que no han
-- ganado ninguna liga.

-- Alias con los puntos de cada equipo en cada temporada de primera división
WITH PuntosTemporada AS (
    SELECT p.temporada, e.nombreOficial equipo, ((
			-- Victorias ( +3 puntos )
			SELECT COUNT(*) FROM PARTIDO pV
             WHERE pV.temporada = p.temporada AND pV.division = '1'
               AND ((pV.equipoLocal = e.nombreOficial AND pV.golesLocal > pV.golesVisitante) OR   -- Como local
                    (pV.equipoVisitante = e.nombreOficial AND pV.golesVisitante > pV.golesLocal)) -- Como visitante
		) * 3 + (
			-- Empates ( +1 punto )
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
SELECT p1.equipo
FROM PuntosTemporada p1
GROUP BY p1.equipo
HAVING COUNT(*) >= 25 -- Al menos 25 apariciones en primera
AND p1.equipo NOT IN (
	-- Subconsulta: Equipos que han sido campeones (máximos puntos de su año)
	SELECT DISTINCT p2.equipo
	FROM PuntosTemporada p2
	WHERE p2.puntos = (
		SELECT MAX(puntos) 
		FROM PuntosTemporada p3 
		WHERE p3.temporada = p2.temporada
	)
)
ORDER BY p1.equipo ASC;