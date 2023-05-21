
-- PL/pgSQL

-- komentare -- jeden riadok

/*
viac
riadkov
 */


select 'String constant';
select 'I''m also a string constant';

-- $tag$ <string constant> \$tag$

select $$ I'm a string with a backslash \  $$;
select $message$ I’m a string with a backslash \   $message$;

-- anonym. bloky

/*
DO $$
[ <<label>> ]
DECLARE
/* Declare section (optional). */
BEGIN
/* Executable section (required). */
EXCEPTION
/* Exception handling section (optional). */
END [ label ]
$$;
*/

DO
$$
    <<prvyblok>>
        DECLARE
        counter integer;
    BEGIN
        select count(*) into counter from mesto;
        raise notice 'Pocet miest je $%$', counter;
    END prvyblok
$$;


-- deklaracia premennych
/*
 DECLARE
v_birthday DATE;
v_age INT NOT NULL = 21;
v_name VARCHAR(15) := 'Homer';
v_magic CONSTANT NUMERIC := 42;
v_valid BOOLEAN DEFAULT TRUE;
 */

-- priklad na deklaraciu premennej pomocou %type
DO
$$
    DECLARE
        nazovmesta mesto.nazov%TYPE;
    begin
        select nazov into nazovmesta from mesto where id = 1;
        raise notice 'mesto s id 1 je %', nazovmesta;
    end
$$;


-- priklad na deklaraciu premennej pomocou %Rowtype
DO
$$
    DECLARE
        riadokmesta mesto%ROWTYPE;
    begin
        select * into riadokmesta from mesto where id = 1;
        raise notice 'Mesto s ID % je % a ma % obyvatelov.', riadokmesta.id, riadokmesta.nazov, riadokmesta.populacia;
    end
$$;


-- priklad na deklariaciu ZAZNAMU - record

DO
$$
    DECLARE
        zaznam_miest record;
    begin
        for zaznam_miest in
            select * from mesto order by id
            loop
                raise notice 'Mesto s ID % je % a ma % obyvatelov.',
                    zaznam_miest.id, zaznam_miest.nazov, zaznam_miest.populacia;
            end loop;
    end
$$;


-- rozsah viditelnosti premennej (variable scope)

DO
$$
    DECLARE
        cislo INTEGER := 30;
    BEGIN
        RAISE NOTICE 'cislo na zaciatku je %', cislo; -- 30
        cislo := 50;
        -- deklaracia vnoreneho bloku
        DECLARE
            cislo INTEGER := 80;
        BEGIN
            RAISE NOTICE 'cislo vo vnorenom bloku je %', cislo; -- 80
        END;
        RAISE NOTICE 'cislo vo vonkajsiom bloku je %', cislo; -- 50
    END
$$;

-- pristup k hodnotam vyssieho bloku

DO
$$
    <<vonkajsi>>
    DECLARE
        cislo INTEGER := 30;
    BEGIN
        RAISE NOTICE 'cislo na zaciatku je %', cislo; -- 30
        cislo := 50;
        -- deklaracia vnoreneho bloku
        DECLARE
            cislo INTEGER := 80;
        BEGIN
            RAISE NOTICE 'cislo vo vnorenom bloku je %', cislo; -- 80
            RAISE NOTICE 'cislo vo vonkajsiom bloku je % - pristup z vnutoreneho', vonkajsi.cislo; -- 50
        END;
        RAISE NOTICE 'sme naspat vo vonaksiom a cislo vo vonkajsiom bloku je %', cislo; -- 50
    END
$$;

-- konstatny
DO
$$
    DECLARE
        cena         int;
        DPH constant float4 := 0.2;
    BEGIN
        cena := 31;
        raise notice 'cena bez dph je %', cena;
        raise notice 'cena s dph je %', cena + cena * DPH;
    END
$$;

-- spravy a chybove hlasenia
do
$$
    begin
        raise info 'information message %', now();
        raise log 'log message %', now();
        raise debug 'debug message %', now();
        raise warning 'warning message %', now();
        raise notice 'notice message %', now();
    end
$$;



DO
$$
    DECLARE
        personal_email varchar(100) := 'raise@exceptions.com';
    BEGIN
        -- First check the user email id is correct as well as duplicate or not.
-- If user email id is duplicate then report mail as duplicate.
        RAISE EXCEPTION 'Enter email is duplicate: %', personal_email
            USING HINT = 'Check email and enter correct email ID of user';
    END
$$;


-- exception handling
do
$$
    declare
        a int;
        b int;
    begin
        a := 5;
        b := 1;
        b := a / b;
        raise sqlstate '01000';
    exception
        when division_by_zero
            then raise notice 'Delenie nulou, exeption handling';
        when others
            then raise notice 'a';
    end
$$;


select now();

-- RIADIACE STRUKTURY

-- IF ELSIF THEN ELSE
do
$$
    declare
        number int;
    begin
        number := null;
        if number = 0 then
            raise notice 'number je 0';
        elsif
            number > 0 then
            raise notice 'number je kladne cislo';
        elsif
            number < 0 then
            raise notice 'number je zaporne cislo';
        else
            raise notice 'number je NULL';
        end if;
    end
$$;


-- CASE jednoduchy
do
$$
    declare
        msq varchar(20);
        x   int;
    begin
        x := 20;
        case x
            when 1,2 then msq := 'x je 1 alebo 2';
            else msq := 'x nie je 1 alebo 2';
            end case;
        raise notice '%', msq;
    end
$$;

-- CASE hladany

do
$$
    declare
        msq varchar(20);
        x   int;
    begin
        x := 20;
        case
            when x = 1 then
                msq := 'x je 1';
            when x = 2 then
                msq := 'x je 2';
            else
                msq := 'x nie je 1 alebo 2';
            end case;
        raise notice '%', msq;
    end
$$;

-- CYKLY LOOP exit a continue
do
$$
    declare
        i int;
    begin
        i := 1;
        loop
            i := i + 1;
            raise notice 'inkrementacia i po iteraciach: %', i;
            if i > 10
            then
                exit;
            end if;
        end loop;
    end;
$$;


do
$$
    declare
        i int;
    begin
        i := 1;
        loop
            i := i + 1;
            raise notice 'inkrementacia i po iteraciach: %', i;
            exit when i > 10;
        end loop;
    end;
$$;

-- loop s continue
-- vypis len parne cisla
do
$$
    declare
        cnt int = 0;
    begin
        loop
            -- increment of cnt
            cnt = cnt + 1;
            -- exit the loop if cnt > 10
            exit when cnt > 10;
            -- skip the iteration if cnt is an odd number
            continue when mod(cnt, 2) = 1;
            -- print out the cnt
            raise notice '%', cnt;
        end loop;
    end;
$$;


-- while
do
$$
    declare
        add integer := 0;
    begin
        while add < 10
            loop
                raise notice 'Out addition count %', add;
                add := add + 1;
            end loop;
    end
$$;


-- FOR cez int
do
$$
    begin
        for cnt in 1..10
            loop
                raise notice 'cnt: %', cnt;
            end loop;
    end;
$$

-- for cez select
DO
$$
    DECLARE
        zaznam_miest record;
    begin
        for zaznam_miest in
            select * from mesto order by id
            loop
                raise notice 'Mesto s ID % je % a ma % obyvatelov.',
                    zaznam_miest.id, zaznam_miest.nazov, zaznam_miest.populacia;
            end loop;
    end
$$;



