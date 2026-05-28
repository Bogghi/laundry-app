CREATE TYPE client_status AS ENUM ('active', 'deleted');
CREATE TYPE order_status AS ENUM ('doing', 'completed', 'deleted');

ALTER TABLE items ADD COLUMN deleted boolean default false;
ALTER TABLE clients ADD COLUMN status client_status default 'active';
ALTER TABLE orders ADD COLUMN status order_status default 'doing';