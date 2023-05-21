

-- vytvorenie demonstrativnej tabulky
create table test
(
    n int 
);


-- zaciatok transakcie
begin;
-- vlozenie udajov do tabulky test
insert into test
values (1);
-- potvrdenie transakcie
commit;

-- zaciatok transakcie
begin;

-- vlozenie udajov do tabulky test
insert into test
values (1434);

-- vypis hodnot z tabulky test pred vytvorenim savepointu
select *
from test;

-- vlozenie udajov do tabulky test
insert into test
values (31);

-- vytvorenie savepoint
savepoint prvysave;

-- vlozenie udajov do tabulky test
insert into test
values (1535);

-- vytvorenie savepoint
savepoint prvysave2;

-- vlozenie udajov do tabulky test
insert into test
values (13525);
-- vypis hodnot z tabulky test v aktualnom stave
select *
from test;
-- navrat do stavu prvysave
rollback to prvysave;

-- potvrdenie transakcie
commit;

-- zaciatok transakcie
begin;

-- zmazanie hodnot v tabulke pre n < 31
delete
from test
where n < 31;

-- vypis hodnot v aktualnom stave
select *
from test;

-- vratenie zmien 
rollback;

-- vypis hodnot v aktualnom stave
select *
from test;


-- vytvorenie pohladu vsetkych studentov ktori maju zapisany predmet DBS
create view studenti_na_dbd as
select s.meno, s.priezvisko
from student s
         join student_predmet sp on s.id_student = sp.id_student
         join predmet p on p.id_predmet = sp.id_predmet
where p.nazov = 'Databázové systémy';

-- vytvorenie pohladu z pohladu
create view studenti_na_dbd_priezvisko as
select priezvisko
from studenti_na_dbd;

select priezvisko
from studenti_na_dbd;

select *
from studenti_na_dbd_priezvisko;




-- vytvorenie pohladu s vyuzitim agregacnych funckcii (nad pohladom nie je mozne DML)
create view  populacia as
select sum(m.populacia), s.nazov
from mesto m
         join stat s on s.id = m.id_stat
group by s.nazov;

select *
from populacia;


-- priklad na materializovany pohlad
-- select s vypoctom
select avg(m.populacia) as "Priemerna populacia miest", avg(s.populacia) as "Priemerna populacia statov"
from mesto m
         full join stat s on s.id = m.id_stat;

-- vytvorenie pohladu
create view priemer_S_a_M as
select avg(m.populacia) as "Priemerna populacia miest", avg(s.populacia) as "Priemerna populacia statov"
from mesto m
         full join stat s on s.id = m.id_stat;

-- odstranenie pohladu
drop view priemer_S_a_M;


-- vytvorenie materializovaneho pohladu
create materialized view priemer_S_a_M as
select avg(m.populacia) as "Priemerna populacia miest", avg(s.populacia) as "Priemerna populacia statov"
from mesto m
         full join stat s on s.id = m.id_stat
with data;

select "Priemerna populacia miest"
from priemer_S_a_M;

-- aktualizacia dat v mat. pohlade
refresh materialized view priemer_S_a_M;

-- odstranenie pohladu
drop materialized view priemer_S_a_M;


