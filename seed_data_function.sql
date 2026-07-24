-------REQUESTS
create or replace function generate_random_requests(p_count int)
returns void
language plpgsql
as $$
declare v_category_id int;
		v_title varchar(200);
		v_description text;
		v_random_citizen_id int;
		v_priority_id int;
		v_request_id int;
		v_manager_user_id int;
begin
  for i in 1..p_count loop
  
	select category_id,title,description 
	into v_category_id,v_title,v_description
	from request_templates
	order by random()
	limit 1;

	select user_id
	into v_random_citizen_id
	from users
	where role_id=1 and is_active=true
	order by random()
	limit 1;

	select priority_id
	into v_priority_id
	from priorities
	order by random()
	limit 1;

	insert into requests(user_id,category_id,title,description,request_status_id,priority_id,created_at)
	values(v_random_citizen_id,v_category_id,v_title,v_description,1,v_priority_id,now()-(floor(random()*30) * interval '1 day'))
	returning request_id
	into v_request_id;

	insert into request_history(request_id,old_status_id,new_status_id,changed_by_user_id)
	values(v_request_id,null,1,v_random_citizen_id);

	-- İlgili departmanın yöneticisini bul
	select d.manager_user_id
	into v_manager_user_id
	from categories c
	join departments d
    on c.department_id = d.department_id
	where c.category_id = v_category_id;

	-- Yöneticiye bildirim gönder
	insert into notifications(user_id, title, messages)
	values
	(
    v_manager_user_id,
    'Yeni Talep Oluşturuldu',
    'Sorumlu olduğunuz departmana yeni bir talep oluşturuldu.'
	);
	
  end loop;
  return;
 
end;
$$
---KONTROL
--select generate_random_requests(50);
--select * from requests
--select * from notifications

-----open durumundaki talepleri assigned durumuna geçirir
create or replace function assign_random_employee(p_count int)
returns void
language plpgsql
as $$
declare
	v_employee_user_id int;
	v_manager_user_id int;
	v_request_id int;
	v_category_id int;
	v_department_id int;
begin
  for i in 1..p_count loop

	v_request_id:=null;
	v_employee_user_id:=null;
	v_manager_user_id:=null;
  
    select request_id,category_id
	into v_request_id,v_category_id
	from requests
	where request_status_id=1
	order by random()
	limit 1;

	if v_request_id is null then --açık talep kalmadıysa döngüyü sıfırlar
		exit;
	end if;

	select department_id
	into v_department_id
	from categories
	where category_id=v_category_id;

	select user_id
	into v_employee_user_id
	from users
	where role_id=2 and department_id=v_department_id
	order by random()
	limit 1;
	
	select user_id
	into v_manager_user_id
	from users
	where role_id=3 and department_id=v_department_id
	order by random()
	limit 1;

	--eğer departmanda personel ve yönetici varsa işlemleri yap
	if v_employee_user_id is not null
	and 
	v_manager_user_id is not null then

		update requests
		set request_status_id=2,assigned_employee_id=v_employee_user_id
		where request_id=v_request_id;

		insert into employee_assignment(request_id,employee_user_id,assigned_by_user_id)
		values(v_request_id,v_employee_user_id,v_manager_user_id);

		insert into request_history(request_id,old_status_id,new_status_id,changed_by_user_id)
		values(v_request_id,1,2,v_manager_user_id);

		insert into notifications(user_id,title,messages)--çalışana bildirim
		values
		(
 	 	  v_employee_user_id,
   		  'Yeni Görev Atandı',
    	  'Size yeni bir talep atanmıştır.'
		);
	end if;

  end loop;
  return;
end;
$$

select assign_random_employee(5)
--select * from requests where request_status_id=2
--select * from notifications


--personelin işe başlaması
create or replace function start_random_requests(p_count int)
returns void
language plpgsql
as $$
declare
	v_request_id int;
	v_assigned_employee_id int;
	v_user_id int;
