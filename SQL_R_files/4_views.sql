
-- 1) Giorni della settimana con più voli
-- query usata nel grafico
create view conta_numero_voli_per_giorno_settimana(giorno_settimana, numero_voli)
as
select 
    giorno_settimana as giorno_settimana, 
    count(*) as numero_voli
from giornidellasettimana_volo
group by giorno_settimana;

-- view ausiliaria per 2) e 3)
create view posti_rimanenti_info(tratta, data_istanza, num_posti_totali, num_posti_rimanenti, num_posti_prenotati, perc_occup_aereo)
as
select 
    IT.tratta, 
    IT.data_istanza as data, 
    A.numero_posti as num_posti_totali, 
    IT.numero_posti_rimanenti as num_posti_rimanenti,
    (A.numero_posti - IT.numero_posti_rimanenti) as num_posti_prenotati, 
    trunc(((A.numero_posti - IT.numero_posti_rimanenti)::decimal / A.numero_posti), 4) as perc_occup_aereo
from istanzaditratta as IT
join aeroplano as A on IT.aeroplano = A.codice
order by data_istanza, perc_occup_aereo;

-- 2) Percentuale di occupazione degli aerei
-- query usata nel grafico
create view percentuale_occupazione_aerei(perc_occupazione_aereo, numero_aerei)
as 
select 
    trunc(perc_occup_aereo, 2) as perc_occupazione_aereo,   --arrotondo la perc di occup a due cifre
    count(trunc(perc_occup_aereo, 2)) as numero_aerei       --conto quante perc di ogni gruppo
from posti_rimanenti_info
group by perc_occupazione_aereo                             -- raggruppo per percentuale arrotondata
order by perc_occupazione_aereo;


-- 3) Tipi di aeroplano più utilizzati
-- query usata nel grafico
create view tipi_aeroplano_piu_utilizzati(tipo_aeroplano, numero_utilizzi)
as 
select 
    a.tipo_aeroplano, 
    count(*) as numero_utilizzi
from istanzaditratta idt 
join aeroplano a on a.codice = idt.aeroplano 
group by tipo_aeroplano
order by numero_utilizzi;

-- 4) Le compagnie aeree più economiche
-- view ausiliaria
create view prezzi_voli_compagnia_aerea(volo, classe, prezzo, compagnia_aerea)
as
select volo, classe, prezzo, compagnia_aerea
from ClasseDiVolo CV
join Volo V on CV.volo = V.codice;

-- query usata nel grafico
create view dieci_compagnie_aeree_piu_economiche(costo_medio, compagnia_aerea)
as
select
    -- costo medio è dato dalla somma di tutti i prezzi di tutti i voli e di tutte le classe diviso il numero di classe di voli
    trunc(((sum(prezzo))::decimal / count(*)), 2) as costo_medio,
    compagnia_aerea
from prezzi_voli_compagnia_aerea
group by compagnia_aerea
order by costo_medio asc
limit 10;
