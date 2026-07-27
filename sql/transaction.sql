BEGIN;

INSERT INTO attachments
(
    request_id,
    file_name,
    file_path
)
VALUES
(
    1,
    'transaction_test.jpg',
    '/uploads/test.jpg'
)
commit;

----
BEGIN;
INSERT INTO attachments
(
    request_id,
    file_name,
    file_path
)
VALUES
(
    1,
    'rollback_test.jpg',
    '/uploads/rollback.jpg'
)
rollback;

select * from attachments
where file_name='rollback_test.jpg'
----
--vatandaş talepte bulunmu ve ona bildirim gönderilmiiş olsun
--ama bildirim kısmında bir hata olursa 
--talep insert edilsin sadece bildirim gitmesin

begin;
insert into requests(user_id,category_id,title,description,request_status_id,priority_id)
values(1,1,'Kırık Bank Bildirimi','Parktaki bank kırılmış tamir gerekli.',1,1)
returning request_id;

savepoint sp_request_created;

insert into notifications(user_id,title,messages)
values(null,'Hatalı bildirim','Test mesajı');

rollback to savepoint sp_request_created;
commit;

--LOCK(for update,for share)
begin;
select request_id,title,request_status_id
from requests
where request_id=153
for update;

commit; --bunu çalıştırınca kadar başka biri üzerinde işlem yapamaz okuyamaz 153'ün

begin;
select department_id,department_name,manager_user_id
from departments
where department_id=1
for share;

commit; --commit yapmasamda başka biri department_id=1 i okuyabilir
--ama üzerinde işlem yapamaz

--DEADLOCK
begin;
update requests
set priority_id=2
where request_id=10

update requests 
set priority_id=3
where request_id=4
commit;









