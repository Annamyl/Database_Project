explain select e.episode_id, count(*) as eq_per_ep
from equipment eq
join recipe_equipment r_e on (r_e.equipment_id = eq.equipment_id)
join episode_entry e on (e.recipe_id = r_e.recipe_id)
group by e.episode_id
order by eq_per_ep desc LIMIT 1;



