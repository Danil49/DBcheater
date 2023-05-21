drop view brand_mile, seller_contacts, year_engine, booking_details, sort_offers, online_users, filtered_offers, brands, remainder, billing_details;
drop table announcement, billing, buying_details, customer, filter, offers, results, sort, vehicle_details, vehicle_types;

CREATE TABLE Results
(
  Result_Id INT NOT NULL PRIMARY KEY,
  Number_of_vehicles INT NOT NULL
);

CREATE TABLE Vehicle_details
(
  Vehicle_Id INT NOT NULL PRIMARY KEY,
  Brand VARCHAR(20) NOT NULL,
  Model VARCHAR(20) NOT NULL,
  Vehicle_year INT NOT NULL,
  CHECK (Vehicle_year between 1900 and 2023),
  Mileage INT NOT NULL,
  Engine FLOAT NOT NULL,
  CHECK (Engine between 0.01 and 100),
  Vehicle_type VARCHAR(20) NOT NULL,
  Power INT NOT NULL,
  CHECK (Power between 1 and 10000)
);

CREATE TABLE Buying_details
(
  Book_Id INT NOT NULL PRIMARY KEY,
  Security_deposit INT,
  Sec_pay_status INT,
  CHECK (Sec_pay_status between 0 and 1),
  Test_drive INT,
  CHECK ( Test_drive between 0 and 1),
  Discount INT
);

CREATE TABLE Billing
(
  Bill_Id INT NOT NULL PRIMARY KEY,
  Book_Id INT NOT NULL,
  Bill_date DATE NOT NULL,
  Bill_status INT NOT NULL default 1,
  CHECK (Bill_status between 0 and 1),
  Total_amount INT NOT NULL,
  Tax_amount INT NOT NULL,
  CHECK (Tax_amount < Total_amount),
  FOREIGN KEY (Book_Id) REFERENCES Buying_details(Book_Id)
);

CREATE TABLE Announcement
(
  Announce_Id INT NOT NULL PRIMARY KEY,
  Result_Id INT NOT NULL,
  Vehicle_Id INT NOT NULL,
  Book_Id INT NOT NULL,
  Price INT NOT NULL,
  CHECK (Price > 0),
  Status INT NOT NULL,
  CHECK (Status between 0 and 1),
  Phone VARCHAR(20) NOT NULL,
  Mail VARCHAR(30) NOT NULL,
  Seller_name VARCHAR(20) NOT NULL,
  Post_date DATE NOT NULL,
  FOREIGN KEY (Result_Id) REFERENCES Results(Result_Id),
  FOREIGN KEY (Vehicle_Id) REFERENCES Vehicle_details(Vehicle_Id),
  FOREIGN KEY (Book_Id) REFERENCES Buying_details(Book_Id)
);

CREATE TABLE Vehicle_types
(
  Type_Id INT NOT NULL PRIMARY KEY,
  Body_type VARCHAR(30),
  Number_of_wheels INT,
  CHECK (Number_of_wheels between 1 and 20)
);

CREATE TABLE Offers
(
  Offer_Id INT NOT NULL PRIMARY KEY,
  Shortcut VARCHAR(50) NOT NULL
);

CREATE TABLE Filter
(
  Type_Id INT NOT NULL,
  Result_Id INT NOT NULL,
  Brand VARCHAR(20),
  Model VARCHAR(20),
  Vehicle_year INT,
  CHECK (Vehicle_year between 1900 and 2023),
  Mileage INT,
  Engine FLOAT,
  CHECK (Engine between 0.01 and 100),
  Vehicle_type VARCHAR(30),
  Power INT,
  CHECK (Power between 1 and 10000),
  PRIMARY KEY (Type_Id, Result_Id),
  FOREIGN KEY (Type_Id) REFERENCES Vehicle_types(Type_Id),
  FOREIGN KEY (Result_Id) REFERENCES Results(Result_Id)
);

CREATE TABLE Sort
(
  Offer_Id INT NOT NULL,
  Type_Id INT NOT NULL,
  Popularity INT,
  FirstNew INT,
  FirstOld INT,
  FirstCheap INT,
  FirstExpensive INT,
  PRIMARY KEY (Offer_Id, Type_Id),
  FOREIGN KEY (Offer_Id) REFERENCES Offers(Offer_Id),
  FOREIGN KEY (Type_Id) REFERENCES Vehicle_types(Type_Id)
);

