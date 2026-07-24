EXPLAIN
SELECT *
FROM requests
WHERE request_status_id = 3;
--Bitmap Heap Scan on requests  (cost=259.28..4819.19 rows=15353 width=190)
--yaklaşık 15000 satır döndürüyor.
--bitmap heap scan bu büyüklükteki sonuç kümesi için daha verimli
--composite index(idx_category_status) kullanılıyor

explain
select * from requests
where category_id=5
	and request_status_id=1;
--Bitmap Heap Scan on requests  (cost=86.34..4685.77 rows=4492 width=190)

explain 
select * from requests
where assigned_employee_id=3
	and request_status_id=3;
--Bitmap Heap Scan on requests  (cost=22.85..2455.50 rows=1030 width=190)
--bu sorguda composite index(idx_employee_status) kullanılıyor
--yaklaşık 1000 kayıt döndüğü için index scan yerine bitmap heap scan tercih