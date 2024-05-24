select c.user_id, c.first_name, c.last_name, e.ep_year, count(*) as ep_count
from chefs c inner join judges j using (user_id) inner join episode e using (episode_id)
group by user_id, ep_year
having count(*) > 3
order by count(*) desc, ep_year;

