-- connect to db
\c progettobasididatidb;

start transaction;

-- udf 

-- max numero progressivo di un volo
create or replace function max_numero_progressivo_volo (
    in  codice_volo dom_codice_volo,
    out integer
)
language plpgsql as
$$
    begin
        select max(numero_progressivo)
        from Volo_Tratta as VT
        where VT.volo = codice_volo;
    end;
$$;


-- triggers definition

-- trigger vincolo numero 1:
-- La città di partenza e arrivo di un volo devono essere diverse

create or replace function not_same_city()
returns trigger language plpgsql as
$$
    declare
        ok integer;
    begin
        select count(*) into ok
        from Volo as V
        join Aeroporto as A_p on (A_p.codice = V.aeroporto_partenza)
        join Aeroporto as A_a on (A_a.codice = V.aeroporto_arrivo)
        where   A_p.citta = A_a.citta and
                new.codice = V.codice;

        if ok > 0
        then
            raise exception 'Stessa citta di partenza e arrivo';
            return null;
        end if;

        return new;

    end;

$$;

create trigger trigger_volo_not_same_city
after insert or update on Volo
for each row
execute procedure not_same_city();


-- trigger vincolo numero 2:
-- Un aeroplano può essere utilizzato nella istanza di tratta 
--  se l’aeroplano può atterrare negli aeroporti di partenza e di arrivo della tratta.

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

        if ok = 0 
        then
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
