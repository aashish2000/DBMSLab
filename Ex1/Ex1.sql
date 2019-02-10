REM Assignment 1

REM Drop all tables
drop table order_info;
drop table order_table;
drop table employee;
drop table customer;
drop table pincode;
drop table part;

REM Pincode table creation
create table pincode(
pin_num number(6) constraint pinpk primary key,
loc char(15) constraint locnn not null
);

REM Employee table creation
create table employee(
emp_no varchar2(10) constraint emp_pk primary key,
emp_name char(15) constraint emp_nn not null,
dob date,
pin_num number(6) constraint emp_pin references pincode(pin_num),
constraint ch check(emp_no like 'E%')
);

REM Customer table creation
create table customer(
cus_no varchar2(10) constraint cuspk primary key,
cus_name char(20),
st_name char(20),
pin_num number(6) constraint cusfk references pincode(pin_num),
dob date,
ph_no number(10) constraint cus_ph unique,
constraint cus_nc check(cus_no like 'C%')
);

REM Part table creation
create table part(
part_no varchar2(10) constraint part_pk primary key,
part_name char(15),
price number(10) constraint p_pri not null,
quan number(10) constraint q_c check(quan>0),
constraint part_nc check(part_no like 'P%')
);

REM Orders table creation
create table order_table(
order_no varchar2(10) constraint or_pk primary key,
emp_no varchar2(10) constraint emp_fk references employee(emp_no),
cus_no varchar2(10) constraint cus_fkey references customer(cus_no),
rec_date date,
ship_date date,
constraint ch_date check(rec_date<ship_date)
);

REM Order Info table creation
create table order_info(
order_no varchar2(10) constraint o_fk references order_table(order_no),
part_no varchar2(10) constraint p_fk references part(part_no),
quan number(10),
constraint order_pk primary key(order_no,part_no)
);

REM Describe all tables
desc pincode;
desc employee;
desc customer;
desc part;
desc order_table;
desc order_info;

REM Insert values
insert into pincode values(600011,'Perambur');
insert into pincode values(600012,'Villivakkam');
insert into pincode values(600013,'TNagar');
REM Not null constraint violation
insert into pincode values(600014,NULL);
REM Primary Key violation
insert into pincode values(600013,'Erode');


REM Insert values
insert into employee values('E0001','Ram','20-Aug-1999',600011);
insert into employee values('E0002','Lakshmi','22-Jun-2000',600012);
insert into employee values('E0003','Kumar','28-Mar-2000',600013);
REM Not null primary key violation
insert into employee values(NULL,'Kamesh','28-Mar-2000',600013);
REM Pincode foreign key violation
insert into employee values('E0004','Kumar','28-Mar-2001',600019);
REM Employee number violation
insert into employee values('D0004','Kumar','28-Mar-2001',600019);

REM Insert values
insert into customer values('C2000','Mani','West Road',600012,'31-Aug-1999',9000000001);
insert into customer values('C2001','John','East street',600013,'19-Dec-1999',9000000002);
insert into customer values('C2002','Adam','East Lane',600011,'29-Dec-1999',9000000003);
REM Primary key violation
insert into customer values('C2002','Amy','South Lane',600011,'29-Apr-1999',9000000004);
REM Customer number check violation
insert into customer values('A2002','Amy','South Lane',600011,'29-Apr-1999',9000000005);


REM Insert values
insert into order_table values('O0001','E0001','C2000','12-Aug-2018','13-Aug-2018');
insert into order_table values('O0002','E0003','C2002','15-Aug-2018','18-Aug-2018');
insert into order_table values('O0003','E0002','C2001','10-Aug-2018','19-Aug-2018');
REM Order number Primary Key violation
insert into order_table values('O0003','E0001','C2001','10-Aug-2018','19-Aug-2019');
REM Date check violation
insert into order_table values('O0004','E0002','C2001','20-Aug-2018','19-Aug-2018');

REM Insert values
insert into part values('P0001','Map',300,2);
insert into part values('P0002','Bag',2199,5);
REM Part check constraint error
insert into part values('A0003','Bag',2199,10);
REM Primary key violation
insert into part values('P0002','Belt',299,5);

REM Insert values
insert into order_info values('O0001','P0001',1);
insert into order_info values('O0001','P0002',2);
insert into order_info values('O0002','P0002',1);
insert into order_info values('O0002','P0001',1);
REM Order foreign key violation
insert into order_info values('O0005','P0001',2);
REM Part number violation
insert into order_info values('O0001','P0009',2);

select * from pincode;
select * from employee;
select * from customer;
select * from part;
select * from order_table;
select * from order_info;


REM Add Reorder level as an attribute to part table
alter table part add reorder_level varchar(2);
desc part;

REM Add hiredate as attribute to employee table
alter table employee add hiredate date;

REM Increase length of customer name attribute
alter table customer modify cus_name char(50);
desc customer;

REM Remove the dob column of customer
alter table customer drop column dob;
desc customer;

REM Add constraint such that received date must be entered
alter table order_table modify rec_date not null;
REM Violation
insert into order_table values('O1000','E0001','C0001',NULL,'19-Dec-2018');

REM Add constraint such that deleting a Order removes the 
REM details from the other table
alter table order_info drop constraint o_fk;
alter table order_info add constraint o_fkc foreign key(order_no) references
order_table(order_no) on delete cascade;
desc order_info;
REM Deletion
delete from order_table where order_no = 'O0001';
select * from order_table;
select * from order_info;