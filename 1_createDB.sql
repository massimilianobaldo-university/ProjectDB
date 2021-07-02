-- create db
create database progettobasididatidb;

-- connect to db
\c progettobasididatidb;

start transaction;

-- domains 
CREATE dom_codice_fiscale AS char(16);

CREATE dom_telefono AS text
   CONSTRAINT valid_dom_telefono 
   CHECK (value ~ '^[0-9]+$');

CREATE dom_codice_prenotazione AS text
   CONSTRAINT valid_dom_codice_prenotazione 
   CHECK (value ~ '^[0-9]+$');

CREATE dom_codice_tratta AS text
   CONSTRAINT valid_dom_codice_tratta 
   CHECK (value ~ '^[0-9]+$');
   
CREATE dom_codice_aeroporto AS char(3)
   CONSTRAINT valid_dom_codice_aeroporto 
   CHECK (value ~ '^[A-Z]+$');

CREATE dom_posto_aereo AS varchar(3)
   CONSTRAINT valid_dom_dom_posto_aereo 
   CHECK (value ~ '^[0-9]{1,2}[A-Z]$');
   
CREATE dom_codice_volo AS varchar(6)
   CONSTRAINT valid_dom_codice_volo 
   CHECK (value ~ '^[A-Z]{1,2}[0-9]{2,4}$');
   
CREATE dom_tipo_aeroplano AS varchar(6)
   CONSTRAINT valid_dom_tipo_aeroplano 
   CHECK (value ~ '^[A-Z]{0,3}[0-9]{2,3}$');

CREATE dom_compagnia_aerea AS text;

-- start of table creation
CREATE TABLE Cliente(
    codice_fiscale dom_codice_fiscale primary key,
    nome varchar(50) not null,
    cognome varchar(50) not null,
    telefono dom_telefono
);

CREATE TABLE Prenotazione(
    codice dom_codice_prenotazione primary key,
    cliente dom_codice_fiscale not null,  -- FK: Cliente.codice_fiscale
    volo dom_codice_volo not null,      -- FK: ClasseDiVolo.volo
    classe integer not null     -- FK: ClasseDiVolo.classe
);

CREATE TABLE Prenotazione_IstanzaDiTratta(
    codice_prenotazione dom_codice_prenotazione not null,   -- FK: Prenotazione.codice
    data_istanza_tratta date not null,      -- FK: IstanzaDiTratta.data_istanza
    tratta dom_codice_tratta,                         -- FK: IstanzaDiTratta.tratta
    posto_prenotato dom_posto_aereo not null,
    primary key(codice_prenotazione, data_istanza_tratta, tratta)
);

CREATE TABLE IstanzaDiTratta(
    tratta dom_codice_tratta,                 -- PK, FK: Tratta.id
    data_istanza date,              -- PK
    aeroplano integer not null,     -- FK: Aeroplano.codice
    numero_posti_rimanenti integer,
    primary key(tratta, data_istanza)
);

CREATE TABLE ClassePossibile(
    priorita integer primary key,
    nome varchar(50) not null unique
);

CREATE TABLE ClasseDiVolo(
    classe integer,         -- PK, FK: ClassePossibile.priorita
    volo dom_codice_volo,           -- PK, FK: Volo.codice
    prezzo real not null,
    primary key(classe, volo)
);

CREATE TABLE Volo(
    codice dom_codice_volo primary key,
    orario_previsto_partenza time not null,
    orario_previsto_arrivo time not null,
    aeroporto_partenza dom_codice_aeroporto not null,
    aeroporto_arrivo dom_codice_aeroporto not null,
    compagnia_aerea dom_compagnia_aerea not null        -- FK: CompagniaAerea.nome
);

CREATE TABLE GiorniDellaSettimana_Volo(
    giorno_settimana varchar(10),           -- PK, FK: GiorniDellaSettimana.nome
    volo dom_codice_volo,                           -- PK, FK: Volo.codice
    primary key(giorno_settimana, volo)
);

CREATE TABLE Volo_Tratta(
    tratta dom_codice_tratta,     -- PK, FK: Tratta.id
    volo dom_codice_volo,       -- PK, FK: Volo.codice
    numero_progressivo integer not null,
    primary key(tratta, volo)
);

CREATE TABLE GiorniDellaSettimana(
    nome varchar(10) primary key
);

CREATE TABLE CompagniaAerea(
    nome dom_compagnia_aerea primary key
);

CREATE TABLE CompagniaAerea_Aeroplano(
    compagnia_aerea dom_compagnia_aerea,    -- PK, FK: CompagniaAerea.nome
    aeroplano integer,              -- PK, FK: Aeroplano.codice
    primary key(compagnia_aerea, aeroplano)
);

CREATE TABLE Aeroplano(
    codice integer primary key,
    numero_posti integer not null,
    tipo_aeroplano dom_tipo_aeroplano      -- FK: TipoDiAeroplano.nome
);

CREATE TABLE TipoDiAeroplano(
    nome dom_tipo_aeroplano primary key,
    numero_posti_massimo integer not null,
    azienda_costruttrice varchar(20) not null,
    autonomia_di_volo integer not null
);

CREATE TABLE PuoDecollare(
    tipo_aeroplano dom_tipo_aeroplano,     -- PK, FK: TipoDiAeroplano.nome
    aeroporto dom_codice_aeroporto,              -- PK, FK: Aeroporto.codice
    primary key(tipo_aeroplano, aeroporto)
);

CREATE TABLE Aeroporto(
    codice dom_codice_aeroporto primary key,
    nome varchar(50) not null,
    citta varchar(50) not null,
    nazione varchar(50) not null
);

CREATE TABLE Tratta(
    id dom_codice_tratta primary key,
    orario_previsto_partenza time not null,
    orario_previsto_arrivo time not null,
    aeroporto_partenza dom_codice_aeroporto not null,        -- FK: Aeroporto.codice
    aeroporto_arrivo dom_codice_aeroporto not null           -- FK: Aeroporto.codice
);

-- end of table creation
commit;