select *
from chefs c
where not exists (
    select 1
    from judges j
    where j.user_id = c.user_id
);