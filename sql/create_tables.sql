create table roles
(
	role_id int generated always as identity,
	role_name varchar(20) not null unique,
	constraint pk_role_id primary key(role_id) 
);

create table departments
(
	department_id int generated always as identity,
	department_name varchar(100) not null unique,
	manager_user_id int, --geçici kısıtlamasız oluşturduk
	constraint pk_departments primary key(department_id) 
);

create table users
(
	user_id int generated always as identity,
	first_name varchar(30) not null,
	last_name varchar(30) not null,
	email varchar(40) not null unique,
	password_hash varchar(255) not null,
	phone varchar(15),
	role_id int not null,
	department_id int, --vatandaşın department_idsi olmaz
	created_at timestamptz not null default now(),
	is_active boolean not null default true, --kullanıcı aktif mi
	constraint pk_user_id primary key(user_id),
	constraint fk_users_departments foreign key(department_id) references departments(department_id) on delete set null,
	constraint fk_users_roles foreign key(role_id) references roles(role_id) on delete restrict
);

--şimdi departments tablomuzdaki manage_user_id'ye fk ekleyebiliriz
alter table departments
add constraint fk_departments_users foreign key(manager_user_id) references users(user_id) on delete set null;


create table categories
(
	category_id int generated always as identity,
	category_name varchar(50) not null unique,
	department_id int,
	constraint pk_category_id primary key(category_id),
	constraint fk_categories_department foreign key(department_id) references departments(department_id) on delete set null
);

create table notifications
(
	notification_id int generated always as identity,
	user_id int not null,
	title varchar(100) not null,
	messages text not null,
	is_read boolean not null default false,--yeni bildirim okunmamış başlar
	constraint pk_notification_id primary key(notification_id),
	constraint fk_notification_user_id foreign key(user_id) references users(user_id) on delete cascade
);

create table priorities
(
	priority_id int,
	priority_name varchar(30),
	constraint pk_priority_id primary key(priority_id)
	--1low,2medium,3high,4critical
);

create table audit_logs
(
	audit_id int generated always as identity,
	user_id int,
	action_name varchar(50) not null,--insert,update,delete
	record_id int not null,
	table_name varchar(25),
	old_value text,
	new_value text,
	created_at timestamptz not null default now(),
	constraint pk_audit_id primary key(audit_id),
	constraint fk_audit_logs_user_id foreign key(user_id) references users(user_id) on delete set null
);

create table request_status
(
	request_status_id int generated always as identity,
	status_name varchar(50) not null unique,
	constraint pk_request_id primary key(request_status_id)
	--1open,2assigned,3inprogrees,4completed,5cancelled
);

create table requests
(
	request_id int generated always as identity,
	user_id int not null,
	category_id int not null,
	request_status_id int not null default 1,--1=open
	title varchar(100) not null,
	description text not null,
	assigned_employee_id int,--Başlangıçta NULL'dır. Yönetici atama yaptığında doldurulur.
	priority_id int not null default 1,--1=low
	created_at timestamptz default now(),
	updated_at timestamptz default now(),
	closed_at timestamptz,
	constraint pk_request_request_id primary key(request_id),
	constraint fk_request_user_id foreign key(user_id) references users(user_id),
	constraint fk_request_category foreign key(category_id) references categories(category_id)on delete restrict,
	constraint fk_request_request_status_id foreign key(request_status_id) references request_status(request_status_id)on delete restrict,
	constraint fk_request_priority foreign key(priority_id) references priorities(priority_id)on delete restrict,
	constraint fk_request_assigned_employee_id foreign key(assigned_employee_id) references users(user_id) on delete set null
);

create table request_history
(
	history_id int generated always as identity,
	request_id int not null,
	old_status_id int,
	new_status_id int not null,
	changed_by_user_id int not null,
	changed_at timestamptz default now(),
	constraint pk_history_id primary key(history_id),
	constraint fk_request_history_id foreign key(request_id) references requests(request_id),
	constraint fk_request_old_status_id foreign key(old_status_id) references request_status(request_status_id) on delete set null,
	constraint fk_request_new_status_id foreign key(new_status_id) references request_status(request_status_id) on delete restrict,
	constraint fk_changed_by_user_id foreign key(changed_by_user_id) references users(user_id) on delete restrict
);

create table request_comment
(
	comment_id int generated always as identity,
	request_id int not null,
	user_id int not null,
	r_comment text not null,
	created_at timestamptz not null default now(),
	constraint pk_comment_id primary key(comment_id),
	constraint fk_comment_request_id foreign key(request_id) references requests(request_id) on delete cascade,
	constraint fk_comment_user_id foreign key(user_id) references users(user_id) on delete restrict
);

create table attachments
(
	attachment_id int generated always as identity,
	request_id int,
	file_name varchar(100),
	file_path text,
	uploaded_at timestamptz default now(),
	constraint pk_attachment_id primary key(attachment_id),
	constraint fk_attachment_request_id foreign key(request_id) references requests(request_id) on delete cascade
);

create table employee_assignment--talep kim tarafından kime ne zaman atanmış
(
	assignment_id int generated always as identity,
	request_id int not null,
	employee_user_id int not null, --atanan personel
	assigned_by_user_id int not null,  --atamayı yapan personel
	assigned_at timestamptz not null default now(),
	ended_at timestamptz,
	constraint pk_assignment_id primary key(assignment_id),
	constraint fk_assignment_request_id foreign key(request_id) references requests(request_id) on delete cascade,
	constraint fk_employee_user_id foreign key(employee_user_id) references users(user_id) on delete restrict,
	constraint fk_assignedn_user_id foreign key(assigned_by_user_id) references users(user_id) on delete restrict
);

create table request_templates--gerçek talep şablonları
(
	templaye_id int generated always as identity primary key,
	category_id int not null,
	title varchar(150) not null,
	description text not null,
	constraint fk_template_categort foreign key(category_id) references categories(category_id)
)













