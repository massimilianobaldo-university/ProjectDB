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
('P1', 'BZWLGX32S28A742I', 'VG4155',  1),
('P2', 'WXKPHP62P13I422Q', 'VG4154',  2),
('P3', 'RDPCZW50H52C879U', 'VDL5841', 3),
('P4', 'FFNMPM29E19G365M', 'VDL1149', 3);

INSERT INTO ClassePossibile
(priorita, nome)
VALUES
(1, 'luxury'),
(2, 'business'),
(3, 'economy');

INSERT INTO ClasseDiVolo
(classe, volo, prezzo)
VALUES
(1, 'VG4155',  500.00),
(2, 'VG4155',  200.00),
(3, 'VG4155',   80.00),
(2, 'VG4154',  150.00),
(3, 'VG4154',   60.00),
(2, 'VDL5841', 300.00),
(3, 'VDL5841', 100.00),
(3, 'VDL1149', 200.00),
(3, 'VG4529',  130.00),
(3, 'VWN380',   90.00);

INSERT INTO Volo
(codice, orario_previsto_partenza, orario_previsto_arrivo, aeroporto_partenza, aeroporto_arrivo, compagnia_aerea)
VALUES
('VG4155',  '12:00', '22:00', 'SFO', 'OAK', 'Alitalia'),
('VG4154',  '06:00', '09:00', 'LAS', 'HNL', 'Ryanair'),
('VDL5841', '17:00', '20:00', 'JFK', 'FAT', 'AirFrance'),
('VDL1149', '12:00', '22:00', 'SFO', 'JFK', 'AirFrance'),
('VWN380',  '12:00', '16:00', 'SFO', 'HNL', 'AirFrance'),
('VG4529',  '17:00', '22:00', 'HNL', 'JFK', 'AirFrance');

INSERT INTO GiorniDellaSettimana_Volo
(giorno_settimana, volo)
VALUES
('lunedi',    'VG4155'),
('mercoledi', 'VG4154'),
('giovedi',   'VDL5841'),
('venerdi',   'VDL5841'),
('sabato',    'VDL1149'),
('sabato',    'VG4529'),
('sabato',    'VWN380');

INSERT INTO Volo_Tratta
(tratta, volo, numero_progressivo)
VALUES
('T1000', 'VG4155',  1),
('T1001', 'VG4154',  1),
('T1002', 'VDL5841', 1),
('T1003', 'VWN380',  1),
('T1004', 'VG4529',  1),
('T1003', 'VDL1149', 1),
('T1004', 'VDL1149', 2);

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
('Alitalia',  10),
('Ryanair',   20),
('AirFrance', 30),
('AirFrance', 40);

INSERT INTO Aeroplano
(codice, numero_posti, tipo_aeroplano)
VALUES
(10, 200, 'MD80'),
(20, 300, 'ERJ145'),
(30, 100, 'CRJ440'),
(40, 100, 'CRJ440');

INSERT INTO TipoDiAeroplano
(nome, azienda_costruttrice, numero_posti_massimo, autonomia_di_volo)
VALUES
('MD80',   'Fiat',     250, 18),
('ERJ145', 'Mercedes', 300, 20),
('CRJ440', 'Toyota',   120,  7);

INSERT INTO PuoDecollare
(tipo_aeroplano, aeroporto)
VALUES
('MD80',   'SFO'),
('MD80',   'OAK'),
('ERJ145', 'LAS'),
('ERJ145', 'HNL'),
('CRJ440', 'JFK'),
('CRJ440', 'FAT'),
('CRJ440', 'SFO'),
('CRJ440', 'HNL');

INSERT INTO Aeroporto
(codice, nome, citta, nazione)
VALUES
('SFO', 'San-Francisco-International',   'San-Francisco', 'CA'),
('OAK', 'Oakland-International',         'Oakland',       'CA'),
('LAS', 'McCarren-International',        'Las-Vegas',     'NV'),
('HNL', 'Honolulu-International',        'Honolulu',      'HI'),
('JFK', 'John-F-Kennedy-International',  'New-York',      'NY'),
('FAT', 'Fresno-Yosemite-International', 'Fresno',        'CA');

INSERT INTO Tratta
(id, orario_previsto_partenza, orario_previsto_arrivo, aeroporto_partenza, aeroporto_arrivo)
VALUES
('T1000', '12:00', '22:00', 'SFO', 'OAK'),
('T1001', '06:00', '09:00', 'LAS', 'HNL'),
('T1002', '17:00', '20:00', 'JFK', 'FAT'),
('T1003', '12:00', '16:00', 'SFO', 'HNL'),
('T1004', '17:00', '22:00', 'HNL', 'JFK');

INSERT INTO IstanzaDiTratta
(tratta, data_istanza, aeroplano) -- numero_posti_rimanenti: null
VALUES
('T1000', '2021-06-28', 10),
('T1001', '2021-07-07', 20),
('T1002', '2021-07-08', 30),
('T1002', '2021-07-09', 30),
('T1003', '2021-07-10', 30),
('T1004', '2021-07-10', 40);

INSERT INTO Prenotazione_IstanzaDiTratta 
(codice_prenotazione, data_istanza_tratta, tratta, posto_prenotato)
VALUES
('P1', '2021-06-28', 'T1000', '01A'),
('P2', '2021-07-07', 'T1001', '01B'),
('P3', '2021-07-08', 'T1002', '03C'),
('P4', '2021-07-10', 'T1003', '06F'),
('P4', '2021-07-10', 'T1004', '02D');

commit;
