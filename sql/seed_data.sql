insert into roles(role_name) values
('Citizen'), --role_id:1
('Employee'), --role_id:2
('Manager'),  --role_id:3
('DBA');      --role_id:4

insert into priorities(priority_id,priority_name) values
(1,'Low'),
(2,'Medium'),
(3,'High'),
(4,'Critical');

insert into request_status(status_name) values
('Open'),        --id:1 vatandaş ilk açtığında
('Assigned'),    --id:2 yönetici personel atadığında
('In Progress'), --id:3 personel işe başladığında 
('Completed'),   --id:4 iş tamamlandığında
('Cancelled');   --id:5 iptal edildiğinde

insert into departments(department_name) values
('Fen İşleri Müdürlüğü'),
('Temizlik İşleri Müdürlüğü'),
('Park ve Bahçeler Müdürlüğü'),
('Zabıta Müdürlüğü'),
('Bilgi işlem Müdürlüğü'),
('Destek Hizmetleri Müdürlüğü');

update departments
set manager_user_id=5
where department_id=1

update departments
set manager_user_id=6
where department_id=2


insert into categories(category_name,department_id) values
('Yol ve Asfalt Bozukluğu',1),
('Kaldırım Çalışması Talebi',1),
('Park Oyuncakları Hasarı',3),
('Ağaç Budama Talebi',3),
('Çöp Konteyneri Talebi',2),
('Gürültü Şikayeti',4),
('Mobil Uygulama Hata Bildirimi',5),
('Kamu Binası/Tesis Bakım Talebi',6),
('Etkinlik/Organizasyon Masa-Sandalye Talebi',6);

insert into users(first_name,last_name,email,password_hash,phone,role_id,department_id)
values
('Kaan','Özgür','kaanozgur@gmail.com','12345','5552223311',1,NULL),--vatandaş
('Havva','Öncü','havvaoncu@gmail.com','54123','6668887744',1,NULL),
('Cevdet','Karataş','cevdetkaratas@gmail.com','65432','5554449966',2,1),--employee FENİŞLERİ
('Fatma','Çelik','fatmacelik@gmail.com','9654','4447776622',2,2),--employee temizlik
('Ali','Korkmaz','alikorkmaz@gmail.com','98456','3335556644',3,1),--manager
('Zeynep','Şahin','zeynepsahin@gmail.com','alkey4','9996667748',3,2),--manager
('Aleyna','Karataş','aleynakaratas@gmail.com','ak3457','5315730054',4,5)--dba


-------- -- Additional Managers
insert into users(first_name,last_name,email,password_hash,phone,role_id,department_id)
values
('Zeynep','Kahya','zeynepkahya@gmail.com','124587','5551112233',3,5)
('Emre','Yılmaz','emreyilmaz@gmail.com','123456','5556667788',3,3),
('Murat','Demir','muratdemir@gmail.com','123486','5558889966',3,4),
('Selin','Kaya','selinkaya@gmail.com','12398','5552223311',3,6);


-------- MANAGEMENT(role_id:3)
select * from departments

update departments
set manager_user_id=8
where department_id=3;

update departments
set manager_user_id=9
where department_id=4;

update departments
set manager_user_id=10
where department_id=6;

update departments
set manager_user_id=11
where department_id=5;

----- Additional Employees
insert into users
(first_name,last_name,email,password_hash,phone,role_id,department_id)
values
('Mehmet','Aydın','mehmetaydin@gmail.com','999547','5550002233',2,1),--fen işleri

('Ayşe','Yıldız','ayseyildiz@gmail.com','666999','5552316644',2,2), --temizlik

('Ahmet','Koç','ahmetkoc@gmail.com','356987','5551012322',2,3), --parkbahe+çe
('Elif','Arslan','elifarslan@gmail.com','478569','5554023366',2,3),

('Hasan','Çetin','hasancetin@gmail.com','258749','5558884496',2,4),--zabıta
('Burak','Aksoy','burakaksoy@gmail.com','503160','5553214796',2,4),

('Mert','Şahin','mertsahin@gmail.com','123456','5553214783',2,5),--bilgi işlem
('Deniz','Yılmaz','denizyilmaz@gmail.com','123650','5551114236',2,5),

('Okan','Kurt','okankurt@gmail.com','423658','5551234567',2,6), --destek hizmet m.
('Esra','Polat','esrapolat@gmail.com','123987','5557481206',2,6);

