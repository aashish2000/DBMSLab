savepoint s1;

alter table Receipts add amount number(5,2);

REM ************1

create or replace procedure discountcalc(amt IN products.price%type, discount OUT products.price%type, total OUT products.price%type) as
begin
discount := 0;
if amt > 50 then
discount := 0.2*amt;
else
if amt > 25 then
discount := 0.1*amt;
else
if amt > 10 then
discount := 0.05*amt;
end if;
end if;
end if;
total := amt - discount;
end discountcalc;
/


declare 
cust_name1 customers.lname%type;
cust_name2 customers.fname%type;
discount products.price%type;
total products.price%type;
amt products.price%type;
qty integer;
lprice products.price%type;
rec_sel receipts.rno%type;
rec_date date;
counts integer;
food_sel products.food%type;
flavor_sel products.flavor%type;
qtys integer;
cursor c1 is select food, flavor, count(*) as qty, price 
from products p join item_list i on i.item = p.pid
where i.rno = rec_sel 
group by (p.food,p.flavor,p.price);
cursor c2 is select fname,lname,rdate from customers c join receipts r on r.cid = c.cid
where rno = rec_sel;

begin
rec_sel := &rec_sel;
select count(count(*)) into counts from products p join item_list i on i.item = p.pid 
where i.rno = rec_sel
group by (p.food,p.flavor);
select sum(count(*)) into qty from products p join item_list i on i.item = p.pid 
where i.rno = rec_sel
group by (p.food,p.flavor);
open c1;
open c2;
fetch c2 into cust_name1,cust_name2,rec_date;
dbms_output.put_line('Customer name: '||cust_name1||' '||cust_name2);
dbms_output.put_line('Receipt No.: '||rec_sel);
dbms_output.put_line('Receipt date: '||rec_date);
dbms_output.put_line('------------------------------------------');
dbms_output.put_line('SNO FOOD           FLAVOR         QUANTITY');
dbms_output.put_line('------------------------------------------');
amt:=0;
for a in 1..counts loop
            fetch c1 into food_sel,flavor_sel,qtys,lprice;
            dbms_output.put_line(' '||a||' '||flavor_sel||' '||food_sel||' '||qtys);
	    amt := amt + qtys*lprice;
end loop;
dbms_output.put_line('------------------------------------------');
dbms_output.put_line('Total Quantity = '||qty);
dbms_output.put_line('Total = $ '||amt);
discountcalc(amt, discount, total);
update Receipts set amount = total where Receipts.rno = rec_sel;
dbms_output.put_line('Discount = $ '||discount);
dbms_output.put_line('Grand Total = $ '||total);
dbms_output.put_line('------------------------------------------');
dbms_output.put_line('Upto 20% discount available!');
dbms_output.put_line('------------------------------------------');
end;
/

REM *************1

REM *************2

create or replace procedure budgetitems(budget IN products.price%type, iprice IN products.price%type, qty OUT int) as
begin
qty := budget/iprice;
end;
/

declare
budget products.price%type;
qty int;
iprice products.price%type;
foodin products.food%type;
foodo products.flavor%type;
flavoro products.flavor%type;
pido products.pid%type;
priceo products.price%type;
counto int;
cursor c2 is select p.pid, p.food, p.flavor, p.price, count(*) as counts from item_list i join products p on(i.item=p.pid)
where p.food = foodin and p.price <= budget
group by p.pid, p.food, p.flavor, p.price
order by counts desc;
cursor c1 is select p.pid, p.food, p.flavor, p.price, count(*) as counts from item_list i join products p on(i.item=p.pid)
where p.food = foodin and p.price <= budget
group by p.pid, p.food, p.flavor, p.price
order by counts desc;

begin
budget := &budget;
foodin := '&foodin';
dbms_output.put_line('Budget: '||budget||' Food: '||foodin);
dbms_output.put_line('PID        FOOD         FLAVOR       PRICE');
open c2;
loop
fetch c2 into pido, foodo, flavoro, priceo, counto;
if c2%FOUND then
dbms_output.put_line(pido||' '||foodo||' '||flavoro||' '||priceo);
else
exit;
end if;
end loop;
open c1;
fetch c1 into pido, foodo, flavoro, priceo, counto;
if c1%NOTFOUND then
dbms_output.put_line('Cannot buy!');
else
budgetitems(budget, priceo, qty);
dbms_output.put_line('The recommended item is '||pido||' '||flavoro||' '||foodo||'and you can purchase '||qty||' of these!');
end if;
end;
/

REM **************2

REM **************3

create or replace procedure ordinalinc(ord IN OUT item_list.ordinal%type) as
begin
ord := ord + 1;
end;
/

declare
ord item_list.ordinal%type;
itemin item_list.item%type;
receiptin item_list.rno%type;
cidin customers.cid%type;
datein date;
ordcount item_list.ordinal%type;
cursor c1 is select ordinal from item_list where rno = receiptin;
begin
ord := 1;
itemin := '&itemin';
receiptin := &receiptin;
open c1;
loop
fetch c1 into ordcount;
if c1%FOUND then
ordinalinc(ord);
else
exit;
end if;
end loop;
if ord = 1 then
cidin := '&cidin';
datein := '&datein';
insert into Receipts values(receiptin, datein, cidin);
end if;
insert into item_list values(receiptin, ord, itemin);
dbms_output.put_line('Inserted '||receiptin||' '||ord||' '||itemin);
end;

REM **************3

REM **************4

create 


REM **************4