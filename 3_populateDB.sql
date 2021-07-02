-- connect to db
\c progettobasididatidb;

start transaction;

set constraints all deferred;

INSERT INTO Cliente 
(codice_fiscale, nome, cognome, telefono)
VALUES
('BZWLGX32S28A742I', 'francesco',    'rossi' , '0000000000'),
('WXKPHP62P13I422Q', 'alberto',      'verdi',  '1111111111'),
('RDPCZW50H52C879U', 'luca',         'gialli', '2222222222'),
('FFNMPM29E19G365M', 'massimiliano', 'aranci', '3333333333'),
('JVUMFA71C62I606Z', 'ludovico',     'neri',   '4444444444');

INSERT INTO Prenotazione 
(codice, cliente, volo, classe)
VALUES
(1, 'BZWLGX32S28A742I', 1000, 1),
(2, 'WXKPHP62P13I422Q', 1001, 2),
(3, 'RDPCZW50H52C879U', 1002, 3),
(4, 'FFNMPM29E19G365M', 1002, 3);

INSERT INTO Prenotazione_IstanzaDiTratta 
(codice_prenotazione, data_istanza_tratta, tratta, posto_prenotato)
VALUES
(1, '2021-06-30', 100, 'A01'),
(2, '2021-07-01', 101, 'B01'),
(3, '2021-07-10', 102, 'C03'),
(4, '2021-07-10', 102, 'F06');

INSERT INTO IstanzaDiTratta
(tratta, data_istanza, aeroplano) -- numero_posti_rimanenti: null
VALUES
(100, '2021-06-30', 10),
(101, '2021-07-01', 20),
(102, '2021-07-10', 30);

INSERT INTO ClassePossibile
(priorita, nome)
VALUES
(1, 'luxury'),
(2, 'business'),
(3, 'economy');

INSERT INTO ClasseDiVolo
(classe, volo, prezzo)
VALUES
(1, 1000, 500.00),
(2, 1000, 200.00),
(3, 1000,  80.00),
(2, 1001, 150.00),
(3, 1001,  60.00),
(2, 1002, 300.00),
(3, 1002, 100.00);

INSERT INTO Volo
(codice, orario_previsto_partenza, orario_previsto_arrivo, aeroporto_partenza, aeroporto_arrivo, compagnia_aerea)
VALUES
(1000, '12:00', '22:00', 1111, 5555, 'Alitalia'),
(1001, '06:00', '09:00', 2222, 3333, 'Ryanair'),
(1002, '17:00', '20:00', 3333, 4444, 'AirFrance');

INSERT INTO GiorniDellaSettimana_Volo
(giorno_settimana, volo)
VALUES
('lunedi',      1000),
('mercoledi',   1000),
('giovedi',     1001),
('venerdi',     1001),
('mercoledi',   1002);

INSERT INTO Volo_Tratta
(tratta, volo, numero_progressivo)
VALUES
(100, 1000, 1),
(101, 1001, 1),
(102, 1002, 1);

INSERT INTO GiorniDellaSettimana
(nome)
VALUES
('lunedi'),
('martedi'),
('mercoledi'),
('giovedi'),
('venerdi'),
('sabato'),
('domenica');

INSERT INTO CompagniaAerea
(nome)
VALUES
('Alitalia'),
('Ryanair'),
('AirFrance');

INSERT INTO CompagniaAerea_Aeroplano
(compagnia_aerea, aeroplano)
VALUES
('Alitalia',    10),
('Ryanair',     20),
('AirFrance',   30);

INSERT INTO Aeroplano
(codice, numero_posti, tipo_aeroplano)
VALUES
(10, 200, 'AAA00'),
(20, 300, 'BBB11'),
(30, 100, 'CCC22');

INSERT INTO TipoDiAeroplano
(nome, azienda_costruttrice, numero_posti_massimo, autonomia_di_volo)
VALUES
('AAA00', 'Fiat',       250, 18),
('BBB11', 'Mercedes',   300, 20),
('CCC22', 'Toyota',     120, 7);

INSERT INTO PuoDecollare
(tipo_aeroplano, aeroporto)
VALUES
('AAA00', 1111),
('AAA00', 5555),
('BBB11', 3333),
('BBB11', 2222),
('CCC22', 3333),
('CCC22', 4444);

INSERT INTO Aeroporto
(codice, nome, citta, nazione)
VALUES
(1111, 'Malpensa',          'Milano',       'Italia'),
(2222, 'Orio al serio',     'Bergamo',      'Italia'),
(3333, 'Linate',            'Milano',       'Italia'),
(4444, 'Fiumicino',         'Roma',         'Italia'),
(5555, 'Heathrow',          'Londra',       'Inghilterra');

INSERT INTO Tratta
(id, orario_previsto_arrivo, orario_previsto_partenza, aeroporto_arrivo, aeroporto_partenza)
VALUES
(100, '12:00', '22:00', 1111, 5555),
(101, '06:00', '09:00', 2222, 3333),
(102, '17:00', '20:00', 3333, 4444);

commit;