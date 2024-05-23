/*average_score per chef*/
select c.user_id, c.first_name, c.last_name, avg(s.s_value) as average_score
from chefs c inner join episode_entry e using (user_id) inner join score s using (entry_id)
group by user_id;

/*average_score per cuisine*/
select c.cuisine_id, c.cuisine_name, avg(s.s_value) as average_score
from cuisine c inner join episode_entry e using (cuisine_id) inner join score s using (entry_id)
group by cuisine_name;