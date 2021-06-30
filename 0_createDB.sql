-- create db
create database progettobasididatidb;

-- connect to db
\c progettobasididatidb;

start transaction;

-- start of table creation
CREATE TABLE Cliente(
    codice_fiscale char(16) primary key,
    nome varchar(50) not null,
    cognome varchar(50) not null,
    telefono bigint
);

CREATE TABLE Prenotazione(
    codice integer primary key,
    cliente char(16) not null,  -- FK: Cliente.codice_fiscale
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

-----------------------------------------------------------------------------------

-- start of table's FK definition

-- FK Prenotazione
ALTER TABLE Prenotazione
ADD CONSTRAINT fk__prenotazione__cliente 
FOREIGN KEY (cliente)
REFERENCES Cliente(codice_fiscale);

ALTER TABLE Prenotazione
ADD CONSTRAINT fk__prenotazione__volo 
FOREIGN KEY (volo, classe)
REFERENCES ClasseDiVolo(volo, classe);

-- FK IstanzaDiTratta
ALTER TABLE IstanzaDiTratta
ADD CONSTRAINT fk__istanzaditratta__tratta 
FOREIGN KEY (tratta)
REFERENCES Tratta(id);

ALTER TABLE IstanzaDiTratta
ADD CONSTRAINT fk__istanzaditratta__aeroplano 
FOREIGN KEY (aeroplano)
REFERENCES Aeroplano(codice);

-- FK ClasseDiVolo
ALTER TABLE ClasseDiVolo
ADD CONSTRAINT fk__classedivolo__classe 
FOREIGN KEY (classe)
REFERENCES ClassePossibile(priorita);

ALTER TABLE ClasseDiVolo
ADD CONSTRAINT fk__classedivolo__volo 
FOREIGN KEY (volo)
REFERENCES Volo(codice);

-- FK Volo
ALTER TABLE Volo
ADD CONSTRAINT fk__volo__compagniaaerea 
FOREIGN KEY (compagnia_aerea)
REFERENCES CompagniaAerea(nome);

-- FK GiorniDellaSettimana_Volo
ALTER TABLE GiorniDellaSettimana_Volo
ADD CONSTRAINT fk__giornidellasettimana_volo__giorno_settimana 
FOREIGN KEY (giorno_settimana)
REFERENCES GiorniDellaSettimana(nome);

ALTER TABLE GiorniDellaSettimana_Volo
ADD CONSTRAINT fk__giornidellasettimana_volo__giorno_volo 
FOREIGN KEY (volo)
REFERENCES Volo(codice);

-- FK Volo_Tratta
ALTER TABLE Volo_Tratta
ADD CONSTRAINT fk__volo_tratta__tratta 
FOREIGN KEY (tratta)
REFERENCES Tratta(id);

ALTER TABLE Volo_Tratta
ADD CONSTRAINT fk__volo_tratta__volo 
FOREIGN KEY (volo)
REFERENCES Volo(codice);

-- FK CompagniaAerea_Aeroplano
ALTER TABLE CompagniaAerea_Aeroplano
ADD CONSTRAINT fk__compagniaaerea_aeroplano__compagniaaerea 
FOREIGN KEY (compagnia_aerea)
REFERENCES CompagniaAerea(nome);

ALTER TABLE CompagniaAerea_Aeroplano
ADD CONSTRAINT fk__compagniaaerea_aeroplano__aeroplano 
FOREIGN KEY (aeroplano)
REFERENCES Aeroplano(codice);

-- FK Aeroplano
ALTER TABLE Aeroplano
ADD CONSTRAINT fk__aeroplano__tipoaeroplano 
FOREIGN KEY (tipo_aeroplano)
REFERENCES TipoDiAeroplano(nome);

-- FK PuoDecollare
ALTER TABLE PuoDecollare
ADD CONSTRAINT fk__puodecollare__tipoaeroplano 
FOREIGN KEY (tipo_aeroplano)
REFERENCES TipoDiAeroplano(nome);

ALTER TABLE PuoDecollare
ADD CONSTRAINT fk__puodecollare__aeroporto 
FOREIGN KEY (aeroporto)
REFERENCES Aeroporto(codice);

-- FK Tratta
ALTER TABLE Tratta
ADD CONSTRAINT fk__tratta__aeroportopartenza 
FOREIGN KEY (aeroporto_partenza)
REFERENCES Aeroporto(codice);

ALTER TABLE Tratta
ADD CONSTRAINT fk__tratta__aeroportoarrivo 
FOREIGN KEY (aeroporto_arrivo)
REFERENCES Aeroporto(codice);

-- end of table's FK definition

commit;
