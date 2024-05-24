/* count total calories for recipe */

-- create or replace view count_quantity as


-- create or replace view count_cal as
-- select sum(i.calories * r_i.quantity)
-- from ingredients i inner join recipe_ingredients r_i using(ingredient_id)
-- group by r_i.recipe_id;

-- experience of chef in integer
create or replace view exp_value as
select c.*,
(
    case
    when c.profession_info = 'Executive Chef' then 5
    when c.profession_info = 'Senior Chef' then 4
    when c.profession_info = 'Sous Chef' then 3
    when c.profession_info = 'Line Cook' then 2
    else 1 end
) as exp_int
from chefs c;

-- total score for chef in episode
create or replace view chef_total_score as
select e.episode_id, e.user_id, sum(s.s_value) as chef_score
from episode_entry e inner join score s using (entry_id)
group by e.entry_id
order by e.episode_id, chef_score desc;


-- episode winners with multiple winners if equal profession
create or replace view ep_winners as
select c1.*, ex.exp_int
from exp_value ex inner join chef_total_score c1 using (user_id)
where (c1.chef_score = 
    (select max(c2.chef_score) as max_score
    from chef_total_score c2
    group by c2.episode_id
    having c1.episode_id = c2.episode_id)
    )
-- random order because when exp_int equal we want to select winner at random
order by rand();

-- select only one winner per episode
create or replace view final_winners as
select e.episode_id, concat(c.first_name,' ',c.last_name) as full_name, c.profession_info, e.chef_score
from ep_winners e inner join chefs c using (user_id)
where e.exp_int = (
    select max(e2.exp_int) as max_exp
    from ep_winners e2
    group by e2.episode_id 
    having e.episode_id = e2.episode_id)
group by episode_id
order by e.episode_id;