CREATE TABLE Customer
(
  User_Id INT NOT NULL PRIMARY KEY,
  Username VARCHAR(20) NOT NULL UNIQUE,
  Email VARCHAR(50) NOT NULL UNIQUE,
  Mobile VARCHAR(20) NOT NULL UNIQUE,
  DOB DATE NOT NULL,
  Status INT NOT NULL DEFAULT 1,
  CHECK (Status between 0 and 1),
  Gender CHAR(1) DEFAULT 'M',
  CHECK (Gender = 'M' OR Gender = 'F'),
  Offer_Id INT,
  Vehicle_Id INT,
  FOREIGN KEY (Offer_Id) REFERENCES Offers(Offer_Id),
  FOREIGN KEY (Vehicle_Id) REFERENCES Vehicle_details(Vehicle_Id)
);

insert into
    Results (Result_Id, Number_of_vehicles)
values
    (1, 5),
    (2, 4),
    (3, 34),
    (4, 21),
    (5, 26);

insert into
    Vehicle_details (Vehicle_Id, Brand, Model, Vehicle_year, Mileage, Engine, Vehicle_type, Power)
values
    (1, 'Ferrari', '812', 2019, 2300, 6.5, 'Supercar', 790),
    (2, 'Ford', 'Focus', 2010, 54000, 1.9, 'Sedan', 140),
    (3, 'Lamborghini', 'Huracan', 2019, 500, 5.2, 'Supercar', 520),
    (4, 'Acura', 'RDX', 2016, 76800, 3.5, 'Crossover', 280),
    (5, 'Mitsubishi', 'Lancer', 2008, 130000, 1.6, 'Sedan', 98);

insert into
    Buying_details (Book_Id, Security_deposit, Sec_pay_status, Test_drive, Discount)
values
    (1, 1500, 1, 1, 0),
    (2, 0, 0, 0, 500),
    (3, 0, 0, 0, 0),
    (4, 650, 0, 0, 200),
    (5, 2000, 1, 0, 300);

insert into
    Billing (Bill_Id, Book_Id, Bill_date, Bill_status, Total_amount, Tax_amount)
values
    (1, 1, '2023-04-01', default, 330000, 5000),
    (2, 2, '2023-03-31', default, 9000, 60),
    (3, 3, '2023-03-30', 0, 450000, 7000),
    (4, 4, '2023-03-30', default, 25400, 350),
    (5, 5, '2023-03-30', default, 10000, 400);

insert into
    Announcement (Announce_Id, Result_Id, Vehicle_Id, Book_Id, Price, Status, Phone, Mail, Seller_name, Post_date)
values
    (1, 5, 1, 1, 350000, 1, '421951826632', 'mark@gmail.com', 'Mark', '2023-03-31'),
    (2, 5, 2, 2, 9000, 1, '(875) 234-3815', 'john3344@gmail.com', 'John', '2023-03-30'),
    (3, 5, 3, 3, 450000, 1, '1-485-134-3587', 'bima21@protonmail.com', 'Daniel', '2023-03-26'),
    (4, 5, 4, 4, 25400, 1, '1-279-925-6265', 'racer_kimp@protonmail.com', 'Vladislav', '2023-02-17'),
    (5, 5, 5, 5, 10000, 1, '(911) 942-4801', 'Peter.Pen55@gmail.com', 'Peter', '2023-03-01');

insert into
    Vehicle_types (Type_Id, Body_type, Number_of_wheels)
values
    (1, 'Sedan', 4),
    (2, 'Crossover', 4),
    (3, 'Universal', 4),
    (4, 'Cabriolet', 4),
    (5, 'Moto', 2);

insert into
    Offers (Offer_Id, Shortcut)
values
    (1, 'Ferrari 812 superfast novitec'),
    (2, 'Good Ford Focus with winter tires'),
    (3, 'Lamborghini Huracan STO 5.2 2019'),
    (4, 'Used car in excellent condition'),
    (5, 'Tuned rally car Mitsubishi Lancer');

insert into
    Filter (Type_Id, Result_Id, Brand, Model, Vehicle_year, Mileage, Engine, Vehicle_type, Power)
