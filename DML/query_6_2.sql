create or replace index rec_id on episode_entry (recipe_id);
create or replace index idx_rec on recipe_tag (recipe_id);

explain select group_concat(DISTINCT r1.recipe_id order by r1.recipe_id) as recipes, r1.tag_id, r2.tag_id, count(DISTINCT r1.recipe_id) as recipes_count
from recipe_tag r1 use index (idx_rec) use index 
join recipe_tag r2 use index (idx_rec) on (r2.recipe_id = r1.recipe_id) 
straight_join episode_entry e on (e.recipe_id = r2.recipe_id) 
where r1.tag_id < r2.tag_id
group by r1.tag_id, r2.tag_id
order by recipes_count desc LIMIT 3
;
