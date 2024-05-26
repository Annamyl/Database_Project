create view if not exists exp_value as
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

select group_concat(a.episode_id order by a.episode_id asc) as episodes, (a.sum_exp_chef+ b.sum_exp_judge) as total_experience
from (
    select e.episode_id, sum(e_v.exp_int) as sum_exp_chef
    from exp_value e_v inner join episode_entry e_e using (user_id) inner join episode e using (episode_id) 
    group by e.episode_id
) a inner join (
    select e.episode_id, sum(e_v.exp_int) as sum_exp_judge
    from exp_value e_v inner join judges using (user_id) inner join episode e using (episode_id)
    group by e.episode_id
) b on a.episode_id = b.episode_id
group by total_experience
order by total_experience LIMIT 1;
