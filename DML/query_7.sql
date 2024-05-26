select c.user_id, c.first_name, c.last_name, count(*) as ep_appearances
from chefs c inner join episode_entry e using (user_id) 
group by user_id
having ep_appearances < 
(
    select count(*) 
    from episode_entry 
    group by user_id
    order by count(*) desc
    LIMIT 1
) - 5
order by ep_appearances desc;