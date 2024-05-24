create or replace index idx_rec on episode_entry (recipe_id);

explain select e.episode_id, count(*) as eq_per_ep
from recipe_equipment r_e 
join episode_entry e force index (idx_rec) on (e.recipe_id = r_e.recipe_id)
join equipment eq on (eq.equipment_id = r_e.equipment_id)
group by e.episode_id
order by eq_per_ep desc LIMIT 1;




