/*cuisines with minimum 3 appearances per year*/
create or replace view cuisine_per_year as
select c.cuisine_id, c.cuisine_name, e.ep_year, count(*) as count_cuis
from cuisine c 
inner join episode_entry using (cuisine_id)
inner join episode e using (episode_id)
group by e.ep_year, c.cuisine_id
having count_cuis >= 3;

select group_concat(c1.cuisine_id) as cuis_id, group_concat(c1.cuisine_name) as cuisines, concat(c1.ep_year, '-' , c2.ep_year) as years, (c1.count_cuis+c2.count_cuis) as Sum
from cuisine_per_year c1
inner join cuisine_per_year c2 
on (c2.ep_year = c1.ep_year + 1 and c1.cuisine_id = c2.cuisine_id)
group by years, Sum
order by Sum;
