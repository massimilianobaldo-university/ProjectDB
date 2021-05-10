create database progetto;

start transaction;

CREATE TABLE Cliente(
    codice_fiscale char(15) primary key,
    nome varchar(50) not null,
    cognome varchar(50) not null,
    telefono integer
);

CREATE TABLE Prenotazione(
    codice integer primary key,
    cliente integer,
    volo integer,
    classe varchar
);

CREATE TABLE Prenotazione_Istanza_Di_Tratta(
);

CREATE TABLE Istanza_Di_Tratta(
    data_istanza date,
    numero_posti_rimanenti integer
);

CREATE TABLE Classe_Possibile(
    priorita integer primary key
    nome varchar(50) not null unique,
);

CREATE TABLE Classe_Di_Volo(
    classe integer,
    volo integer,
    prezzo real not null
);

CREATE TABLE Volo(
    codice integer primary key,
    orario_previsto_partenza time,
    orario_previsto_arrivo time,
    aeroporto_partenza integer,
    aeroporto_arrivo integer,
    compagnia_aerea integer
);




commit;