------REQUEST_TEMPLATES
select * from categories
insert into request_templates(category_id,title,description)
values
(1,'Mahalle yolunda çukur oluştu.','Son yağışlardan sonra mahalle yolunda büyük bir çukur oluştu. Araçlar geçerken zarar görüyor ve özellikle gece saatlerinde sürücüler için ciddi güvenlik riski oluşturuyor.'),
(1,'Asfalt çökmüş durumda.','Cadde üzerinde asfaltın bir kısmı çökmüş durumda. Araçlar geçiş sırasında zorlanıyor ve yol trafiği olumsuz etkileniyor.'),
(2,'Kaldırım taşı yerinden çıktı','Kaldırım taşlarının yerinden çıkması nedeniyle yayaların yürüyüş güvenliği tehlikeye girmiş durumda.'),
(2,'Engelli rampası hasarlı','Engelli rampasının yüzeyi kırılmış durumda. Tekerlekli sandalye kullanan vatandaşların geçişini zorlaştırıyor.'),
(3,'Park oyuncak kırılması','Mahalle parkında çocuk salıncağının zinciri kopmuş ve kaydırak çatlamıştır. Çocukların güvenliği için tehlikeli bir durum oluşturuyor.'),
(3,'Basketbol potası devrilmiş','Park sahasında bulunan basketbol potası yerinden çıkmış durumda. Kullanımı güvenli değildir.'),
(4,'Ağaç budama talebi','Sokağın kenarında bulunan ağacın dalları elektrik kablolarına yaklaşmış durumda. Budama yapılması talep edilmektedir.'),
(4,'Kuru dallar tehlike oluşturuyor','Ağacın kuruyan dalları rüzgarlı havalarda düşme riski oluşturuyor. Vatandaş güvenliği açısından budama yapılmalıdır.'),
(5,'Çöp konteyneri dolu','Mahallede bulunan çöp konteyneri uzun süredir boşaltılmamış. Çevrede kötü koku ve görüntü kirliliği oluşuyor.'),
(5,'Yeni çöp konteyneri talebi','Bölgedeki nüfus arttığı için mevcut konteynerler yetersiz kalıyor. Yeni konteyner yerleştirilmesi talep edilmektedir.'),
(6,'İnşaat gürültüsü','İnşaat çalışmalarının izin verilen saatler dışında devam ettiği gözlemlenmiştir.'),
(6,'Gece yarısı gürültü şikayeti','Sokakta bulunan işletme gece saat 24:00''ten sonra yüksek sesle müzik yayını yapmaktadır.'),
(7,'Uygulamaya giriş yapılamıyor','Mobil uygulamaya kullanıcı bilgilerim doğru olmasına rağmen giriş yapamıyorum.'),
(7,'Bildirimler gelmiyor','Oluşturduğum taleplerle ilgili hiçbir bildirim tarafıma ulaşmıyor.'),
(8,'Klima arızalı','Belediye hizmet binasındaki klimalar çalışmıyor. Özellikle yoğun saatlerde vatandaşlar mağdur oluyor.'),
(8,'Asansör çalışmıyor','Belediye binasında bulunan asansör uzun süredir hizmet vermiyor. Engelli vatandaşlar için sorun oluşturuyor.'),
(9,'Masa talebi','Mahalle etkinliği kapsamında kullanılmak üzere 20 adet masa talep edilmektedir.'),
(9,'Sandalye talebi','Düzenlenecek organizasyon için yaklaşık 100 adet sandalye desteğine ihtiyaç duyulmaktadır.');

--
INSERT INTO attachments
(request_id, uploaded_at, file_name, file_path)
VALUES
(15, NOW(), 'road_damage.jpg', '/uploads/requests/road_damage.jpg'),
(28, NOW(), 'water_leak.png', '/uploads/requests/water_leak.png'),
(91, NOW(), 'garbage_photo.jpg', '/uploads/requests/garbage_photo.jpg'),
(135, NOW(), 'street_light.pdf', '/uploads/requests/street_light.pdf'),
(210, NOW(), 'sidewalk_damage.jpg', '/uploads/requests/sidewalk_damage.jpg'),
(322, NOW(), 'park_issue.png', '/uploads/requests/park_issue.png'),
(487, NOW(), 'tree_fallen.jpg', '/uploads/requests/tree_fallen.jpg'),
(615, NOW(), 'building_crack.pdf', '/uploads/requests/building_crack.pdf'),
(824, NOW(), 'traffic_sign.jpg', '/uploads/requests/traffic_sign.jpg'),
(950, NOW(), 'illegal_dumping.png', '/uploads/requests/illegal_dumping.png');

