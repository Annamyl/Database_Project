create or replace index idx_rec on episode_entry (recipe_id);

select group_concat(DISTINCT r1.recipe_id order by r1.recipe_id) as recipes, 
    concat(r1.tag_id,' - ', r3.tag_id) as pair_tag_id, 
    concat((select tag from tags force index (primary) where tag_id = r1.tag_id),' - ', (select tag from tags force index (primary) where tag_id = r3.tag_id)) as pair_tags, 
    count(DISTINCT r1.recipe_id) as recipes_count
from  recipe_tag r1 
straight_join recipe_tag r3 force index (primary) using (recipe_id) 
straight_join episode_entry e force index (idx_rec) on (e.recipe_id = r1.recipe_id) 
where r1.tag_id < r3.tag_id
group by r1.tag_id, r3.tag_id
order by recipes_count desc LIMIT 3;
