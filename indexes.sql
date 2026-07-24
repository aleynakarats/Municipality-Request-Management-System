create index idx_requests_status
on requests(request_status_id);

create index idx_category_status
on requests(category_id,request_status_id);

create index idx_employee_status
on requests(assigned_employee_id,request_status_id);

create index idx_partial_open_requests
on requests(category_id)
where request_status_id=1