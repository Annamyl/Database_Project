select t.theme_id, t.theme_name, count(*) as count_appearances
from themes t 
inner join recipe_themes using (theme_id) 
inner join recipe using(recipe_id) 
inner join episode_entry using (recipe_id)
group by t.theme_id
order by count(*) desc LIMIT 1;