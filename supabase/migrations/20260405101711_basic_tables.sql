CREATE OR REPLACE FUNCTION update_updated_at()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

create table laundries (
    id serial primary key ,
    name text,
    address text,
    created_at timestamp default current_timestamp,
    updated_at timestamp
);

CREATE TRIGGER update_laundries_updated_at
    BEFORE UPDATE ON laundries
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

create table clients (
    id serial primary key ,
    name text,
    phone_number int,
    created_at timestamp default current_timestamp,
    updated_at timestamp
);

CREATE TRIGGER update_clients_updated_at
    BEFORE UPDATE ON clients
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

create table orders (
    id serial primary key,
    order_number text,
    client_id int references clients(id),
    laundry_id int references laundries(id),
    created_at timestamp default current_timestamp,
    updated_at timestamp
);

CREATE TRIGGER update_orders_updated_at
    BEFORE UPDATE ON orders
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

create table items (
    id serial primary key,
    laundry_id int references laundries(id),
    name text,
    created_at timestamp default current_timestamp,
    updated_at timestamp
);

CREATE TRIGGER update_items_updated_at
    BEFORE UPDATE ON items
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

create table order_items (
    id serial primary key ,
    order_id int references orders(id),
    item_id int references items(id),
    quantity int,
    description text,
    created_at timestamp default current_timestamp,
    updated_at timestamp
);

CREATE TRIGGER update_order_items_updated_at
    BEFORE UPDATE ON order_items
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at();