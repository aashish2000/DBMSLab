REM Assignment 2

REM 1. Display the nobel laureate(s) who born after 1�Jul�1960.

select * from nobel where dob > TO_DATE('01-Jul-1960','DD-MON-YYYY');

REM 2. Display the Indian laureate (name, category, field, country, year awarded) 
REM who was awarded in the Chemistry category.

select name, category, field, country, year_award from nobel
where country = 'India' and category = 'Che';

REM 3. Display the laureates (name, category,field and year of award) who was 
REM awarded between 2000 and 2005 for the Physics or Chemistry category.

select name, category, field, year_award from nobel
where (year_award between 2000 and 2005) and category in('Phy','Che');

REM 4. Display the laureates name with their age at the time of award for
REM the Peace category.

select name, (year_award - TO_NUMBER(extract(year from dob))) as age, year_award, category, aff_role
from nobel
where category = 'Pea';

REM 5. Display the laureates (name,category,aff_role,country) whose 
REM name starts with A or ends with a, but not from Isreal.

select name, category, aff_role, country from nobel
where (name like 'A%' or name like '%a') and country != 'Isreal';

REM 6. Display the name, gender, affiliation, dob and country of laureates 
REM who was born in 1950s. Label the dob column as Born 1950.

select name, gender, aff_role, dob as Born_1950, country
from nobel
where extract(year from dob) = '195%';

REM 7.Display the laureates (name,gender,category,aff_role,country) whose name 
REM starts with A, D or H. Remove the laureate if he/she do not have any affiliation. 
REM Sort the results in ascending order of name.

select name, gender, category, aff_role, country from nobel
where (name like 'A%' or name like 'D%' or name like 'H%')
and aff_role is not null order by name;

REM 8. Display the university name(s) that has to its credit by having at least 
REM 2 nobel laureate with them.

select aff_role, count(*) from nobel
where aff_role like 'University%'s
group by aff_role
having count(aff_role) >= 2;

REM 9. List the date of birth of youngest and eldest laureates by countrywise.
REM Label the column as Younger, Elder respectively. Include only the country having 
REM more than one laureate. Sort the output in alphabetical order of country.

select country, max(dob) as Younger, min(dob) as Elder from nobel
group by country
having count(name) >= 2
order by country;

REM 10. Show the details (year award,category,field) where the award is shared among the
REM laureates in the same category and field. Exclude the laureates from USA.

select year_award, category, field, count(*) from nobel
where country != 'USA'
group by year_award, category, field
having count(*) >= 2 order by year_award;

REM TCL Commands

savepoint A;
insert into nobel values(129,'Ram','m','Phy','World Organizing','2018','Cambridge University','19-JUN-1958','India');
select * from nobel where name = 'Ram';
update nobel set aff_role='Linguists' where category = 'Lit';
delete from nobel where field='Enzymes';
select * from nobel where field='Enzymes';
rollback to A;
select * from nobel where name = 'Ram';
commit;

REM End