-- poddopyty

-- porovnavanie pomocou poddopytov - where a jedna hodnota
--Vypíš všetky mestá, ktoré majú menej obyvatelov ako štát s najmenšou populáciou:


select min(s.populacia)
from stat s;

select m.nazov, m.populacia
from mesto m
where m.populacia < (select min(s.populacia) from stat s);


-- priklad klauzula ALL - potrebujeme  jeden stlpec
-- Vypíš všetky štáty, ktoré majú viac obyvatelov ako mesto s najväcšou populáciou:

select m.populacia
from mesto m;

select s.nazov, s.populacia
from stat s
where s.populacia > ALL (select m.populacia from mesto m);


-- priklad klauzula ANY - potrebujeme  jeden stlpec
-- Vypíš všetky štáty, ktoré majú viac obyvatelov ako mesto s najmenšou populáciou:

select s.nazov, s.populacia
from stat s
where s.populacia > ANY (select m.populacia from mesto m);


-- (NOT) IN - vstup prave jeden stlpec
-- Vypíš všetky mestá, ktoré sú na Slovensku alebo v Cesku

select m.id_stat
from mesto m;

select *
from stat;

select s.id
from stat s
where s.nazov = 'Slovensko'
   or s.nazov = 'Cesko';

select *
from mesto m
where id_stat IN (select s.id
                  from stat s
                  where s.nazov = 'Slovensko'
                     or s.nazov = 'Cesko');

-- mesta ktore niesu na Slovensku  NOT IN
select *
from mesto m
where id_stat NOT IN (select s.id
                      from stat s
                      where s.nazov = 'Slovensko');




-- klauzula EXISTS lubovolny select
--Vypíš všetky mestá, ktoré majú priradený štát (existuje odkaz prostredníctvom cudzieho klúca na nejaký štát)

select m.nazov, m.id_stat
from mesto m;

select m.nazov, m.id_stat
from mesto m
where exists(select * from stat s where m.id_stat = s.id);

-- Korelovane poddopyty - v poddopyte odkaz na stlpec vonksieho dopytu
-- vypis vsetky mesta ktore maju menej obyvatelov ako je populacia najmensieho statu


select vonkajsi.nazov
from mesto vonkajsi
where vonkajsi.populacia < (select min(vnutorny.populacia) from stat vnutorny where vnutorny.id = vonkajsi.id_stat);


-- Sekvencie

-- priklad jednoducha sekvencia s krokom 5 a pociatocnou hodnotou 10

create sequence sekvencia
    increment 5
    start 10;

select *
from sekvencia;

select currval('sekvencia');

select nextval('sekvencia');

select setval('sekvencia', 100);

drop sequence sekvencia;


-- priklad sekvencia s asociovanym stlpcom

drop table test;

create table test
(
    id        int primary key,
    sekvencia int
);

select *
from test;

alter sequence sekvencia owned by test.sekvencia;

insert into test (id, sekvencia)
values (1, nextval('sekvencia'));
insert into test (id, sekvencia)
values (2, nextval('sekvencia'));
insert into test (id, sekvencia)
values (3, nextval('sekvencia'));

insert into test (id, sekvencia)
values (4, nextval('sekvencia'));

select *
from test;

-- autoinkrementaica stlpca - pseudotyp serial

create table pseudotyp
(
    id serial primary key,
    name varchar(10)
);

insert into pseudotyp (name) values ('Janko');
insert into pseudotyp (name) values ('Zuzka');
insert into pseudotyp (name) values ('Feri');

select * from pseudotyp;

alter sequence pseudotyp_id_seq increment by 5;



