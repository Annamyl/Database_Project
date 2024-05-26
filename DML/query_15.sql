select f.group_id, f.group_name
from food_groups f 
where not exists (
    select 1
    from food_groups f1 
    inner join ingredients using(group_id) 
    inner join recipe_ingredients using(ingredient_id) 
    inner join recipe using(recipe_id) 
    inner join episode_entry using(recipe_id)
    where f1.group_id = f.group_id
);
