REM ASSIGNMENT 7

REM Bakery Database
@Z:\Ex3\Bakery.sql;

REM Add amount column to Receipts and set value
alter table Receipts add amount number(5,2);
create or replace view amount_set as
select i.rno, sum(p.price) as amt from item_list i join products p
on(i.item = p.pid) group by i.rno;
update Receipts set amount = (select a.amt from amount_set a where a.rno = Receipts.rno);

REM 1. he combination of Flavor and Food determines the product id. Hence, while 
REM inserting a new instance into the Products relation, ensure that the same combination
REM of Flavor and Food is not already available.

create or replace trigger combination
before insert on products for each row
declare
p_food products.food%type;
p_flavor products.flavor%type;
cursor c1 is select food,flavor from products;
begin
open c1;
loop	
fetch c1 into p_food,p_flavor;
if c1%FOUND then
if(p_food = :new.food and p_flavor = :new.flavor) then
raise_application_error(-20000,'Error: Combination Present!');
end if;
else
exit;
end if;
end loop;
end;
/

insert into products values('50-AL-TW-NE','Almond','Twist',6.12);

REM 2. While entering an item into the item_list relation, update the amount in Receipts with
REM the total amount for that receipt number.

create or replace trigger amount_update
after insert on item_list for each row
declare
iprice products.price%type;
begin
select price into iprice from products where pid = :new.item;
update Receipts set amount = amount + iprice where rno = :new.rno;
end;
/

select * from Receipts where rno = 73438;
insert into item_list values(73438, 3, '70-MAR');
select * from Receipts where rno = 73438;

REM 3. Implement the following constraints for Item_list relation:
REM a. A receipt can contain a maximum of five items only.
REM b. A receipt should not allow an item to be purchased more than thrice.

create or replace trigger item_constraint
before insert or update on item_list for each row
begin
if :new.ordinal > 5 then
raise_application_error(-20002,'Error: Has more than 5 items!');
end if;
end;
/ 

insert into item_list values(52761, 6, '70-TU');

create or replace trigger thrice_constraint
before insert or update on item_list for each row
declare
cursor c2 is select rno, item, count(*) as qty from item_list
where item = :new.item and rno = :new.rno
group by item, rno;
q int;
r item_list.rno%type;
i item_list.item%type;
begin
open c2;
fetch c2 into r, i, q;
if c2%FOUND then
if q >= 3 then
raise_application_error(-20003,'Error: Item count > 3!');
end if;
end if;
end;
/

insert into item_list values(31874, 4, '70-MAR');
insert into item_list values(31874, 5, '70-MAR');

REM End