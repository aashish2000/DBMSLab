REM ASSIGNMENT 5
REM 1. Check whether the given combination of food and flavor is available. If any one or
REM both are not available, display the relevant message.
declare

foodn products.food%type;
flavorn products.flavor%type;
foodout products.food%type;
flavorout products.flavor%type;

begin

foodn:='&foodn';
flavorn:='&flavorn';

begin
select food, flavor into foodout, flavorout from products where food=foodn and flavor=flavorn;
exception when no_data_found then
dbms_output.put_line('Combination not found!');
end;

if SQL%FOUND then
dbms_output.put_line('Combination found!');

else

begin
select distinct food into foodout from products where food=foodn;
exception when no_data_found then
dbms_output.put_line('Food not found!');
end;

if SQL%FOUND then
dbms_output.put_line('Food found!');
end if;

begin
select distinct flavor into flavorout from products where flavor=flavorn;
exception when no_data_found then
dbms_output.put_line('Flavor not found!');
end;

if SQL%FOUND then
dbms_output.put_line('Flavor found!');
end if;

end if;

end;
/

REM 2. On a given date, find the number of items sold (Use Implicit cursor).
declare 
countitems number(5); 
datein date;
begin 
datein := '&datein'; 
update item_list i set i.ordinal=i.ordinal+0 where i.rno in(select Receipts.rno from item_list join Receipts on(item_list.rno = Receipts.rno) where Receipts.rdate = datein); 
countitems := SQL%ROWCOUNT;
DBMS_OUTPUT.PUT_LINE('Value: ' || countitems); 
end;
/

REM 3. An user desired to buy the product with the specific price. Ask the user for a price,
REM find the food item(s) that is equal or closest to the desired price. Print the product
REM number, food type, flavor and price. Also print the number of items that is equal or
REM closest to the desired price.

declare 
ip_price products.price%type;
cursor c1 is select * from products 
where abs(price-ip_price) = 
(select min(abs(price-ip_price)) from products);
pro products%rowtype;
c integer;
begin 
	ip_price := &input_price;
	open c1;
	c := 0;
	loop
		fetch c1 
		into pro.pid, pro.flavor, pro.food, pro.price;
		if c1%found then 
			dbms_output.put_line(pro.pid||' '||pro.flavor||' '||pro.food||' '||pro.price);
			c := c+1;
		else	
			exit;
		end if;
	end loop;
	dbms_output.put_line(c);
end;
/

REM 4. Display the customer name along with the details of item and its quantity ordered for
REM the given order number. Also calculate the total quantity ordered as shown below:
declare 
cust_name1 customers.lname%type;
cust_name2 customers.fname%type;
qty integer;
rec_sel receipts.rno%type;
counts integer;
food_sel products.food%type;
flavor_sel products.flavor%type;
qtys integer;
cursor c1 is select food, flavor, count(*) as qty 
from products p join item_list i on i.item = p.pid
where i.rno = rec_sel 
group by (p.food,p.flavor);
cursor c2 is select fname,lname from customers c join receipts r on r.cid = c.cid
where rno = rec_sel ;

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
fetch c2 into cust_name1,cust_name2;
dbms_output.put_line('Customer name: '||cust_name1||' '||cust_name2); 
dbms_output.put_line('FOOD           FLAVOR         QUANTITY');
dbms_output.put_line('------------------------------------------');
for count in 1..counts loop
            fetch c1 into food_sel,flavor_sel,qtys;
            dbms_output.put_line(flavor_sel||' '||food_sel||' '||qtys);
    end loop;
	
dbms_output.put_line('------------------------------------------');
dbms_output.put_line('Total Quantity='||qty);
end;
/