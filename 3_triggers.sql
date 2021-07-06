-- connect to db
\c progettobasididatidb;

start transaction;

-- triggers definition
create or replace function aereo_puo_essere_utilizzato_istanza_tratta()
returns trigger language plpgsql as
$$
    declare 
        ok integer;
    begin
        select count(*) into ok -- IdT.tratta, IdT.data_istanza, IdT.aeroplano, A.tipo_aeroplano
        from IstanzaDiTratta as IdT
        join Tratta as T
            on (IdT.tratta = T.id)
        join Aeroplano as A
            on (IdT.aeroplano = A.codice)
        join PuoDecollare as PD_p 
            on (A.tipo_aeroplano = PD_p.tipo_aeroplano and T.aeroporto_partenza = PD_p.aeroporto)
        join PuoDecollare as PD_a
            on (A.tipo_aeroplano = PD_a.tipo_aeroplano and T.aeroporto_arrivo = PD_a.aeroporto)
        where (new.tratta = IdT.tratta and new.data_istanza = IdT.data_istanza);

        if ok = 0 then
            raise exception 'Aeroplano non può decollare o atterrare su aeroporto di partenza o arrivo';
            return null;
        end if;

        return new;
    end;
$$;

create trigger trigger_aereo_puo_essere_utilizzato_istanza_tratta
after insert or update on IstanzaDiTratta
for each row
execute procedure aereo_puo_essere_utilizzato_istanza_tratta();


commit;
