CREATE TABLE Division (
    denominacionOficial VARCHAR(255) PRIMARY KEY,
    nombreComercial VARCHAR(255)
);

CREATE TABLE Estadio (
    id INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL, -- estadio
    capacidad INT, -- aforo
    fechaInauguracion DATE -- fechainaug
);

CREATE TABLE Equipo (
    nombreOficial VARCHAR(255) PRIMARY KEY, --club
    nombreCorto VARCHAR(255) NOT NULL, -- equipolocal/equipovisitante
    nombreHistorico VARCHAR(255), -- nada
    ciudad VARCHAR(255), -- ciudad
    fechaFundacion DATE , -- fundacion
    estadio INT NOT NULL, -- estadio
    FOREIGN KEY (estadio) REFERENCES ESTADIO(id)
);

CREATE TABLE Otros_nombres_equipo (
    equipo VARCHAR(255) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    PRIMARY KEY (equipo, nombre),
    FOREIGN KEY (equipo) REFERENCES EQUIPO(nombreOficial)
);

CREATE TABLE Participacion (
    temporada INT NOT NULL,
    equipo VARCHAR(255) NOT NULL,
    division VARCHAR(255) NOT NULL,
    PRIMARY KEY (temporada, equipo),
    FOREIGN KEY (equipo) REFERENCES EQUIPO(nombreOficial),
    FOREIGN KEY (division) REFERENCES DIVISION(denominacionOficial)
);

CREATE TABLE Partido (
    temporada INT NOT NULL,
    jornada INT NOT NULL,
    equipoLocal VARCHAR(255) NOT NULL,
    equipoVisitante VARCHAR(255) NOT NULL,
    golesLocal INT NOT NULL,
    golesVisitante INT NOT NULL,
    PRIMARY KEY (temporada, jornada, equipoLocal),
    FOREIGN KEY (equipoLocal) REFERENCES EQUIPO(nombreOficial),
    FOREIGN KEY (equipoVisitante) REFERENCES EQUIPO(nombreOficial)
);

CREATE SEQUENCE seq_estadio START WITH 1 INCREMENT BY 1;