create table Arrivals(
flno varchar2(10) constraint A_pk primary key,
arrdate date constraint A_d not null,
status varchar2(10) constraint A_s check(status in('Arrived', 'On Time', 'Delayed', 'Cancelled')),
origin varchar2(3) constraint A_o not null,
terminal number(1) constraint A_n check(terminal in(1, 2, 3, 4, 5))
);

create table Departures(
flno varchar2(10) constraint D_pk primary key,
depdate date constraint D_d not null,
status varchar2(10) constraint D_s check(status in('Arrived', 'On Time', 'Delayed', 'Cancelled')),
dest varchar2(3) constraint D_o not null,
terminal number(1) constraint D_n check(terminal in(1, 2, 3, 4, 5))
);