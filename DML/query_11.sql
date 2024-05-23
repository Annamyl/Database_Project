select j.user_id as judge, concat(c.first_name, ' ', c.last_name) as judge_fullname, e_e.user_id as chef, concat(e_e.first_name, ' ', e_e.last_name) as chef_fullname, sum(s.s_value) as sum_score
from chefs c 
inner join judges j using (user_id)
inner join episode e using (episode_id)
inner join (
    select *
    from chefs
    inner join episode_entry using (user_id)
) e_e using (episode_id)
inner join score s using (entry_id)
group by j.user_id, e_e.user_id
order by sum_score desc LIMIT 5;