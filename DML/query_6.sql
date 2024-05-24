select group_concat(DISTINCT r1.recipe_id order by r1.recipe_id) as recipes, r1.tag_id, r2.tag_id, count(DISTINCT r1.recipe_id) as recipes_count
from recipe_tag r1 inner join recipe_tag r2 using(recipe_id) inner join episode_entry using(recipe_id) 
where r1.tag_id < r2.tag_id
group by r1.tag_id, r2.tag_id
order by recipes_count desc LIMIT 3
;