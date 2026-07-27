--SESSION 1
begin;
update requests
set priority_id=2
where request_id=4;

update requests
set priority_id=3
where request_id=10;