values
    (1, 1, 'Lamborghini', 'Urus', 2020, 55000, 3.0, 'Crossover', 400),
    (2, 2, 'BMW', 'X5', 2005, 100000, 4.5, 'Crossover', 200),
    (3, 3, 'Lamborghini', 'Huracan', 2022, 3000, 4.0, 'supercar', 550),
    (4, 4, 'Porsche', 'Panamera', 2013, 110000, 4.8, 'Sedan', 440),
    (5, 5, 'Audi', 'RS7', 2016, 40000, 4.4, 'Universal', 450);

insert into
    Sort(Offer_Id, Type_Id, Popularity, FirstNew, FirstOld, FirstCheap, FirstExpensive)
values
    (1, 1, NULL, NULL, NULL, 1, NULL),
    (2, 3, NULL, NULL, NULL, 1, NULL),
    (3, 1, NULL, NULL, NULL, 1, NULL),
    (4, 2, NULL, NULL, NULL, 1, NULL),
    (5, 1, NULL, NULL, NULL, 1, NULL);

insert into
    Customer (User_Id, Username, Email, Mobile, DOB, Status, Gender, Offer_Id, Vehicle_Id)
values
    (1, 'Mark_2', 'mark@gmail.com', '421951826632', '2003-06-01', Default, Default, NULL, 1),
    (2, 'John_GTR', 'john3344@gmail.com', '(875) 234-3815', '1988-06-30', 0, Default, NULL, 2),
    (3, 'BimmerBoy', 'bima21@protonmail.com', '1-485-134-3587', '2001-01-04', Default, Default, NULL, 3),
    (4, 'Racer664', 'racer_kimp@protonmail.com', '1-279-925-6265', '1973-02-27', 0, Default, NULL, 4),
    (5, 'Peter', 'Peter.Pen55@gmail.com', '(911) 942-4801', '1987-12-24', Default, Default, NULL, 5),
    (6, 'User_3301', 'diam.proin@aol.net', '(434) 837-4233', '1966-10-21', Default, Default, 1, NULL),
    (7, 'Racer093_NY', 'placerat.cras.dictum@outlook.org', '(466) 373-8218', '1984-12-24', Default, 'F', 2, NULL),
    (8, 'WarsawRacer', 'nulla.magna.malesuada@yahoo.edu', '(744) 570-6307', '1985-05-30', Default, 'F', 3, NULL);

-- 2 pohľady s jednoduchým netriviálnym selectom nad jednou tabuľkou
-- kupujúci chce najst (odfiltrovat) auto Lamborghini s najazdenými kilometrami menej ako 10000km
create view brand_mile as
select Brand, Model, Mileage
from filter
where Brand = 'Lamborghini' and Mileage <= 10000;

-- kupujúci chce najst (odfiltrovat) auto s objemom motora medzi 2.0 a 3.5, a rokom vyroby medzi 2015 a 2023
create view year_engine as
select Brand, Model, Vehicle_year, Engine
from filter
where Vehicle_year between 2015 and 2023 and Engine between 2.0 and 3.5;

-- 1x spojenie aspoň 2 tabuliek
-- kupujúci chce ziskat kontaktne udaje predajca (mobil, mail, meno) inzeratu o predaji Ford Focus
create view seller_contacts as
select Phone, Mail, Seller_name
from announcement
inner join vehicle_details using (Vehicle_Id)
where Brand = 'Ford' and Model = 'Focus';

-- 1x spojenie aspoň 3 tabuliek
-- kupujúci chce ziskat všetky podrobnosti o nákupe cez vyhladavanie pomocou značky a modela áuta
create view booking_details as
select Book_Id, Announce_Id, Brand, Model, Vehicle_year, Security_deposit, Sec_pay_status, Test_drive, Discount
from announcement
inner join vehicle_details using (Vehicle_Id)
inner join buying_details using (Book_Id)
where Brand = 'Acura' and Model = 'RDX';

-- 1x outer join
-- pouzivatel chce odsortovat vysledky,najprv najlacnejšie auta
create view sort_offers as
select Sort.*, Offers.Offer_Id as Offer_Id_2, Offers.Shortcut, Vehicle_details.*, Announcement.Price, Announcement.Post_date
from sort
full outer join offers on Sort.Offer_Id = Offers.Offer_Id
full outer join vehicle_details on Offers.Offer_Id = Vehicle_details.Vehicle_Id
full outer join announcement on Vehicle_details.Vehicle_Id = Announcement.Vehicle_Id
order by Price asc;

