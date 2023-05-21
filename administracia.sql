-- zoznam pouzivatelov s login a privilegiami
SELECT usename AS role_name,
       CASE
           WHEN usesuper AND usecreatedb THEN
               CAST('superuser, create database' AS pg_catalog.text)
           WHEN usesuper THEN
               CAST('superuser' AS pg_catalog.text)
           WHEN usecreatedb THEN
               CAST('create database' AS pg_catalog.text)
           ELSE
               CAST('' AS pg_catalog.text)
           END    role_attributes
FROM pg_catalog.pg_user
ORDER BY role_name desc;

-- vypis aktualneho stavu
select "current_user"();
select current_database();
select "current_schema"();

-- vytvorenie superuser
create role perhac with superuser login createdb createrole replication password 'test';

-- vytvorenie beznych pouzivatelov
create user student with password 'test';
create user zamestnanec with password 'test';

-- vytvorenie databazy studenti bez parametrov
create database studenti;

-- vytvorenie databazy zamestnanci s parametrami
create database zamestnanci
    with
    encoding = 'UTF8'
    owner = zamestnanec
    connection limit = 100;

-- vytvorenie vzorovej DB
create database testdb;

-- premenovanie databazy testdb
alter database testdb rename to testdb2;

-- zmena vlastnika databazy testdb2 na pouzivatela student
alter database testdb2 owner to student;

-- vytvorenie tablespace testTB
create tablespace testTB owner student location 'D:\testTB';

alter database testdb2 set tablespace testTB;
alter database testdb2 owner to postgres;

-- zmazanie databazy s aktivnym pripojenim
drop database testdb2;
-- chyba

select * from pg_stat_activity where datname = 'testdb2';

-- select pg_terminate_backend(13304) from pg_stat_activity where datname = 'testdb2';

drop database testdb2;



-- Schemy

SELECT current_schema();
Show search_path;

select "current_user"();

create schema cvicenia;
SET search_path TO cvicenia, public;

create table test(id int primary key, nazov varchar(10) );
drop table test;
create table public.test(id int primary key, nazov varchar(10) );

insert into public.test values (1,'public');

insert into test values (2,'cvicenia');

select * from public.test;
select * from test;


-- ROLES

-- vytvorenie pouzivatela
CREATE ROLE pouzivatel WITH LOGIN
PASSWORD 'test';

-- vytvorenie skupiny
CREATE ROLE skupina;

-- prihlasenie v psql na pouzivatela na DB

-- Nastavenie privilégií skupine:
GRANT USAGE ON SCHEMA cvicenia TO skupina;
GRANT SELECT ON ALL TABLES
IN SCHEMA cvicenia TO skupina;

-- Priradenie používateľa do skupiny:
GRANT skupina TO pouzivatel;



-- roly a schemy pristup
grant usage on schema public to student;
revoke usage on schema public from student;
grant select on all tables in schema public to student;
create table test(id serial);


create table cvicenia.test(id serial);

grant usage on schema cvicenia to student;
revoke usage on schema cvicenia from student;

revoke usage on schema public from student;
grant select on all tables in schema cvicenia to student;













