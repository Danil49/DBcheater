
-- 23/03/2022

select now();

select m.nazov, s.nazov
from mesto m
         join stat s on s.id = m.id_stat;

select nazov as Meno
from stat
union
select nazov
from mesto
order by Meno;

select nazov as Meno
from stat
union all
select nazov
from mesto
order by Meno;

select nazov as Meno
from stat
intersect
select nazov
from mesto
order by Meno;

select nazov as Meno
from stat
    except
select nazov
from mesto
order by Meno;

select nazov as Meno
from mesto
    except
select nazov
from stat
order by Meno;

select count(*)
from mesto
where populacia > 100000;

select *
from mesto;

UPDATE public.mesto
SET populacia = 40000
WHERE id = 3;

UPDATE public.mesto
SET populacia = 95000
WHERE id = 2;

select avg(populacia)
from mesto;

select min(populacia)
from mesto;

select max(populacia)
from mesto;

select sum(populacia)
from mesto;

select min(nazov)
from mesto;


select s.nazov, count(s.nazov) as pocet
from mesto m
         join stat s on s.id = m.id_stat
group by s.nazov
having count(s.nazov) > 3;


select  s.nazov, m.nazov, count(s.nazov) as pocet
from mesto m
         join stat s on s.id = m.id_stat
group by rollup (s.nazov,m.nazov);


select  s.nazov, m.nazov, count(s.nazov) as pocet
from mesto m
         join stat s on s.id = m.id_stat
group by cube (s.nazov,m.nazov);



