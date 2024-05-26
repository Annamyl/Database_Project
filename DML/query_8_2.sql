create or replace index idx_rec on episode_entry (recipe_id);
create or replace index idx_ep on episode_entry (episode_id);

select e.episode_id, count(*) as eq_per_ep
from recipe_equipment r_e
straight_join equipment eq force index (PRIMARY) using (equipment_id) 
straight_join episode_entry e force index (idx_rec) force index for group by(idx_ep) on (e.recipe_id = r_e.recipe_id)
group by e.episode_id
order by eq_per_ep desc LIMIT 1;



