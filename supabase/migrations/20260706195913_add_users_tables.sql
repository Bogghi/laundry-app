create table users (
    id serial primary key,
    username text not null unique,
    password text not null,
    type text not null check (type in ('owner', 'employ')),
    created_at timestamp default current_timestamp,
    updated_at timestamp
);

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

create table user_laundries (
    id serial primary key,
    user_id int references users(id),
    laundry_id int references laundries(id),
    created_at timestamp default current_timestamp,
    updated_at timestamp,
    unique (user_id, laundry_id)
);

CREATE TRIGGER update_user_laundries_updated_at
    BEFORE UPDATE ON user_laundries
    FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
