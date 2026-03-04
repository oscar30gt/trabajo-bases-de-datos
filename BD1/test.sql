INSERT INTO PARTICIPACION (equipo, division, temporada)
SELECT DISTINCT
    e.nombreOficial, -- queremos usar el nombre oficial del equipo local
    l.DIVISION,
    l.INICIO_TEMPORADA
FROM datosdb.ligahost l, EQUIPO e
WHERE l.EQUIPO_LOCAL = e.nombreCorto;