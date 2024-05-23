drop procedure if exists new_episode;
delimiter $$
create procedure new_episode ()
begin
    
    declare ep_id int;
    declare id int;
    declare rec int;
    declare c int;
    declare v int;
    declare ep_y int;

    set v = (select count(*) from episode group by ep_year order by ep_year desc LIMIT 1);
    set ep_y = (select max(ep_year) from episode);
    if (v >= 10) then 
        set ep_y = ep_y + 1;
    end if;

    insert into episode (ep_year, episode_image, image_description) values (ep_y, "fsafaf", "fsgahash");
    set ep_id = (select count(*) from episode);

    create temporary table if not exists ep_cuisine 
    (select * 
    from cuisine
    order by rand() LIMIT 10);

    while exists (select * from ep_cuisine) do
        
        set id = (select cuisine_id from ep_cuisine LIMIT 1);
                
        select recipe_id into rec
        from recipe r
        where r.cuisine_id = id
        order by rand() LIMIT 1;
        
        /* 1) chef not in previous entries for the same episode
           2) chef has not appeared in 3 consecutive episodes*/
        
        select t.user_id into c
        from chef_cuisine t
        inner join (
            select a1.* 
            from chef_cuisine a1
            left join (
                select d.* 
                from episode_entry d
                where d.episode_id = ep_id
            ) b
            on a1.user_id = b.user_id
            where (b.user_id is null and a1.cuisine_id = id)
        ) a 
        on (a.user_id = t.user_id)
        /*inner join (
        select a2.*
            from chef_cuisine a2
            left join (
                select e1.* 
                from episode_entry e1
                inner join (
                    select e2.* 
                    from episode_entry e2
                    where e2.episode_id = ep_id - 2
                ) e4
                on e1.user_id = e4.user_id
                where e1.episode_id = ep_id - 1
                except
                select e2.* 
                from episode_entry e2
                inner join (
                    select e3.*
                    from episode_entry e3
                    where e3.episode_id = ep_id - 3
                ) e5
                on e2.user_id = e5.user_id
                where e2.episode_id = ep_id - 2
            ) b2
            on (a2.user_id = b2.user_id)
        where (b2.user_id is null and a2.cuisine_id = id)
        ) b
        on (b.user_id = t.user_id)*/
        where (t.cuisine_id = id)
        having t.user_id not in (
            select e1.user_id 
            from episode_entry e1
            inner join (
                select e2.user_id 
                from episode_entry e2
                where e2.episode_id = ep_id - 2
            ) e4
            on e1.user_id = e4.user_id
            inner join (
                select e3.user_id
                from episode_entry e3
                where e3.episode_id = ep_id - 3
            ) e5
            on e4.user_id = e5.user_id
            where (e1.episode_id = ep_id - 1)
        )
        order by rand() LIMIT 1;
        
        insert into episode_entry(episode_id, recipe_id, cuisine_id, user_id) values (ep_id, rec, id, c);
        delete from ep_cuisine where cuisine_id = id;

    end while;

    drop temporary table ep_cuisine; 

    insert into judges (episode_id, user_id)
    select ep_id, a.user_id
    from users a
    left join (
        select d.user_id
        from episode_entry d
        where (d.episode_id = ep_id)
    ) b
    on (a.user_id = b.user_id)
    where (b.user_id is null)
    order by rand() LIMIT 3;

end $$
delimiter ;