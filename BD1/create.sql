CREATE TABLE DIVISION (
    denominacionOficial VARCHAR(255) PRIMARY KEY,
    nombreComercial VARCHAR(255)
);

CREATE TABLE ESTADIO (
    id INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL, -- estadio
    capacidad INT, -- aforo
    fechaInauguracion INT -- fechainaug
);

CREATE TABLE EQUIPO (
    nombreOficial VARCHAR(255) PRIMARY KEY, --club
    nombreCorto VARCHAR(255) NOT NULL, -- equipolocal/equipovisitante
    nombreHistorico VARCHAR(255), -- nada
    ciudad VARCHAR(255), -- ciudad
    fechaFundacion INT , -- fundacion
    estadio INT NOT NULL, -- estadio
    FOREIGN KEY (estadio) REFERENCES ESTADIO(id)
);

CREATE TABLE OTROS_NOMBRES_EQUIPO (
    equipo VARCHAR(255) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    PRIMARY KEY (equipo, nombre),
    FOREIGN KEY (equipo) REFERENCES EQUIPO(nombreOficial)
);

CREATE TABLE PARTICIPACION (
    equipo VARCHAR(255) NOT NULL,
    division VARCHAR(255) NOT NULL,
    temporada INT NOT NULL,
    PRIMARY KEY (equipo, division, temporada),
    FOREIGN KEY (equipo) REFERENCES EQUIPO(nombreOficial),
    FOREIGN KEY (division) REFERENCES DIVISION(denominacionOficial)
);

CREATE TABLE PARTIDO (
    division VARCHAR(255) NOT NULL,
    temporada INT NOT NULL,
    jornada INT NOT NULL,
    equipoLocal VARCHAR(255) NOT NULL,
    equipoVisitante VARCHAR(255) NOT NULL,
    golesLocal INT NOT NULL,
    golesVisitante INT NOT NULL,
    PRIMARY KEY (division, temporada, jornada, equipoLocal),
    FOREIGN KEY (division) REFERENCES DIVISION(denominacionOficial),
    FOREIGN KEY (equipoLocal) REFERENCES EQUIPO(nombreOficial),
    FOREIGN KEY (equipoVisitante) REFERENCES EQUIPO(nombreOficial)
);

CREATE SEQUENCE seq_estadio START WITH 1 INCREMENT BY 1;