--GEÇİŞ KONTOLÜ 
create or replace function fn_trg_request_validation()
returns trigger
language plpgsql
as $$
begin
	if old.request_status_id is not distinct from new.request_id then
		return new;
	end if;

	if old.request_status_id in (4,5) then
		raise exception 'HATA: Tamamlanmış veya reddedilmiş bir talebin durumu değiştirilemez! (Talep ID: %)',old.request_id;
	end if;

	if new.request_status_id<old.request_status_id and new.request_status_id != 5 then
		raise exception 'HATA: Talebin durumu geriye dönük değiştirilemez! Eski: %, Yeni:%', old.request_status_id,new.request_status_id;
	end if;

	return new;
end;
$$;

create or replace trigger trg_request_before_update_status_check
before update
on requests
for each row
execute function fn_trg_request_validation()


--OTOMATİK request_history
create or replace function fn_trigger_request_auto_history_insert()
returns trigger
language plpgsql
security definer --bu fonksiyonu çağıran kullanıcının değil, fonksiyon sahibinin yetkileriyle çalış
as $$
begin
	if tg_op='INSERT' then
		insert into request_history
		(request_id,old_status_id,new_status_id,changed_by_user_id,changed_at)
		values
		(
			new.request_id,
			null,
			new.request_status_id,
			new.user_id,
			now()
		);

	elsif tg_op='UPDATE' then
		if (old.request_status_id is distinct from new.request_status_id) then
			insert into request_history
			(request_id,old_status_id,new_status_id,changed_by_user_id,changed_at)
			values
			(
				new.request_id,
				old.request_status_id,
				new.request_status_id,
				coalesce(new.assigned_employee_id,new.user_id),
				now()
			);
		end if;
	end if;
	return new;
end;
$$;

create or replace trigger trg_request_after_insert
after insert or update
on requests
for each row
execute function fn_trigger_request_auto_history_insert();

--test
insert into requests (user_id, category_id, title, description, request_status_id, priority_id)
values (1, 1, 'Trigger Test Talebi', 'Bakalım otomatik history oluşacak mı?', 1, 1)
returning request_id;

-- Oluşan son talebin history kaydına bakalım:
SELECT * FROM request_history WHERE request_id =151;


--ALL NOTIFICATIONS TRIGGER
create or replace function fn_trg_request_notification()
returns trigger
language plpgsql
security definer
as $$
declare
	v_manager_user_id int;
begin

 if tg_op='INSERT' then

	select d.manager_user_id
	into v_manager_user_id
	from categories c
	join departments d on d.department_id=c.department_id
		where c.category_id=new.category_id;

	if new.request_status_id=1
	and v_manager_user_id is not null then
		
	insert into notifications(user_id,title,messages)
	values
	(
		v_manager_user_id, --yönetici kişi
	    'Yeni talep alındı',
		'Yönetici olduğunuz departmana ' || new.request_id || ' numaralı yeni bir talep atandı.'		
	);
  end if;

 elsif tg_op='UPDATE' then

    if (old.request_status_id is distinct from new.request_status_id)
  		and new.request_status_id=2
		and new.assigned_employee_id is not null then		
	insert into notifications(user_id,title,messages)
	values
	(
		new.assigned_employee_id, --atanan kişi
	    'Yeni görev atandı',
		'Sistemdeki ' || new.request_id || ' numaralı yeni bir talep size atandı'		
	);
  end if;

  if (old.request_status_id is distinct from new.request_status_id)
  and new.request_status_id=3 then
	insert into	notifications(user_id,title,messages)
	values
	(
		new.user_id, --vatandaş
		'Talebiniz işleme alındı.',
		'Bildirdiğiniz' || new.request_id || ' numaralı talep ilgili birimlerce işleme alındı'
	);
  end if;

  if (old.request_status_id is distinct from new.request_status_id)
  		and new.request_status_id=4 then
	insert into	notifications(user_id,title,messages)
	values
	(
		new.user_id,
		'Talebiniz tamamlandı.',
		'Bildirdiğiniz' || new.request_id || ' numaralı talep ilgili birimlerce tamamlanmıştır.'
	);
   end if;

   if (old.request_status_id is distinct from new.request_status_id)
  		and new.request_status_id=5 then
	insert into	notifications(user_id,title,messages)
	values
	(
		new.user_id,
		'Talebiniz reddedildi.',
		'Bildirdiğiniz' || new.request_id || ' numaralı talep ilgili birimlerce reddedilmiştir.'
	);
   end if;

   end if;
  
   return new;
end;
$$;

create or replace trigger trg_request_notification
after insert or update 
on requests
for each row
execute function fn_trg_request_notification();


select * from requests

insert into requests(user_id,category_id,title,description,request_status_id,priority_id)
values
(2,2,'Engelli rampası hasarlı','Engelli rampasının yüzeyi kırılmış durumda. Tekerlekli sandalye kullanan vatandaşların geçişini zorlaştırıyor.',1,2)
returning request_id; --153

select * from request_history where request_id=153
select * from notifications order by 1 desc

update requests
set request_status_id=2,
	assigned_employee_id=12
where request_id=22

select * from requests

--AUDIT_LOGS
create or replace function log_request_changes()
returns trigger
security definer
as $$
begin
	if tg_op='INSERT' then
		insert into audit_logs
		(
			user_id,
			action_name,
			record_id,
			table_name,
			old_value,
			new_value
		)
		values
		(
			new.user_id,
			'insert',
			new.request_id,
			tg_table_name,
			null,
			to_jsonb(new)::text
		);
		return new;

	elsif tg_op='UPDATE' then
		insert into audit_logs
		(
			user_id,
			action_name,
			record_id,
			table_name,
			old_value,
			new_value
		)
		values
		(
			new.user_id,
			'update',
			new.request_id,
			tg_table_name,
			to_jsonb(old)::text,
			to_jsonb(new)::text
		);
		return new;
		
	elsif tg_op='DELETE' then
		insert into audit_logs
		(
			user_id,
			action_name,
			record_id,
			table_name,
			old_value,
			new_value
		)
		values
		(
			old.user_id,
			'delete',
			old.request_id,
			tg_table_name,
			to_jsonb(old)::text,
			null	
		);
		return old;
		
	end if;
	
	return new;	
end;
$$
language plpgsql;

create or replace trigger trg_requests_audit
after insert or update or delete
on requests
for each row
execute function log_request_changes();

update requests
set title = 'Audit Trigger Test1'
where request_id=4;

select * from audit_logs
order by audit_id desc


