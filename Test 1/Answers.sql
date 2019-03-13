alter table nobel modify year_award number(4) constraint ya_nn not null;

select * from nobel where name like '___i%' and category = 'Pea';

select name, category, year_award, country, dob from nobel
where year_award = 1998 and ((extract(year from dob)) between 1930 and 1945)
and country in ('USA', 'India');

select aff_role, count(*) from nobel
where year_award = 2001 and aff_role is not null
group by aff_role
order by aff_role;

select country, category, count(*) from nobel
group by country, category
having count(*) > 1
order by country;