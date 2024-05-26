drop procedure if exists user_login;
delimiter $$
create procedure user_login (u_name varchar(45), p_word varchar(45))
begin

    if exists (select 1 from users u where u.username = u_name) then 
        select 
            (case    
            when u.pass_word = p_word then 'Access granted.'
            else 'Wrong password.' end) as access
        from users u
        where u.username = u_name;
    else 
        signal sqlstate '45000'
        set message_text = 'Username does not exists.';
    end if;
end $$
delimiter ;

