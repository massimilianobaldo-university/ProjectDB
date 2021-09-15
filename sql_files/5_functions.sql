
-- 1) Giorni della settimana con più voli
create view conta_numero_voli_per_giorno_settimana(giorno_settimana, numero_voli)
as
select 
    giorno_settimana as giorno_settimana, 
    count(*) as numero_voli
from giornidellasettimana_volo
group by giorno_settimana;

-- 2) Numero medio di passeggeri nei voli
create view posti_rimanenti_info(tratta, data_istanza, num_posti_totali, num_posti_rimanenti, num_posti_prenotati, perc_posti_prenotati)
as
select 
    IT.tratta, 
    IT.data_istanza as data, 
    A.numero_posti as num_posti_totali, 
    IT.numero_posti_rimanenti as num_posti_rimanenti,
    (A.numero_posti - IT.numero_posti_rimanenti) as num_posti_prenotati, 
    trunc(((A.numero_posti - IT.numero_posti_rimanenti)::decimal / A.numero_posti), 4) as perc_posti_prenotati
from istanzaditratta as IT
join aeroplano as A on (
    IT.aeroplano = A.codice
)
order by data_istanza, perc_posti_prenotati;

-- 3) Percentuale media di occupazione degli aerei

-- 4) Le compagnie aeree più economiche
create view prezzi_voli_compagnia_aerea(volo, classe, prezzo, compagnia_aerea)
as
select volo, classe, prezzo, compagnia_aerea
from ClasseDiVolo CV
join Volo V on CV.volo = V.codice;

select 
    sum(prezzo) as costo_totale, 
    (count(*)/3) as numero_voli, 
    trunc(((sum(prezzo))::decimal / ((count(*)/3))), 2) as costo_medio,
    compagnia_aerea
from prezzi_voli_compagnia_aerea
group by compagnia_aerea
order by costo_medio desc;



