drop database if exists competition;
create database competition;
use competition;

-- Entities

create table cuisine (
	cuisine_id int unsigned not null auto_increment,
	cuisine_name varchar(45) not null,
	cuisine_image varchar(45) not null,
	image_description varchar(150) not null,
	primary key (cuisine_id)
);

create table recipe (
	recipe_id int unsigned not null auto_increment,
	recipe_name varchar(45) not null,
	recipe_type varchar(20) not null,
	difficulty int not null check (difficulty >= 1 and difficulty <= 5),
	summary varchar(200) not null,
	preparation_time int not null,
	cooking_time int not null,
	portions int not null,
	carbs_per_portion int not null,
	fat_per_portion int not null,
	protein_per_portion int not null,
	cuisine_id int unsigned not null,
	recipe_image varchar(45) not null,
	image_description varchar(150) not null,
	primary key (recipe_id),
	constraint fk_recipe_cuisine foreign key (cuisine_id) references cuisine (cuisine_id) on delete cascade on update cascade
);

create table tips (
	tip_id int unsigned not null auto_increment,
	recipe_id int unsigned not null,
	tip varchar(200) not null,
	primary key (tip_id),
	constraint fk_recipe_tips foreign key (recipe_id) references recipe (recipe_id) on delete cascade on update cascade
);

create table steps (
	step_id int unsigned not null auto_increment,
	recipe_id int unsigned not null,
	step varchar(200) not null,
	primary key (step_id),
	constraint fk_recipe_steps foreign key (recipe_id) references recipe (recipe_id) on delete cascade on update cascade
);

create table tags (
	tag_id int unsigned not null auto_increment,
	tag varchar(45) not null,
	primary key (tag_id)
);

create table meal_type (
	meal_id int unsigned not null auto_increment,
	meal_name varchar(45) not null,
	meal_image varchar(45) not null,
	image_description varchar(150) not null,
	primary key (meal_id)
);

create table equipment (
	equipment_id int unsigned not null auto_increment,
	equip_name varchar(45) not null,
	instructions varchar(150) not null,
	equip_image varchar(45) not null,
	image_description varchar(150) not null,
	primary key (equipment_id)
);

create table food_groups (
	group_id int unsigned not null auto_increment,
	group_name varchar(45) not null,
	rec_category varchar(45) not null,
	summary varchar(300) not null,
	group_image varchar(45) not null,
	image_description varchar(150) not null,
	primary key (group_id)
);

create table ingredients (
	ingredient_id int unsigned not null auto_increment,
	ingr_name varchar(45) not null,
	calories int not null,
	group_id int unsigned not null, 
	ingr_image varchar(45) not null,
	image_description varchar(150) not null,
	primary key (ingredient_id),
	constraint fk_ingr_group foreign key (group_id) references food_groups (group_id) on delete cascade on update cascade
);

create table themes (
	theme_id int unsigned not null auto_increment,
	theme_name varchar(45) not null,
	summary varchar(200) not null,
	theme_image varchar(45) not null,
	image_description varchar(150) not null,
	primary key (theme_id)
);

create table users (
	user_id int unsigned not null auto_increment,
	username varchar(45) not null unique,
	pass_word varchar(45) not null,
	primary key (user_id)
);

create table admin_ (
	user_id int unsigned not null auto_increment, 
	constraint fx_users_admin foreign key (user_id) references users (user_id) on delete cascade on update cascade
);

create table chefs (
	user_id int unsigned not null auto_increment,
	first_name varchar(45) not null,
	last_name varchar(45) not null,
	phone_number varchar(15) not null,
	date_of_birth datetime not null,
	experience int not null,
	profession_info varchar(50) not null,
	chef_image varchar(45) not null,
	image_description varchar(150) not null,
	constraint fx_users_chef foreign key (user_id) references users (user_id) on delete cascade on update cascade
);

create table episode (
	episode_id int unsigned not null auto_increment,
	ep_year int not null,
	episode_image varchar(45) not null,
	image_description varchar(100) not null,
	primary key (episode_id)
);

create table episode_entry (
	episode_id int unsigned not null,
	entry_id int unsigned not null auto_increment,
	recipe_id int unsigned not null,
	cuisine_id int unsigned not null,													
	user_id int unsigned not null,
	primary	key (entry_id),
	constraint fk_recipe_entry foreign key (recipe_id) references recipe (recipe_id) on delete cascade on update cascade,
	constraint fk_cuisine_entry foreign key (cuisine_id) references cuisine (cuisine_id) on delete cascade on update cascade,
	constraint fk_chef_entry foreign key (user_id) references chefs (user_id) on delete cascade on update cascade,
	constraint fk_episode_entry foreign key (episode_id) references episode (episode_id) on delete cascade on update cascade
);

create table judges (
	-- judge_id int unsigned not null auto_increment,
	episode_id int unsigned not null,
	user_id int unsigned not null,
	primary key (episode_id, user_id),
	constraint fk_chef_judge foreign key (user_id) references chefs (user_id) on delete cascade on update cascade,
	constraint fk_episode_judge foreign key (episode_id) references episode (episode_id) on delete cascade on update cascade
);

