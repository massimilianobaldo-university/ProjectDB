
create view conta_numero_voli_per_giorno_settimana(giorno_settimana, numero_voli)
as
select 
    giorno_settimana as giorno_settimana, 
    count(*) as numero_voli
from giornidellasettimana_volo
group by giorno_settimana;

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
