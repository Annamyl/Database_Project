-- on call procedure user needs to give url for image and image description

drop procedure if exists new_episode;
delimiter $$
create procedure new_episode (im varchar(45), im_desc varchar(150))
begin
    declare ep_id int;
    declare id int;
    declare rec int;
    declare c int;
    declare v int;
    declare ep_y int;

    /*v -> number of episodes in season*/
    set v = (select count(*) from episode group by ep_year order by ep_year desc LIMIT 1);

    /*ep_y -> year of season 
      if v = 10 then new season ep_y + 1
      else current season ep_y
    */
    set ep_y = (select max(ep_year) from episode);
    if (v >= 10) then 
        set ep_y = ep_y + 1;
    end if;

    insert into episode (ep_year, episode_image, image_description) values (ep_y, im, im_desc);
    set ep_id = (select count(*) from episode);

    /*not more than 3 consecutive appearances in one season*/
    drop temporary table if exists ep_cuisine; 
    create temporary table ep_cuisine 
    (select c.cuisine_id 
    from cuisine c
    where c.cuisine_id not in (
        select e1.cuisine_id
        from episode_entry e1 
        inner join episode_entry e2 using (cuisine_id)
        inner join episode_entry e3 using (cuisine_id)
        where (
            e1.episode_id = ep_id - 1
            and e2.episode_id = ep_id - 2
            and e3.episode_id = ep_id - 3
            and (ep_id %10 >=4 or ep_id% 10 = 0)
        )
    )
    order by rand() LIMIT 10);

    while exists (select * from ep_cuisine) do
        
        set id = (select cuisine_id from ep_cuisine LIMIT 1);
        
        /* 1) chef not in previous entries for the same episode
           2) chef has not appeared in 3 consecutive episodes in one season*/

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
        where (t.cuisine_id = id
        and t.user_id not in (
            select e1.user_id
            from episode_entry e1 
            inner join episode_entry e2 using (user_id)
            inner join episode_entry e3 using (user_id)
            where (
                e1.episode_id = ep_id - 1
                and e2.episode_id = ep_id - 2
                and e3.episode_id = ep_id - 3
                and (ep_id %10 >=4 or ep_id% 10 = 0)
            )
        ))
        order by rand() LIMIT 1;

        /*1) not more than 3 consecutive appearances in one season*/

        select r.recipe_id into rec
        from recipe r
        where (r.cuisine_id = id and r.recipe_id not in (
            select e1.recipe_id
            from episode_entry e1 
            inner join episode_entry e2 using (recipe_id)
            inner join episode_entry e3 using (recipe_id)
            where (
                e1.episode_id = ep_id - 1
                and e2.episode_id = ep_id - 2
                and e3.episode_id = ep_id - 3
                and (ep_id %10 >=4 or ep_id% 10 = 0)
            )
        ))
        order by rand() LIMIT 1;
        
        insert into episode_entry(episode_id, recipe_id, cuisine_id, user_id) values (ep_id, rec, id, c);
        delete from ep_cuisine where cuisine_id = id;

    end while;

    /* 1) judges not competing as chefs
       2) 3 different judges
       3) not more than 3 consecutive appearances in one season
    */
    insert into judges (episode_id, user_id)
    select ep_id, a.user_id
    from chefs a
    left join (
        select d.user_id
        from episode_entry d
        where (d.episode_id = ep_id)
    ) b
    on (a.user_id = b.user_id)
    where (b.user_id is null
    and a.user_id not in (
        select e1.user_id
        from episode_entry e1 
        inner join episode_entry e2 using (user_id)
        inner join episode_entry e3 using (user_id)
        where (
            e1.episode_id = ep_id - 1
            and e2.episode_id = ep_id - 2
            and e3.episode_id = ep_id - 3
            and (ep_id %10 >=4 or ep_id% 10 = 0)
        )
    ))
    order by rand() LIMIT 3;

end $$
delimiter ;