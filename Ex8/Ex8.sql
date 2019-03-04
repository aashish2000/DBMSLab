REM ASSIGNMENT 8

REM Bakery Database
@Z:\Ex3\Bakery.sql;

REM 1. For the given receipt number, if there are no rows then display as 
REM “No order with the given receipt <number>”. If the receipt contains more 
REM than one item, display as “The given receipt <number> contains more than 
REM one item”. If the receipt contains single item, display as “The given 
REM receipt <number> contains exactly one item”. Use predefined exception handling.

declare
i products.pid%type;
r Receipts.rno%type;
begin
r := &Receipt_no;
begin
select i1.item into i from item_list i1 where i1.rno = r;
EXCEPTION WHEN NO_DATA_FOUND then
dbms_output.put_line('No such receipt!');
RETURN;
WHEN TOO_MANY_ROWS THEN
DBMS_OUTPUT.PUT_LINE('More than one row found!');
RETURN;
end;
if SQL%ROWCOUNT=1 then
DBMS_OUTPUT.PUT_LINE('One row was found!');
end if;
end;

REM 2. While inserting the receipt details, raise an exception when the 
REM receipt date is greater than the current date.

declare
date_val EXCEPTION;
rn Receipts.rno%type;
rd date;
cid Receipts.cid%type;
cd date;
begin
select sysdate into cd from dual;
rn := &Receipt_no;
cid := &CID;
rd := &Receipt_date;
begin
if rd > cd then
raise date_val;
end if;
exception when date_val then
dbms_output.put_line('Date is greater than current date!');
return;
end;
insert into Receipts values(rn, rd, cid);
end;

REM End