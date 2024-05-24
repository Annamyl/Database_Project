select group_concat(DISTINCT concat(c.first_name, ' ', c.last_name)) as chef_in_ep, c_c.cuisine_id, e.ep_year, count(DISTINCT c.user_id) as count_chefs
from chefs c
inner join chef_cuisine c_c using(user_id)
inner join episode_entry e_e on (c_c.cuisine_id = e_e.cuisine_id and c_c.user_id = e_e.user_id)
inner join episode e using (episode_id)
group by e.ep_year, e_e.cuisine_id;

select group_concat(DISTINCT c.user_id) as full_name, count(DISTINCT c.user_id), c_c.cuisine_id
from chefs c inner join chef_cuisine c_c using (user_id)
group by c_c.cuisine_id;
