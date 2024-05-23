create or replace view sum_diff as 
select e.episode_id, e.ep_year, sum(r.difficulty) as diff
from recipe r join episode_entry e_e using(recipe_id) join episode e using(episode_id)
group by e.episode_id;


select group_concat(ceiling(t1.episode_id % 10.001) order by t1.episode_id asc) as episodes, t1.ep_year, t1.diff as max_difficulty
from sum_diff t1 inner join 
(
    select e.ep_year, max(diff) as m_diff
    from sum_diff e
    group by e.ep_year
) t2 on (
    t1.diff = t2.m_diff 
    and t1.ep_year = t2.ep_year
)
group by t1.ep_year;