-- Relationships

create table score (
	entry_id int unsigned not null,
	judge_id int unsigned not null,
	s_value int not null check (s_value >= 1 and s_value <= 5),
	primary key (entry_id, judge_id),
	constraint fk_judge_score foreign key (judge_id) references judges (user_id) on delete cascade on update cascade,
	constraint fk_entry_score foreign key (entry_id) references episode_entry (entry_id) on delete cascade on update cascade
);

create table recipe_meal (
	recipe_id int unsigned not null,
	meal_id int unsigned not null,
	primary key (recipe_id, meal_id),
	constraint fk_recipe_meal foreign key (recipe_id) references recipe (recipe_id) on delete cascade on update cascade,
	constraint fk_meal_rec foreign key (meal_id) references meal_type (meal_id) on delete cascade on update cascade
);

create table chef_cuisine (
	user_id int unsigned not null,
	cuisine_id int unsigned not null,
	primary key (user_id, cuisine_id),
	constraint fk_chef_cuis foreign key (user_id) references chefs (user_id) on delete cascade on update cascade,
	constraint fk_cuisine_chef foreign key (cuisine_id) references cuisine (cuisine_id) on delete cascade on update cascade
);

create table recipe_themes (
	recipe_id int unsigned not null,
	theme_id int unsigned not null,
	primary key (recipe_id, theme_id),
	constraint fk_recipe_theme foreign key (recipe_id) references recipe (recipe_id) on delete cascade on update cascade,
	constraint fk_theme_rec foreign key (theme_id) references themes (theme_id) on delete cascade on update cascade
);

create table recipe_ingredients (
	recipe_id int unsigned not null,
	ingredient_id int unsigned not null,
	main_ingr bit(1) not null,
	quantity varchar(45) not null,
	primary key (recipe_id, ingredient_id),
	constraint fk_recipe_ingr foreign key (recipe_id) references recipe (recipe_id) on delete cascade on update cascade,
	constraint fk_ingredient_rec foreign key (ingredient_id) references ingredients (ingredient_id) on delete cascade on update cascade
);

create table recipe_equipment (
	recipe_id int unsigned not null,
	equipment_id int unsigned not null,
	primary key (recipe_id, equipment_id),
	constraint fk_recipe_equip foreign key (recipe_id) references recipe (recipe_id) on delete cascade on update cascade,
	constraint fk_equipment_rec foreign key (equipment_id) references equipment (equipment_id) on delete cascade on update cascade
);

create table recipe_tag (
	recipe_id int unsigned not null,
	tag_id int unsigned not null,
	primary key (recipe_id, tag_id),
	constraint fk_recipe_tag foreign key (recipe_id) references recipe (recipe_id) on delete cascade on update cascade,
	constraint fk_tag_recipe foreign key (tag_id) references tags (tag_id) on delete cascade on update cascade
);

-- Indexes

-- 3.10, 3.12 
create index idx_year on episode (ep_year);

-- 3.3
create index idx_birth_date on chefs (date_of_birth);

-- 3.13, find winner
create index idx_prof on chefs (profession_info);

-- count_cal
create index idx_quant on recipe_ingredients (quantity);


-- Triggers

-- max 3 tips per recipe
delimiter $$
create trigger chk_tips_per_ep before insert on tips
for each row
begin
	declare c_tip int;
    set c_tip = (select count(*) from tips where recipe_id = new.recipe_id);
    if (c_tip >= 3) then signal sqlstate '45000'
		set message_text = 'Number of tips reached maximum limit.';
    end if;
end $$


-- max 10 entries per episode
create trigger chk_entries_per_ep before insert on episode_entry
for each row
begin	
	declare c_ep int;
	set c_ep = (select count(*) from episode_entry where episode_id = new.episode_id);
	if (c_ep = 10) then signal sqlstate '45000'
		set message_text = 'Number of contestants for episode has been reached.';
	end if;
end $$

-- max 3 judges per episode
create trigger chk_judges_per_ep before insert on judges
for each row
begin
	declare c_jud int;
	set c_jud = (select count(*) from judges where episode_id = new.episode_id);
	if (c_jud = 3) then signal sqlstate '45000'
		set message_text = 'Number of judges for episode has been reached.';
	end if;
end $$

-- up to 3 consecutive appearances of chef in episodes (as contestant)
create trigger chk_chef_ep before insert on episode_entry
for each row
begin
	if (new.episode_id %10 >=4 or new.episode_id% 10 = 0) then
	if exists (select 1 from episode_entry where new.episode_id > 3 and episode_id = new.episode_id - 3 and user_id = new.user_id) then
		if exists (select 1 from episode_entry where episode_id = new.episode_id - 2 and user_id = new.user_id) then
			if exists (select 1 from episode_entry where episode_id = new.episode_id - 1 and user_id = new.user_id) then
				signal sqlstate '45000'
				set message_text = 'Chef has already participated in three consecutive episodes.';
			end if;
		end if;
	end if;
	end if;
end $$

delimiter ;