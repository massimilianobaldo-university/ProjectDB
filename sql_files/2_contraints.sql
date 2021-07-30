-- connect to db
\c progettobasididatidb;

start transaction;

-- 1) indexes, 2) Foreign keys

-- 1) indexes definition
CREATE INDEX citta_idx ON Aeroporto (citta);

-- 2) foreign keys definition
-- FK Prenotazione
ALTER TABLE Prenotazione
ADD CONSTRAINT fk__prenotazione__cliente 
FOREIGN KEY (cliente)
REFERENCES Cliente(codice_fiscale);

ALTER TABLE Prenotazione 
ALTER CONSTRAINT fk__prenotazione__cliente
DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE Prenotazione
ADD CONSTRAINT fk__prenotazione__volo 
FOREIGN KEY (volo, classe)
REFERENCES ClasseDiVolo(volo, classe);

ALTER TABLE Prenotazione 
ALTER CONSTRAINT fk__prenotazione__volo
DEFERRABLE INITIALLY DEFERRED;

-- FK IstanzaDiTratta
ALTER TABLE IstanzaDiTratta
ADD CONSTRAINT fk__istanzaditratta__tratta 
FOREIGN KEY (tratta)
REFERENCES Tratta(id);

ALTER TABLE IstanzaDiTratta 
ALTER CONSTRAINT fk__istanzaditratta__tratta
DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE IstanzaDiTratta
ADD CONSTRAINT fk__istanzaditratta__aeroplano 
FOREIGN KEY (aeroplano)
REFERENCES Aeroplano(codice);

ALTER TABLE IstanzaDiTratta 
ALTER CONSTRAINT fk__istanzaditratta__aeroplano
DEFERRABLE INITIALLY DEFERRED;

-- FK ClasseDiVolo
ALTER TABLE ClasseDiVolo
ADD CONSTRAINT fk__classedivolo__classe 
FOREIGN KEY (classe)
REFERENCES ClassePossibile(priorita);

ALTER TABLE ClasseDiVolo 
ALTER CONSTRAINT fk__classedivolo__classe
DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ClasseDiVolo
ADD CONSTRAINT fk__classedivolo__volo 
FOREIGN KEY (volo)
REFERENCES Volo(codice);

ALTER TABLE ClasseDiVolo 
ALTER CONSTRAINT fk__classedivolo__volo
DEFERRABLE INITIALLY DEFERRED;

-- FK Volo
ALTER TABLE Volo
ADD CONSTRAINT fk__volo__compagniaaerea 
FOREIGN KEY (compagnia_aerea)
REFERENCES CompagniaAerea(nome);

ALTER TABLE Volo 
ALTER CONSTRAINT fk__volo__compagniaaerea
DEFERRABLE INITIALLY DEFERRED;

-- FK GiorniDellaSettimana_Volo
ALTER TABLE GiorniDellaSettimana_Volo
ADD CONSTRAINT fk__giornidellasettimana_volo__giorno_settimana 
FOREIGN KEY (giorno_settimana)
REFERENCES GiorniDellaSettimana(nome);

ALTER TABLE GiorniDellaSettimana_Volo 
ALTER CONSTRAINT fk__giornidellasettimana_volo__giorno_settimana
DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE GiorniDellaSettimana_Volo
ADD CONSTRAINT fk__giornidellasettimana_volo__giorno_volo 
FOREIGN KEY (volo)
REFERENCES Volo(codice);

ALTER TABLE GiorniDellaSettimana_Volo 
ALTER CONSTRAINT fk__giornidellasettimana_volo__giorno_volo
DEFERRABLE INITIALLY DEFERRED;

-- FK Volo_Tratta
ALTER TABLE Volo_Tratta
ADD CONSTRAINT fk__volo_tratta__tratta 
FOREIGN KEY (tratta)
REFERENCES Tratta(id);

ALTER TABLE Volo_Tratta 
ALTER CONSTRAINT fk__volo_tratta__tratta
DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE Volo_Tratta
ADD CONSTRAINT fk__volo_tratta__volo 
FOREIGN KEY (volo)
REFERENCES Volo(codice);

ALTER TABLE Volo_Tratta 
ALTER CONSTRAINT fk__volo_tratta__volo
DEFERRABLE INITIALLY DEFERRED;

-- FK CompagniaAerea_Aeroplano
ALTER TABLE CompagniaAerea_Aeroplano
ADD CONSTRAINT fk__compagniaaerea_aeroplano__compagniaaerea 
FOREIGN KEY (compagnia_aerea)
REFERENCES CompagniaAerea(nome);

ALTER TABLE CompagniaAerea_Aeroplano 
ALTER CONSTRAINT fk__compagniaaerea_aeroplano__compagniaaerea
DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE CompagniaAerea_Aeroplano
ADD CONSTRAINT fk__compagniaaerea_aeroplano__aeroplano 
FOREIGN KEY (aeroplano)
REFERENCES Aeroplano(codice);

ALTER TABLE CompagniaAerea_Aeroplano 
ALTER CONSTRAINT fk__compagniaaerea_aeroplano__aeroplano
DEFERRABLE INITIALLY DEFERRED;

-- FK Aeroplano
ALTER TABLE Aeroplano
ADD CONSTRAINT fk__aeroplano__tipoaeroplano 
FOREIGN KEY (tipo_aeroplano)
REFERENCES TipoDiAeroplano(nome);

ALTER TABLE Aeroplano 
ALTER CONSTRAINT fk__aeroplano__tipoaeroplano
DEFERRABLE INITIALLY DEFERRED;

-- FK PuoDecollare
ALTER TABLE PuoDecollare
ADD CONSTRAINT fk__puodecollare__tipoaeroplano 
FOREIGN KEY (tipo_aeroplano)
REFERENCES TipoDiAeroplano(nome);

ALTER TABLE PuoDecollare 
ALTER CONSTRAINT fk__puodecollare__tipoaeroplano
DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE PuoDecollare
ADD CONSTRAINT fk__puodecollare__aeroporto 
FOREIGN KEY (aeroporto)
REFERENCES Aeroporto(codice);

ALTER TABLE PuoDecollare 
ALTER CONSTRAINT fk__puodecollare__aeroporto
DEFERRABLE INITIALLY DEFERRED;

-- FK Tratta
ALTER TABLE Tratta
ADD CONSTRAINT fk__tratta__aeroportopartenza 
FOREIGN KEY (aeroporto_partenza)
REFERENCES Aeroporto(codice);

ALTER TABLE Tratta 
ALTER CONSTRAINT fk__tratta__aeroportopartenza
DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE Tratta
ADD CONSTRAINT fk__tratta__aeroportoarrivo 
FOREIGN KEY (aeroporto_arrivo)
REFERENCES Aeroporto(codice);

ALTER TABLE Tratta 
ALTER CONSTRAINT fk__tratta__aeroportoarrivo
DEFERRABLE INITIALLY DEFERRED;

commit;