-- Divisiones de la liga
CREATE TABLE DIVISION (
    denominacionOficial VARCHAR(16) PRIMARY KEY,
    nombreComercial     VARCHAR(64)
);

-- Estadios en los que se disputan los partidos
CREATE TABLE ESTADIO (
    id                  INT PRIMARY KEY,
    nombre              VARCHAR(64),
    capacidad           INT CHECK (capacidad > 0),
    fechaInauguracion   INT
);

-- Equipos que disputan la liga
CREATE TABLE EQUIPO (
    nombreOficial       VARCHAR(64) PRIMARY KEY,
    nombreCorto         VARCHAR(32) NOT NULL,
    nombreHistorico     VARCHAR(64),
    ciudad              VARCHAR(32),
    fechaFundacion      INT,
    estadio             INT NOT NULL,

    FOREIGN KEY (estadio) REFERENCES ESTADIO(id)
);

-- Otros nombres por los que se conoce a los equipos
CREATE TABLE OTROS_NOMBRES_EQUIPO (
    equipo              VARCHAR(64) NOT NULL,
    nombre              VARCHAR(64) NOT NULL,

    PRIMARY KEY (equipo, nombre),
    FOREIGN KEY (equipo) REFERENCES EQUIPO(nombreOficial)
);

-- Partidos disputados en la liga
CREATE TABLE PARTIDO (
    division            VARCHAR(64) NOT NULL,
    temporada           INT NOT NULL CHECK (temporada > 0),
    jornada             INT NOT NULL CHECK (jornada > 0),
    equipoLocal         VARCHAR(64) NOT NULL,
    equipoVisitante     VARCHAR(64) NOT NULL,
    golesLocal          INT NOT NULL CHECK (golesLocal >= 0),
    golesVisitante      INT NOT NULL CHECK (golesVisitante >= 0),

    PRIMARY KEY (division, temporada, jornada, equipoLocal),
    FOREIGN KEY (division) REFERENCES DIVISION(denominacionOficial),
    FOREIGN KEY (equipoLocal) REFERENCES EQUIPO(nombreOficial),
    FOREIGN KEY (equipoVisitante) REFERENCES EQUIPO(nombreOficial)
);

-- Secuencia para generar IDs de estadios
CREATE SEQUENCE seq_estadio START WITH 1 INCREMENT BY 1;