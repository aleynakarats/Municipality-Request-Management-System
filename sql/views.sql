--AÇIK TALEPLER
create or replace view vw_open_requests as
select 
	r.request_id,
	r.title,
	c.category_name,
	d.department_name,
	p.priority_name,
	u.first_name || ' ' || u.last_name as citizen_name,
	r.created_at
from requests r
inner join categories c
	on r.category_id=c.category_id
inner join departments d
	on c.department_id=d.department_id
inner join priorities p
	on r.priority_id=p.priority_id
inner join users u 
	on r.user_id=u.user_id
where r.request_status_id=1;

--select * from vw_open_requests


--TAMAMLANAN TALEPLER RAPORU
create or replace view vw_complete_requests as
select 
	r.request_id,
	r.title,
	c.category_name,
	d.department_name,
	p.priority_name,
	rs.status_name,
	u.first_name || ' ' || u.last_name as citizen_name,
	e.first_name || ' ' || e.last_name as employee_name,
	r.created_at,
	r.closed_at
from requests r
inner join categories c
	on r.category_id=c.category_id
inner join departments d
	on c.department_id=d.department_id
inner join priorities p
	on r.priority_id=p.priority_id
inner join request_status rs
	on r.request_status_id=rs.request_status_id
inner join users u
	on r.user_id=u.user_id
inner join users e
	on r.assigned_employee_id=e.user_id
where r.request_status_id=4;

--select * from vw_complete_requests

--PERSONELİN ÜZERİNDEKİ İŞ YÜKÜ
create or replace view vw_employee_workload as
select 
	u.user_id as employee_id,
	u.first_name || ' ' || u.last_name as employee_name,
	d.department_name,
	count(r.request_id) as active_request_count
from users u
left join requests r 
	on u.user_id=r.assigned_employee_id
	and r.request_status_id in(2,3)
inner join departments d
	on u.department_id=d.department_id
where u.role_id=2
group by
	u.user_id,
	u.first_name,
	u.last_name,
	d.department_name
order by active_request_count desc;

--select * from vw_employee_workload

--DEPARTMAN BAZLI İSTATİSTİK
create or replace view vw_department_statistics as
select
	d.department_id,
	d.department_name,
	d.manager_user_id,
	u.first_name ||' ' || u.last_name as manager_name,
	count(r.request_id) as total_requests,
	count(r.request_id) filter (where r.request_status_id=1) as open_requests,
	count(r.request_id) filter (where r.request_status_id=2) as assigned_requests,
	count(r.request_id) filter (where r.request_status_id=3) as in_progress_requests,
	count(r.request_id) filter (where r.request_status_id=4) as completed_requests,
	count(r.request_id) filter (where r.request_status_id=5) as rejected_requests
from departments d
left join categories c
	on d.department_id = c.department_id
left join requests r
	on c.category_id = r.category_id
left join users u
	on u.user_id = d.manager_user_id
group by
	d.department_id,
	d.department_name,
	d.manager_user_id,
	u.first_name,
	u.last_name;	

--select * from vw_department_statistics

--BİR VATANDAŞIN OLUŞTURDUĞU TÜM TALEPLER
create or replace view vw_citizen_requests as
select
	r.request_id,
	u.first_name || ' ' || u.last_name as citizen_name,
	r.title,
	c.category_name,
	p.priority_name,
	re.status_name,
	r.created_at,
	r.closed_at
from requests r
inner join users u
	on u.user_id=r.user_id
inner join categories c
	on c.category_id=r.category_id
inner join priorities p
	on p.priority_id=r.priority_id
inner join request_status re
	on re.request_status_id=r.request_status_id;

--select * from vw_citizen_requests;

--SON 30 GÜN TALEPLERİ
create or replace view vw_recent_requests as
select
	r.request_id,
	c.category_name,
	u.first_name || ' ' || u.last_name as citizen_name,
	r.title,
	d.department_name,
	p.priority_name,
	re.status_name,
	r.created_at
from requests r
inner join categories c
	on r.category_id=c.category_id
inner join departments d
	on d.department_id=c.department_id
inner join users u
	on r.user_id=u.user_id
inner join priorities p
	on r.priority_id=p.priority_id
inner join request_status re
	on r.request_status_id=re.request_status_id
where r.created_at >= now() - interval '30 days';

--select * from vw_recent_requests

