select e.ep_year, avg(r.carbs_per_portion*r.portions) as average_carbs
from recipe r join episode_entry e_e using (recipe_id) join episode e using(episode_id)
group by e.ep_year;