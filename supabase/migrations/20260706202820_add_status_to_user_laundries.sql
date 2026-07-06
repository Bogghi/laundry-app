alter table user_laundries
    add column status text not null default 'pending'
        check (status in ('pending', 'approved', 'rejected'));
