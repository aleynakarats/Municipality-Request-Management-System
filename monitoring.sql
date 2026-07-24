select
	pid, --her bağlantının benzersiz işlem numarası
	usename, --bağlanan kullanıcı
	datname, --hangi veritabanına bağlı
	state, --akfit mi
	backend_start, --ne zaman bağlanmış
	query --en son çalıştırdığı sorgu
from pg_stat_activity
where datname is not null;

--kitlenen işlem
select
 pid,
 usename,
 state,
 wait_event_type,
 wait_event,
 query
from pg_stat_activity;

--kim kimi kitlemiş
select
	pid,
	pg_blocking_pids(pid) as blocking_pid,
	query
from pg_stat_activity
where cardinality(pg_blocking_pids(pid))>0;

--
select
	datname,
	numbackends, --şuanda kaç aktif bağlantı var
	xact_commit, --başarıyla tamamlanan transaction sayısı
	xact_rollback, --başarısız transaction sayısı(rollback ile geri alınmış)
	blks_read, --postgresql diskten kaç blok okumuş.
	blks_hit --disk yerine kaçkez ramden okumuş
from pg_stat_database;

--cache hit ratio
select 
	datname,
	blks_hit::numeric / 
	(blks_hit+blks_read) * 100
	as cache_hit_ratio
from pg_stat_database
where datname='MUNICIPAL_DEMAND_MANAGEMENT'

--postgresql tabloları nasıl kullanıyor
select
	relname,
	seq_scan,
	seq_tup_read, --seq scan yapılırken toplam kaç satır okunmuş
	idx_scan, --tablo  üzerinde kaç kez index scan yapılmış
	idx_tup_fetch --index yapılırken kaç satır getirilmiş
from pg_stat_user_tables
order by seq_scan desc;

--hangi index kaç defa kullanıldı
select
	relname as table_name,
	indexrelname as index_name,
	idx_scan, --bu index kaç kez kullanıldı
	idx_tup_read, --postgresql önce indexe baktığında kaç kayıt buldu
	idx_tup_fetch --kaç satır tabloya gidip alınmış
from pg_stat_user_indexes
order by idx_scan desc;
	
--veritabanındaki tüm indexler
select
	schemaname,
	tablename,
	indexname,
	indexdef --index nasıl oluşturuldu
from pg_indexes
where schemaname='public'
order by tablename;

--tablo boyutları
select
	relname,
	pg_size_pretty(pg_relation_size(relid)) as table_size
from pg_catalog.pg_statio_user_tables
order by pg_relation_size(relid) desc

--toplam tablo boyutu-->gerçek disk boyutu(tablo+indexler+toast)
select
	relname,
	pg_size_pretty(pg_total_relation_size(relid)) as total_size
from pg_catalog.pg_statio_user_tables
order by pg_total_relation_size(relid) desc


	








