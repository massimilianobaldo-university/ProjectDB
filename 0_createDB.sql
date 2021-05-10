
-- create db
create database progettobasididatidb;

-- connect to db
\c progettobasididatidb;

start transaction;

-- start of table creation

CREATE TABLE Cliente(
    codice_fiscale char(15) primary key,
    nome varchar(50) not null,
    cognome varchar(50) not null,
    telefono integer
);

CREATE TABLE Prenotazione(
    codice integer primary key,
    cliente char(15) not null,
    volo integer not null,
    classe integer not null
);

CREATE TABLE Prenotazione_IstanzaDiTratta(
    codice_prenotazione integer not null,
    data_istanza_tratta date not null,
    tratta integer,
    posto_prenotato varchar(4) not null,
    primary key(codice_prenotazione, data_istanza_tratta, tratta)
);

CREATE TABLE IstanzaDiTratta(
    tratta integer, -- primary key,
    data_istanza date, -- primary key,
    aeroplano integer not null,
    numero_posti_rimanenti integer,
    primary key(tratta, data_istanza)
);

CREATE TABLE ClassePossibile(
    priorita integer primary key,
    nome varchar(50) not null unique
);

CREATE TABLE ClasseDiVolo(
    classe integer, -- primary key,
    volo integer, -- primary key,
    prezzo real not null,
    primary key(classe, volo)
);

CREATE TABLE Volo(
    codice integer primary key,
    orario_previsto_partenza time not null,
    orario_previsto_arrivo time not null,
    aeroporto_partenza integer not null,
    aeroporto_arrivo integer not null,
    compagnia_aerea integer not null
);

CREATE TABLE GiorniDellaSettimana_Volo(
    giorno_settimana varchar(10), -- primary key,
    volo integer, -- primary key
    primary key(giorno_settimana, volo)
);

CREATE TABLE Volo_Tratta(
    tratta integer, -- primary key,
    volo integer, -- primary key,
    numero_progressivo integer not null,
    primary key(tratta, volo)
);

CREATE TABLE GiorniDellaSettimana(
    nome varchar(10) primary key
);

CREATE TABLE CompagniaAerea(
    nome varchar(20) primary key
);

CREATE TABLE CompagniaAerea_Aeroplano(
    compagnia_aerea varchar(20), -- primary key,
    aeroplano integer, -- primary key
    primary key(compagnia_aerea, aeroplano)
);

CREATE TABLE Aeroplano(
    codice integer primary key,
    numero_posti integer not null,
    tipo_aeroplano varchar(20)
);

CREATE TABLE TipoDiAeroplano(
    nome varchar(20) primary key,
    numero_posti_massimo integer not null,
    azienda_costruttrice varchar(20) not null,
    autonomia_di_volo integer not null
);

CREATE TABLE PuoDecollare(
    tipo_aeroplano varchar(20), -- primary key,
    aeroporto integer, -- primary key
    primary key(tipo_aeroplano, aeroporto)
);

CREATE TABLE Aeroporto(
    codice integer primary key,
    nome varchar(50) not null,
    citta varchar(50) not null,
    nazione varchar(50) not null
);

CREATE TABLE Tratta(
    id integer primary key,
    orario_previsto_partenza time not null,
    orario_previsto_arrivo time not null,
    aeroporto_partenza integer not null,
    aeroporto_arrivo integer not null
);

-- end of table creation

-- start of table's fk definition

ALTER TABLE Prenotazione
add constraint fk_prenotazione_cliente FOREIGN KEY (cliente)
REFERENCES Cliente(codice_fiscale);

-- to do

-- end of table's fk definition

commit;
