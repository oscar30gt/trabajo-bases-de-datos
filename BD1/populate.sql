----------------------------------------------------------
------------------------ DIVISION ------------------------
----------------------------------------------------------

INSERT INTO DIVISION (denominacionOficial, nombreComercial) 
SELECT DISTINCT l.DIVISION, NULL
FROM datosdb.ligahost l
WHERE l.DIVISION IS NOT NULL;

----------------------------------------------------------
------------------------ ESTADIO -------------------------
----------------------------------------------------------

INSERT INTO ESTADIO (id, nombre, capacidad, fechaInauguracion)
SELECT seq_estadio.NEXTVAL,
       Estadio,
       Aforo,
       Fecha_Inag
FROM (
    SELECT DISTINCT Estadio, Aforo, Fecha_Inag
    FROM datosdb.ligahost
    WHERE Estadio IS NOT NULL
);

----------------------------------------------------------
------------------------ EQUIPO --------------------------
----------------------------------------------------------

INSERT INTO EQUIPO (nombreOficial, nombreCorto, nombreHistorico, 
                     ciudad, fechaFundacion, estadio)
SELECT DISTINCT
       l.Club,
       l.EQUIPO_LOCAL,
       l.Nombre,
       l.Ciudad,
       l.Fundacion,
       e.id
FROM datosdb.ligahost l, ESTADIO e
WHERE l.Estadio = e.nombre
AND l.EQUIPO_LOCAL IS NOT NULL;

----------------------------------------------------------
------------------ OTROS_NOMBRES_EQUIPO ------------------
----------------------------------------------------------

-- LA TABLA OTROS_NOMBRES_EQUIPO NO SE PUEDE POBLAR CON LOS DATOS DISPONIBLES, 
-- YA QUE NO HAY INFORMACIÓN SOBRE OTROS NOMBRES DE LOS EQUIPOS

-----------------------------------------------------------
------------------------- PARTIDO -------------------------
-----------------------------------------------------------

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