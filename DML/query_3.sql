select a.user_id, concat(a.first_name, ' ', a.last_name) as full_name, floor(datediff(now(), a.date_of_birth)/365) as age,
(
    select count(*)
    from chef_cuisine 
    inner join cuisine using (cuisine_id) 
    inner join recipe using (cuisine_id)
    where (user_id = a.user_id)
    group by (user_id)

) as recipes_count
from chefs a
where (datediff(now(), a.date_of_birth))/365 < 30
order by recipes_count desc;