-- 2 pohľady s použitím agregačných funkcií a/alebo zoskupenia
-- Chceme vedieť, koľko zaregistrovaných používateľov je online na web stránke
create view online_users as
select count(user_id) as "Online members"
from customer
where Status = 1;

-- Chceme vedieť, napriklad koľko inzeratov su zobrazene po tom, ako ich používateľ odfiltruje
create view filtered_offers as
select count(offer_id) as "Number of results"
from offers;

-- Používateľ chce objaviť všetky značky áut uvedené na trhu
create view brands as
select Brand from Vehicle_details
union
select Brand from Filter
order by Brand;

-- Používateľ chce napríklad zistiť, či zaplatil PLNÚ sumu, ktorá bola požadovaná predajcom v inzerate.
-- Ak nie, vráti sa mu suma, ktorú musí používateľ ešte zaplatiť
create view remainder as
select bill_id, book_id, (select price from Announcement where announcement.book_id = billing.book_id) - total_amount as required_sum from Billing
where Total_amount < (select price from Announcement where announcement.book_id = billing.book_id);

-- Používateľ chce zistiť všetky fakturačné údaje svojej rezervácie, ktorá má  splnenu podmienku
create view billing_details as
select * from Billing
where book_Id in (select Sec_pay_status from Buying_details where Sec_pay_status = 1);

-- skript na vytvorenie triggeru, ktorý budé implementovať autoinkrementáciu umelých kľúčov
-- pre tabuľku vehicle_details
drop sequence if exists sekvencia;
create sequence sekvencia
increment 1
start with 6;

drop function if exists set_id() CASCADE;
create or replace function set_id() returns trigger
as $$
    begin
        NEW.vehicle_id := nextval('sekvencia');
    RETURN NEW;
    end;
$$ language plpgsql;

drop trigger if exists set_id_trigger on vehicle_details;
create trigger set_id_trigger
BEFORE INSERT ON vehicle_details
for each row
execute FUNCTION set_id();
-- testový insert
insert into vehicle_details(Brand, Model, Vehicle_year, Mileage, Engine, Vehicle_type, Power)
values ('Reno', 'Megan', 2003, 109000, 1.8, 'Sedan', 105);

-- skript na vytvorenie triggeru, ktorý budé implementovať automatické dopĺňanie aktuálneho dátumu
-- pri vytváraní novej faktúry a budé implementovať autoinkrementáciu umelých kľúčov
drop sequence if exists sekv_date;
create sequence sekv_date
increment 1
start with 6;

drop function if exists set_date() CASCADE;
create or replace function set_date() returns trigger
as $$
    begin
        NEW.bill_id := nextval('sekv_date');
        NEW.book_id := currval('sekv_date');
        NEW.bill_date := current_date;
    RETURN NEW;
    end;
$$ language plpgsql;

drop trigger if exists set_date_trigger on billing;
create trigger set_date_trigger
BEFORE INSERT ON billing
for each row
execute FUNCTION set_date();
-- testový insert
insert into buying_details(Book_Id, Security_deposit, Sec_pay_status, Test_drive, Discount)
values (6, 2500, 1, 1, 350);
insert into billing(Bill_status, Total_amount, Tax_amount)
values (default, 55600, 5300);

-- skript na vytvorenie triggeru, ktorý budé overovať vek použivateľa, ak má menej 18 rokov vyskytne chyba
drop function if exists check_age() CASCADE;
create or replace function check_age() returns trigger
as $$
    declare
        birthdate date;
        age integer;
    begin
        birthdate := NEW.DOB;
        age := EXTRACT(YEAR FROM AGE(NOW(), birthdate));
        if age < 18 then
            raise exception 'Users must be at least 18 years old';
        end if;
    RETURN NEW;
    end;
$$ language plpgsql;

CREATE TRIGGER check_age_trigger
BEFORE INSERT ON Customer
FOR EACH ROW
EXECUTE FUNCTION check_age();
-- test insert
insert into Customer(User_Id, Username, Email, Mobile, DOB, Status, Gender, Offer_Id, Vehicle_Id)
values (9, 'TestRacer', 'racer.name.ofnng@yahoo.edu', '(766) 870-6501', '2009-05-30', Default, 'M', 3, NULL);