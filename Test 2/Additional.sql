REM Trigger - a delivery boy can deliver a maximum of 3 orders per day

create or replace trigger delcheck
before insert on orders for each row
declare
cursor c1 is select count(*) from orders o join delivery_boy d on(o.delv_id = d.delv_id)
where d.delv_id = :NEW.delv_id and o.delv_date = :NEW.delv_date;
counts int;
begin
open c1;
fetch c1 into counts;
if counts >= 3 then
raise_application_error(-20003, 'Error: Maximum 3 orders for a delivery boy per day!');
end if;
end;
/

REM Check trigger

insert into orders values('OP800','c001','29-mar-2011','31-mar-2011',null,null,null,'d001');