drop view Blue_Flavor;
drop view Cheap_Food;
drop view Hot_Food;
drop view Pie_Food;
drop view Cheap_View;
drop sequence Ordinal_No_Seq;
drop sequence OSeq;
drop synonym Product_details;

REM Create a view named Blue_Flavor, which display the product details (product id,
REM food, price) of Blueberry flavor

create view Blue_Flavor as
select pid, food, price from products
where flavor = 'Blueberry';

select COLUMN_NAME, UPDATABLE from USER_UPDATABLE_COLUMNS where TABLE_NAME='BLUE_FLAVOR';

update Blue_Flavor set price='1.00' where pid='90-BLU-11';
select * from Blue_Flavor where pid like '90%';
insert into Blue_Flavor values('80-B-12','Croissant',1.95);
select * from products where pid='80-B-12';
insert into Blue_Flavor values('90-BLU-11','Food',2.05);
delete from Blue_Flavor where food = 'Tart';

REM Insert into table, check if view reflects
insert into products values('N-11-BLU', 'Blueberry', 'Coulis', 12.10);
select * from Blue_Flavor;

REM It is updatable and the DML have been done. The delete fails for those recipts
REM that are referenced in the item_list. 

REM Create a view named Cheap_Food, which display the details (product id, flavor,
REM food, price) of products with price lesser than $1. Ensure that, the price of these
REM food(s) should never rise above $1 through view.

create view Cheap_Food as
select * from products
where price < 1
with check option;

select COLUMN_NAME, UPDATABLE from USER_UPDATABLE_COLUMNS where TABLE_NAME='CHEAP_FOOD';

update Cheap_Food set price = '0.10' where price < 1;
select * from Cheap_Food;
insert into Cheap_Food values('70-LEMO','Lemon','Tarts',9.5);
insert into Cheap_Food values('70-LEMO','Lemon','Tarts',0.5);
select * from Cheap_Food where pid='70-LEMO';
select * from products where pid='70-LEMO';
delete from Cheap_View where Food='Tarts';
delete from Cheap_View where pid='70-LEM';

REM Check if view reflects table insert
insert into products values('76-LEMC','Lemon','Cakes',0.99);
select * from Cheap_Food;

REM It is updatable and the DML have been done. The pid referred in item_list can't 
REM be modified or deleted

REM Create a view called Hot_Food that show the product id and its quantity where the
REM same product is ordered more than once in the same receipt.

create view Hot_Food as
select item, count(*) as count from item_list
group by rno, item
having count(*) > 1;

select COLUMN_NAME, UPDATABLE from USER_UPDATABLE_COLUMNS where TABLE_NAME='HOT_FOOD';

update Hot_Food set count=3 where count=2;
insert into Hot_Food values('Cakes',10);
insert into Hot_Food values('90-CHRE',5);
delete from Hot_Food where item='90-APR-PF';

REM It is not insert or modify updatable. We can delete the items.

REM Create a view named Pie_Food that will display the details (customer lname, flavor,
REM receipt number and date, ordinal) who had ordered the Pie food with receipt details.

create view Pie_Food as
select c.lname, p.flavor, r.rno, r.rdate, i.ordinal
from customers c, products p, Receipts r, item_list i
where p.food = 'Pie' and c.cid = r.cid and i.item = p.pid and i.rno = r.rno;

select COLUMN_NAME, UPDATABLE from USER_UPDATABLE_COLUMNS where TABLE_NAME='PIE_FOOD';

update Pie_Food set rdate = '28-NOV-07' where lname='Arnn';
update Pie_Food set ordinal = 5 where ordinal = 4;
update Pie_Food set ordinal=1 where ordinal = 5;
insert into Pie_Food values('Arnn','Apple',11548,'21-OCT-07',5);
delete from Pie_Food where ordinal = 5;
delete from Pie_Food where lname = 'ARNN';
insert into item_list values(68753,6,'90-APIE-10');
select * from Pie_Food where ordinal=6;

REM It is not entirely updatable as only ordinal can be modified, otherwise non-updatable

REM Create a view Cheap_View from Cheap_Food that shows only the product id, flavor
REM and food.

create view Cheap_View as
select pid, flavor, food from Cheap_Food;

select COLUMN_NAME, UPDATABLE from USER_UPDATABLE_COLUMNS where TABLE_NAME='CHEAP_VIEW';

select * from Cheap_View;
delete from Cheap_View where Food='Cakes';
delete from Cheap_View where pid='70-LEM';
insert into Cheap_View values('76-LEMCS','Lemon','Coulis');
update Cheap_View set Flavor = 'Lemony' where flavor = 'Lemon';

REM It is updatable and the DML have been done. Values referred by item_list can't be removed

REM Create a sequence named Ordinal_No_Seq which generates the ordinal number
REM starting from 1, increment by 1, to a maximum of 10. Include the options of cycle,
REM cache and order. Use this sequence to populate the item_list table for a new order.

create sequence Ordinal_No_Seq
start with 1
minvalue 1
maxvalue 10
increment by 1
cache 5
cycle;

create sequence OSeq
start with 3
minvalue 1
maxvalue 5
increment by 1
cache 2
cycle;

insert into item_list values(34378, OSeq.nextval, '45-VA');
insert into item_list values(34378, OSeq.nextval, '45-VA');
insert into item_list values(34378, OSeq.nextval, '45-VA');
select * from item_list where rno=34378;

delete from item_list where rno=34378 and ordinal = 1;
insert into item_list values(34378, OSeq.nextval, '90-APIE-10');
select * from item_list where rno=34378;

REM Create a synonym named Product_details for the item_list relation. Perform the
REM DML operations on it.

create synonym Product_details for item_list;

insert into Product_details values(41963,5,'45-VA');
select * from Product_details where rno = 41963;
delete from Product_details where rno = 41963;
select * from Product_details where rno = 41963;


REM Drop all the above created database objects.
drop view Blue_Flavor;
drop view Cheap_Food;
drop view Hot_Food;
drop view Pie_Food;
drop view Cheap_View;
drop sequence Ordinal_No_Seq;
drop synonym Product_details;