begin
	for i in 1..p_count loop

		v_request_id:=null;
		v_assigned_employee_id:=null;
	
		select request_id,user_id,assigned_employee_id
		into v_request_id,v_user_id,v_assigned_employee_id
		from requests
		where request_status_id=2
		order by random()
		limit 1;

		if v_request_id is null then
			exit;
		end if;

		update requests
		set request_status_id=3
		where request_id=v_request_id;

		insert into request_history(request_id,old_status_id,new_status_id,changed_by_user_id)
		values(v_request_id,2,3,v_assigned_employee_id);

		insert into notifications(user_id,title,messages)--vatandaşa bildirim
		values
		(
  		  v_user_id,
  		  'Talebiniz İşleme Alındı',
   		 'Talebiniz ekiplerimiz tarafından işleme alınmıştır.'
		);
	end loop;
	return;
end;
$$

select start_random_requests(10)


----personelin işi tamamlaması
create or replace function complete_random_requests(p_count int)
returns void
language plpgsql
as $$
declare
	v_request_id int;
	v_assigned_employee_id int;
	v_user_id int;
begin
	for i in 1..p_count loop

		v_request_id:=null;
		v_assigned_employee_id:=null;
	
		select request_id,user_id,assigned_employee_id
		into v_request_id,v_user_id,v_assigned_employee_id
		from requests
		where request_status_id=3
		order by random()
		limit 1;

		if v_request_id is null then
			exit;
		end if;

		update requests
		set request_status_id=4,
			closed_at=now()
		where request_id=v_request_id;

		insert into request_history(request_id,old_status_id,new_status_id,changed_by_user_id)
		values(v_request_id,3,4,v_assigned_employee_id);

		insert into notifications(user_id,title,messages)
		values
		(
 		   v_user_id,
  		  'Talebiniz Tamamlandı',
   		  'Talebiniz başarıyla tamamlanmıştır.'
		);
	end loop;
	return;
end;
$$

select complete_random_requests(10)
select * from notifications

---yorum ekleme
create or replace function generate_random_comments(p_count int)
returns void
language plpgsql
as $$ 
declare
	v_request_id int;
	v_user_id int;
	v_request_status_id int;
	v_comment_text text;
	v_manager_user_id int;
	v_assigned_employee_id int;
	v_target_user_id int;
	v_category_id int;
begin
	for i in 1..p_count loop

		v_request_id := NULL;
        --v_citizen_id := NULL;
		v_user_id:=null;
        v_assigned_employee_id := NULL;
        v_manager_user_id := NULL;
        v_request_status_id := NULL;
		v_category_id:=null;
		v_target_user_id:=null;
	
		select request_id,user_id,category_id,request_status_id,assigned_employee_id
		into v_request_id,v_user_id,v_category_id,v_request_status_id,v_assigned_employee_id
		from requests
		order by random()
		limit 1;

	if v_request_id is null then
		exit;
	end if;

		--departman müdürünü bulalım
		select d.manager_user_id 
		into v_manager_user_id
		from categories c
		join  departments d on c.department_id=d.department_id
		where c.category_id=v_category_id;
	
		if v_request_status_id=1 then--vatandaş yorumu
			v_target_user_id:=v_user_id;
			v_comment_text:='Bu talebimin acil işleme alınmasını rica ediyorum.';
			
		elsif v_request_status_id=2 then --manager
			v_target_user_id:=v_manager_user_id;
			v_comment_text:='Ekiplerimiz bölgeye yönlendirilmiştir.';

		elsif v_request_status_id=3 then --employee
			v_target_user_id:=v_assigned_employee_id;
			v_comment_text:='Sorun yerinde incelendi işleme alındı.';

		elsif v_request_status_id=4 then --employee
			v_target_user_id:=v_assigned_employee_id;
			v_comment_text:='Süreç tamamlandı.';

		else --iptal edilen
			v_target_user_id:=v_manager_user_id;
			v_comment_text:='Talep kriterlere uymadığı için iptal edilmiştir.';
		end if;
		
	
 		insert into request_comment(request_id,user_id,r_comment)
		values
		(v_request_id, v_target_user_id, v_comment_text);
		
		
	end loop;
	
	return;
end;
$$;

select generate_random_comments(30)

--NOTIFICATIONS











