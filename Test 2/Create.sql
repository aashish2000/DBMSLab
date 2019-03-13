drop table order_list;
drop table orders;
drop table delivery_boy;
drop table pizza;
drop table pcustomer;

REM pcustomer(cust_id, cust_name,address,phone)

create table pcustomer(
cust_id varchar2(5) constraint cpk primary key,
cust_name varchar2(15),
address varchar2(30),
phone number(10)
);

insert into pcustomer values('c001','hari','32 RING ROAD,ALWARPET',900120003);
insert into pcustomer values('c002','prasanth','42 bull ROAD,numgambakkam',9444120003);
insert into pcustomer values('c003','neethu','12a RING ROAD,ALWARPET',9840112003);
insert into pcustomer values('c004','jim','P.H ROAD,Annanagar',9845712993);
insert into pcustomer values('c005','sindhu','100 feet ROAD,vadapalani',9840166677);

REM pizza (pizza_id, pizza_type, unit_price)

create table pizza(
pizza_id varchar2(5) constraint ppk primary key,
pizza_type varchar2(10),
unit_price number(4)
);

insert into pizza values('p001','pan',130);
insert into pizza values('p002','grilled',230);
insert into pizza values('p003','italian',200);
insert into pizza values('p004','spanish',260);
insert into pizza values('p005','supremo',250);

REM delivery_boy(delv_id, name, phone)

create table delivery_boy(
delv_id varchar2(5) constraint dpk primary key,
name varchar2(15),
phone number(10)
);

insert into  delivery_boy values('d001','gridharan',90908070);
insert into  delivery_boy values('d002','sam',9444109080);
insert into  delivery_boy values('d003','krish',80907090);
insert into  delivery_boy values('d004','nethan',1234567);
insert into  delivery_boy values('d005','jai',911119090);

REM orders(order_no, cust_id, order_date ,delv_date, total_amt,discount, bill_amt, delv_id)

create table orders(
order_no varchar2(5) constraint opk primary key,
cust_id varchar2(5) constraint cidfk references pcustomer(cust_id),
order_date date,
delv_date date,
total_amt number(8,2),
discount number(8,2),
bill_amt number(8,2),
delv_id varchar2(5) constraint didfk references delivery_boy(delv_id)
);

insert into orders values('OP100','c001','28-mar-2011','30-mar-2011',null,null,null,'d003');
insert into orders values('OP200','c002','28-mar-2011','30-mar-2011',null,null,null,'d002');
insert into orders values('OP300','c003','29-mar-2011','31-mar-2011',null,null,null,'d001');
insert into orders values('OP400','c004','29-mar-2011','31-mar-2011',null,null,null,'d001');
insert into orders values('OP500','c001','29-mar-2011','31-mar-2011',null,null,null,'d001');
insert into orders values('OP600','c005','29-mar-2011','02-apr-2011',null,null,null,'d005');
insert into orders values('OP700','c005','29-mar-2011','31-mar-2011',null,null,null,'d001');

REM order_list(order_no, pizza_id, qty)

create table order_list(
order_no varchar2(5) constraint onfk references orders(order_no),
pizza_id varchar2(5) constraint pidfk references pizza(pizza_id),
qty number(3),
constraint olpk primary key(order_no, pizza_id)
);

insert into order_list values('OP100','p001',3);
insert into order_list values('OP100','p002',2);
insert into order_list values('OP100','p003',1);
insert into order_list values('OP100','p004',5);

insert into order_list values('OP200','p003',2);
insert into order_list values('OP200','p001',6);
insert into order_list values('OP200','p004',8);

insert into order_list values('OP300','p003',10);

insert into order_list values('OP400','p001',3);
insert into order_list values('OP400','p004',1);

insert into order_list values('OP500','p003',6);
insert into order_list values('OP500','p004',5);
