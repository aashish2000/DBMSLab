create or replace procedure discalc(ono IN orders.order_no%type, discountp OUT int) as
pizzas int;
begin
discountp:=0;
select sum(qty) into pizzas from order_list where order_no = ono;
if pizzas >= 7 then
discountp:=10;
else
if pizzas >= 4 then
discountp:=7;
else
if pizzas = 3 then
discountp:=5;
end if;
end if;
end if;
end discalc;
/

create or replace procedure totalcalc(ono IN orders.order_no%type, total OUT orders.total_amt%type) as
cursor c1 is select o.qty, p.unit_price from order_list o join pizza p on(p.pizza_id = o.pizza_id)
where o.order_no = ono;
pq order_list.qty%type;
pp pizza.unit_price%type;
begin
open c1;
total:=0;
loop
fetch c1 into pq, pp;
if c1%FOUND then
total:=total+pq*pp;
else
exit;
end if;
end loop;
end totalcalc;
/

declare
cursor oc is select order_no from orders;
total orders.total_amt%type;
discountp int;
ono orders.order_no%type;
bamt orders.bill_amt%type;
disc orders.discount%type;
begin
open oc;
loop
fetch oc into ono;
if oc%FOUND then
discalc(ono,discountp);
totalcalc(ono,total);
disc:=discountp*total/100;
bamt:=total-disc;
update orders set discount = disc, total_amt = total, bill_amt = bamt where order_no = ono;
else
exit;
end if;
end loop;
end;
/

select * from orders;


