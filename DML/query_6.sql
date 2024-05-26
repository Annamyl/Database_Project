select group_concat(DISTINCT r1.recipe_id order by r1.recipe_id) as recipes, 
    concat(r1.tag_id,' - ', r3.tag_id) as pair_tag_id, 
    concat((select tag from tags where tag_id = r1.tag_id),' - ', (select tag from tags where tag_id = r3.tag_id)) as pair_tags, 
    count(DISTINCT r1.recipe_id) as recipes_count
from  recipe_tag r1 
inner join recipe_tag r3 using (recipe_id) 
inner join episode_entry e using (recipe_id) 
where r1.tag_id < r3.tag_id
group by r1.tag_id, r3.tag_id
order by recipes_count desc LIMIT 3;