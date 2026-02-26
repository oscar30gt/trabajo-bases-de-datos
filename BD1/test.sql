INSERT INTO PARTIDO (division, temporada, jornada, equipoLocal, equipoVisitante, golesLocal, golesVisitante)
SELECT
    l.DIVISION,
    l.INICIO_TEMPORADA,
    l.JORNADA,
    e1.nombreOficial, -- queremos usar el nombre oficial del equipo local
    e2.nombreOficial, -- queremos usar el nombre oficial del equipo visitante
    l.GOLES_LOCAL,
    l.GOLES_VISITANTE
FROM datosdb.ligahost l, EQUIPO e1, EQUIPO e2
WHERE l.EQUIPO_LOCAL = e1.nombreCorto
AND l.EQUIPO_VISITANTE = e2.nombreCorto;