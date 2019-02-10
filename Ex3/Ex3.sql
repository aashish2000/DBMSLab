REM Answers

REM Display the food details that is not purchased by any of customers
select * from products where pid not in(select distinct item from item_list);

REM Show the customer details who had placed more than 2 orders on the same date.
select * from customers
where cid in(select cid from Receipts
group by Receipts.cid, Receipts.rdate
having count(*) > 2);

REM Display the products details that has been ordered maximum by the customers. (use ALL)
select * from products p
where pid in(select item from item_list
group by item
having count(*) >= all(select count(*) from item_list group by item));

REM Show the number of receipts that contain the product whose price is more than the
REM average price of its food type.
select count(distinct rno) from item_list
where item in(select pid from products p
where price > (select avg(price) from products q
group by food having p.food = q.food));

REM Display the customer details along with receipt number and date for the receipts that
REM are dated on the last day of the receipt month.
select c.*, r.rno, r.rdate from customers c
join Receipts r on(c.cid = r.cid)
where r.rdate = last_day(r.rdate);


REM Display the receipt number(s) and its total price for the receipt(s) that contain Twist
REM as one among five items. Include only the receipts with total price more than $25.
select i.rno, sum(price) from item_list i join
products p on(i.item = p.pid)
where i.rno in(select i.rno from item_list i join products p on(i.item = p.pid) where p.food = 'Twist' group by i.rno)
group by i.rno
having sum(price) > 25 and count(*) = 5;

REM Display the details (customer details, receipt number, item) for the product that was
REM purchased by the least number of customers.
select r.rno,c.*,i.item from item_list i join Receipts r on(r.rno = i.rno) join customers c on(r.cid = c.cid)
where i.item in(
select p.pid from products p
join item_list i on(p.pid = i.item)
group by p.pid
having count(*) <= all(select count(*) from products p join item_list i on(p.pid = i.item) group by p.pid));

REM Display the customer details along with the receipt number who ordered all the
REM flavors of Meringue in the same receipt.
select c.*, r.rno from customers c join Receipts r on(r.cid=c.cid) where r.rno = (
select re.rno from Receipts re join item_list it on(re.rno = it.rno)
join products pr on(pr.pid = it.item)
where pr.food = 'Meringue' group by re.rno
having count(distinct flavor) = (select count(distinct flavor) from products where food = 'Meringue'));

REM Display the product details of both Pie and Bear Claw.
(select * from products where food = 'Pie') union (select * from products where food = 'Bear Claw');

REM Display the customers details who haven't placed any orders.
select * from customers where cid in(
select cid from customers minus select cid from Receipts);

REM Display food with flavor common to Meringue and Tart
select food from products where flavor = (
(select flavor from products where food='Meringue') intersect
(select flavor from products where food='Tart')
) and food not in('Meringue', 'Tart');