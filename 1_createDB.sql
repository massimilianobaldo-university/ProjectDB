-- create db
create database progettobasididatidb;

-- connect to db
\c progettobasididatidb;

start transaction;

-- domains 
CREATE dom_cf AS char(16);
CREATE dom_telefono AS text
   CONSTRAINT valid_dom_telefono check (value ~ '^\d+$');

-- start of table creation
CREATE TABLE Cliente(
    codice_fiscale dom_cf primary key,
    nome varchar(50) not null,
    cognome varchar(50) not null,
    telefono dom_telefono
);

CREATE TABLE Prenotazione(
    codice integer primary key,
    cliente dom_cf not null,  -- FK: Cliente.codice_fiscale
    volo integer not null,      -- FK: ClasseDiVolo.volo
    classe integer not null     -- FK: ClasseDiVolo.classe
);

CREATE TABLE Prenotazione_IstanzaDiTratta(
    codice_prenotazione integer not null,   -- FK: Prenotazione.codice
    data_istanza_tratta date not null,      -- FK: IstanzaDiTratta.data_istanza
    tratta integer,                         -- FK: IstanzaDiTratta.tratta
    posto_prenotato varchar(3) not null,
    primary key(codice_prenotazione, data_istanza_tratta, tratta)
);

CREATE TABLE IstanzaDiTratta(
    tratta integer,                 -- PK, FK: Tratta.id
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
    volo integer,           -- PK, FK: Volo.codice
    prezzo real not null,
    primary key(classe, volo)
);

CREATE TABLE Volo(
    codice integer primary key,
    orario_previsto_partenza time not null,
    orario_previsto_arrivo time not null,
    aeroporto_partenza integer not null,
    aeroporto_arrivo integer not null,
    compagnia_aerea varchar(20) not null        -- FK: CompagniaAerea.nome
);

CREATE TABLE GiorniDellaSettimana_Volo(
    giorno_settimana varchar(10),           -- PK, FK: GiorniDellaSettimana.nome
    volo integer,                           -- PK, FK: Volo.codice
    primary key(giorno_settimana, volo)
);

CREATE TABLE Volo_Tratta(
    tratta integer,     -- PK, FK: Tratta.id
    volo integer,       -- PK, FK: Volo.codice
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
    compagnia_aerea varchar(20),    -- PK, FK: CompagniaAerea.nome
    aeroplano integer,              -- PK, FK: Aeroplano.codice
    primary key(compagnia_aerea, aeroplano)
);

CREATE TABLE Aeroplano(
    codice integer primary key,
    numero_posti integer not null,
    tipo_aeroplano varchar(20)      -- FK: TipoDiAeroplano.nome
);

CREATE TABLE TipoDiAeroplano(
    nome varchar(20) primary key,
    numero_posti_massimo integer not null,
    azienda_costruttrice varchar(20) not null,
    autonomia_di_volo integer not null
);

CREATE TABLE PuoDecollare(
    tipo_aeroplano varchar(20),     -- PK, FK: TipoDiAeroplano.nome
    aeroporto integer,              -- PK, FK: Aeroporto.codice
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
    aeroporto_partenza integer not null,        -- FK: Aeroporto.codice
    aeroporto_arrivo integer not null           -- FK: Aeroporto.codice
);

-- end of table creation
commit;