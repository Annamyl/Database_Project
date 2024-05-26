drop procedure if exists add_score;
delimiter $$
create procedure add_score (ep int, jd varchar(100), ch varchar(100), s int)
begin
    declare e_id int;
    declare jd_id int; 
     
    set e_id = (
        select e_e.entry_id
        from episode_entry e_e
        where (e_e.episode_id = ep and
            e_e.user_id = (
            select c.user_id
            from chefs c
            where concat(c.first_name, ' ', c.last_name) = ch
        ))
    );

    set jd_id = (
        select c.user_id
        from chefs c
        where concat(c.first_name, ' ', c.last_name) = jd
    );

    insert into score (entry_id, judge_id, s_value) values (e_id, jd_id, s);

end $$
delimiter ;

-- check to make sure that judge is indeed in the episode given
delimiter $$
create trigger chk_jd_in_ep before insert on score 
for each row
begin
    if not exists (select 1 from judges j where j.user_id = new.judge_id and 
                    j.episode_id = (select e.episode_id from episode e inner join episode_entry e_e on (e.episode_id = e_e.episode_id and e_e.entry_id = new.entry_id))) then
        signal sqlstate '45000'
		set message_text = 'Judge is not on episode';
    end if;
end $$
delimiter ;