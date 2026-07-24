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

EXPLAIN ANALYZE
SELECT * FROM requests
WHERE category_id = 5 
  AND request_status_id = 1;
--Bitmap Heap Scan on requests  (cost=86.34..4685.77 rows=4492 width=190) (actual time=3.173..6.198 rows=4440 loops=1)
--Bitmap Index Scan on idx_category_status  (cost=0.00..85.21 rows=4492 width=0) (actual time=2.899..2.899 rows=4440 loops=1)
--partial index kullanınca maaliyeti düşer
--Bitmap Heap Scan on requests  (cost=55.10..4654.53 rows=4492 width=190) (actual time=0.686..3.685 rows=4440 loops=1)
--Bitmap Index Scan on idx_partial_open_requests  (cost=0.00..53.98 rows=4492 width=0) (actual time=0.343..0.343 rows=4440 loops=1)




