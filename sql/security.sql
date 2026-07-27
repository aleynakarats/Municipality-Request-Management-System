create role r_readonly;
create role r_citizen;
create role r_employee;
create role r_manager;
create role r_dba;


grant usage,select
on all sequences in schema public
to r_citizen,r_employee,r_manager;

grant usage
on schema public
to r_readonly,r_citizen,r_employee,r_manager;

grant connect
on database "MUNICIPAL_DEMAND_MANAGEMENT"
to r_readonly,r_citizen,r_employee,r_manager;


--MANAGER
grant select
on users,roles,departments,categories,priorities,
	request_status,attachments,request_comment,
	request_history,notifications,audit_logs
to r_manager;

grant select,update
on requests,employee_assignment,request_templates
TO R_MANAGER;

--employee
grant select
on departments,categories,priorities,request_status,
	employee_assignment,request_templates,
	request_history
to r_employee;

grant select,update
on notifications,requests
to r_employee;

grant select,insert
on request_comment,attachments
to r_employee;

--CITIZEN
grant select
on departments,categories,priorities,
	request_status,notifications
to r_citizen;

grant select,insert
on requests
to r_citizen;

grant insert
on attachments,request_comment
to r_citizen;

--READYONLY
grant select
on attachments,categories,
	departments,employee_assignment,
	notifications,priorities,
	request_comment,request_history,
	request_status,request_templates,
	requests,roles,users
to r_readonly;


--DBA
alter role r_dba login superuser createdb createrole;


--ROLE ATAMA
create role aleyna login password '123';
grant r_dba to aleyna;

create role vatandas with login password '123';
grant r_citizen to vatandas;

create role havva with login password '123';
grant r_employee to havva;

--TEST
set role havva; --employee

select * from requests;

update requests
set request_status_id=3
where request_id=10;

insert into request_comment
(
	request_id,
	user_id,
	r_comment
)
values
(
	1,
	5,
	'test'
);

reset role;

--
set role aleyna;

select * from audit_logs;

reset role;

--

set role vatandas;
insert into requests(user_id,category_id,title,description)
values
(
	1,
	2,
	'Kaldırım kırık',
	'Kırık kaldırıma insanlar takılıp düşüyor. Yapılmasını talep ediyorum.'	
);

UPDATE requests --yapamaz
SET request_status_id = 2
WHERE request_id = 8;



/*
History, Notification ve Audit trigger fonksiyonları
SECURITY DEFINER olarak oluşturulmuştur.

Böylece request_history,
notifications
ve audit_logs tablolarına
roller için doğrudan INSERT yetkisi verilmemiştir.
*/


