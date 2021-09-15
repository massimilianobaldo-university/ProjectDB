
-- 1) Giorni della settimana con più voli
create view conta_numero_voli_per_giorno_settimana(giorno_settimana, numero_voli)
as
select 
    giorno_settimana as giorno_settimana, 
    count(*) as numero_voli
from giornidellasettimana_volo
group by giorno_settimana;

-- view utile pe 2) e 3)

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
join aeroplano as A on (
    IT.aeroplano = A.codice
)
order by data_istanza, perc_occup_aereo;

-- 2) Percentuale di occupazione degli aerei per anno
-- tolto perchè la media è 17% tutti gli anni

--select 
--    date_trunc('year', data_istanza) as year,
--    sum(perc_occup_aereo) as perc_posti_per_istanza, 
--    count(*) as num_istanze_per_anno,
--    trunc((sum(perc_occup_aereo)::decimal / count(*)), 4) as perc_occupazione_media
--from posti_rimanenti_info
--where data_istanza < '2021-01-01'
--group by year
--order by year;

-- 2) Percentuale di occupazione degli aerei
select 
    trunc(perc_occup_aereo, 2) as perc_occupazione_aereo, 
    count(trunc(perc_occup_aereo, 2)) as numero_aerei
from posti_rimanenti_info
group by perc_occupazione_aereo
order by perc_occupazione_aereo;


-- 3) Tipo di aeroplani più utilizzati
select a.tipo_aeroplano, count(*) as numero_tipi
from istanzaditratta idt 
join aeroplano a on a.codice = idt.aeroplano 
group by tipo_aeroplano
order by numero_tipi;

-- 4) Le compagnie aeree più economiche
create view prezzi_voli_compagnia_aerea(volo, classe, prezzo, compagnia_aerea)
as
select volo, classe, prezzo, compagnia_aerea
from ClasseDiVolo CV
join Volo V on CV.volo = V.codice;

select
    trunc(((sum(prezzo))::decimal / ((count(*)/3))), 2) as costo_medio,
    compagnia_aerea
from prezzi_voli_compagnia_aerea
group by compagnia_aerea
order by costo_medio asc
limit 50;



