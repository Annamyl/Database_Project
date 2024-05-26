select e.ep_year, avg(r.carbs_per_portion*r.portions) as average_carbs
from recipe r 
inner join episode_entry e_e using (recipe_id) 
inner join episode e using(episode_id)
group by e.ep_year;