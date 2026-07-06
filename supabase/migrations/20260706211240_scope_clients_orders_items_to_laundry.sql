alter table clients add column laundry_id int references laundries(id);
update clients set laundry_id = 1;
alter table clients alter column laundry_id set not null;

update orders set laundry_id = 1 where laundry_id is null;
alter table orders alter column laundry_id set not null;

update items set laundry_id = 1 where laundry_id is null;

create index if not exists idx_clients_laundry_id on clients(laundry_id);
create index if not exists idx_orders_laundry_id on orders(laundry_id);
create index if not exists idx_items_laundry_id on items(laundry_id);
