select now();


-- vytvorenie jednoduchej funkcie so vstupnym parametrom
create or replace function greet_name(name text)
    returns text
as
    $$
        begin
            return 'Hello ' || name || ' !';
        end
    $$
language plpgsql
;

-- volanie vytvorenej funkcie
select greet_name('Feri');


-- mody parametrov

-- funkcia s IN premennou

create or replace function in_funkcia(x int)
    returns int
as
    $$
    begin
        x:= x+1;
        return x;
    end;
    $$
language plpgsql;

select in_funkcia(6);

-- funkcia s modom out

drop function out_funkcia();
create or replace function out_funkcia(out x int, out y int)
as
    $$
    begin
        x:=1;
        y:=2;
    end;
    $$
language plpgsql;

select out_funkcia();

-- funkcia s modom inout

create or replace function swap (inout x int, inout y int)
as
    $$
    begin
        select x,y into y,x;
    end;
    $$
language plpgsql;

select swap(1,2);

-- viacero modov v jednej funkcii
create or replace function kombinacia_in_out(x int, out y text)
as
    $$
        begin
            select x into y;
        end;
    $$
language plpgsql;

select kombinacia_in_out(5);

-- priklad na pretazenie funkcie (overloading)

-- prva funkcia bez parametrov
create or replace function pretazenie()
returns int as
    $$
        declare
            x int;
        begin
            x:= 1;
            return x;
        end;
    $$
language plpgsql;

select pretazenie();

-- druha funkcia s paramterami

create or replace function pretazenie(y int)
returns int as
    $$
        declare
            x int;
        begin
            x:= y + 1;
            return x;
        end
    $$
language plpgsql;

-- volanie konkretnej funkcie zalezi od paramterov
select pretazenie();
select pretazenie(50);

-- zmazanie fukcnie zalezi od paramterov
drop function pretazenie();
drop function pretazenie(y int);


-- funkcia ktora vrati tabulku
create or replace function vrat_mesto (vzor varchar)
    returns table(
                    mesto_meno varchar,
                    mesto_populacia int
                 )
    as
    $$
        begin
            return query select nazov, populacia from mesto where nazov ilike vzor;
            -- ilike ako like ale case-insensitive pattern matching
        end;
    $$
language plpgsql;

select vrat_mesto('K%');

-- procedury
create or replace procedure zobraz_spravu (inout sprava text)
as $$
    begin
        raise notice 'Parameter procedury je: %', sprava;
    end;
    $$
language plpgsql;

call zobraz_spravu('Skuska');

-- osetrenie chybovych stavov
create or replace function osetrenie_chyb( populaciamalo int)
returns record
    as
$$
    declare
        rec record;
    begin
        select nazov, populacia into strict rec from stat where populacia < populaciamalo;
        raise notice 'Mesto % ma populaciu %', rec.nazov, rec.populacia;
        return rec;
        -- odchyt chybu
    exception
        when
            sqlstate 'P0002' then
                raise exception 'nenajdeny stat, ktory ma populaciu menej ako %', populaciamalo;
        when
            sqlstate 'P0003' then
                raise exception 'vo vysledku je viac statov, ktore maju populaciu menej ako %', populaciamalo;
    end;
$$
language plpgsql;

select osetrenie_chyb(10);
select osetrenie_chyb(10000000);
select osetrenie_chyb(1000000);


-- trigerry

-- priklad na logovanie vkladania dat do tablky

drop table if exists test;
drop table if exists test_log;

-- vytvorenie dvoch tabuliek
-- test na vkladanie udajov
-- test_log na logovanie vklaania do test
create table test (id int);
create table test_log(id int, cas_datum timestamp);

-- vytvorenie trigger funkcie s return TRIGGER
drop function if exists update_test();

create or replace function update_test()
returns trigger
as
    $$
        begin
            insert into test_log(id, cas_datum) values (new.id, current_timestamp);
            return new;
        end;
    $$
language plpgsql;

-- vytvorenie triggera
drop trigger if exists log_na_test on test;
create trigger log_na_test
    after INSERT
    on test
    for each row
    execute procedure update_test();

insert into test(id) values (1);
insert into test(id) values (4);
insert into test(id) values (3);

select * from test;
select * from test_log;







