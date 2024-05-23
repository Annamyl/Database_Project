from faker import Faker
from faker_food import FoodProvider
from faker.providers import DynamicProvider

import random

fake = Faker()
fake.add_provider(FoodProvider)

Recipes_const = 60
Users_const = 50
Ingr_const = 100
Episodes_const = 50
Cuis_const = 20
Equip_const = 20
Theme_const = 15
script = ""

chef_profession_provider = DynamicProvider (
    provider_name = "chef_profession",
    elements=["Executive Chef", "Senior Chef", "Sous Chef", "Line Cook", "Prep Cook"],
)

################################################################
cuis_rec = [[] for j in range(Cuis_const)]
r = []
for id in range(1,Cuis_const+1):
    name = fake.unique.ethnic_category()
    image = fake.image_url()
    image_desc = fake.text(max_nb_chars=150)
    script += f'INSERT INTO cuisine (cuisine_name, cuisine_image, image_description) VALUES ("{name}", "{image}", "{image_desc}");\n'
    n = random.randint(1, Recipes_const)
    while n in r:
        n = random.randint(1, Recipes_const)
    cuis_rec[id-1].append(n)
    r.append(n)

for id in range(1,Recipes_const+1):   
    type = random.choice(["Cooking", "Pastry"])
    # dish name????????????????
    name = fake.word()      
    summary = fake.dish_description()
    difficulty = random.randint(1,5)
    prep = random.randrange(5,51,5)
    cook = random.randrange(5,76,5)
    portions = random.randint(1,4)
    carbs = random.randint(10, 500)
    fat = random.randint(5,200)
    protein = random.randint(3,60)
    cuis_id = random.randint(1, Cuis_const)
    image = fake.image_url()
    image_desc = fake.text(max_nb_chars=150)
    
    script += f'INSERT INTO recipe (recipe_name, recipe_type, difficulty, summary, preparation_time, cooking_time, portions, carbs_per_portion, fat_per_portion, protein_per_portion, cuisine_id, recipe_image, image_description) VALUES ("{name}", "{type}", {difficulty}, "{summary}", {prep}, {cook}, {portions}, {carbs}, {fat}, {protein}, {cuis_id}, "{image}", "{image_desc}");\n'
    
tip_id = 0
for id in range(1, Recipes_const+1):
    for i in range(random.randint(0,3)):
        tip = fake.text(max_nb_chars=150)
        tip_id += 1
        script += f'INSERT INTO tips (recipe_id, tip) VALUES ({id}, "{tip}");\n'

step_id = 0
for id in range(1, Recipes_const+1):
    for i in range(random.randint(1,10)):
        step = fake.text(max_nb_chars=150)
        step_id += 1
        script += f'INSERT INTO steps (recipe_id, step) VALUES ({id}, "{step}");\n'


#################################################################

meals = ["Breakfast", "Lunch", "Brunch", "Dinner", "Supper", "Snack"]
meal_id = 1
for name in meals:
    image = fake.image_url()
    image_desc = fake.text(max_nb_chars=150)
    script += f'INSERT INTO meal_type (meal_name, meal_image, image_description) VALUES ("{name}", "{image}", "{image_desc}");\n'
    meal_id += 1
    
for id in range(1, Theme_const+1):
    name = fake.unique.category()
    summary = fake.text(max_nb_chars=200)
    image = fake.image_url()
    image_desc = fake.text(max_nb_chars=150)
    script += f'INSERT INTO themes (theme_name, summary, theme_image, image_description) VALUES ("{name}", "{summary}", "{image}", "{image_desc}");\n'

food_groups = ["Vegetables", "Fruits", "Cereal and Potatoes", "Milk and its products", "Legumes", "Red meat", "White meat", "Eggs", "Fish and seafood", "Added fats and oils, olives and nuts"]
description = ["All raw vegetables, eg lettuce, cabbage, carrot, tomato, cucumber, onion, etc. All cooked vegetables, eg broccoli, cauliflower, courgettes, greens, beetroot etc. Starchy vegetables, eg, peas, corn, pumpkin",
               "All raw fruits, e.g., orange, apple, pear, banana, peach, etc. All dried fruits, e.g., plums, raisins, apricots, etc. Natural fruit juices",
               "Wheat, oats, barley, rye etc. Rice. Flour, Bread, Simple baked goods, eg, toasts, nuts, breadcrumbs, crackers, Complex pastries, eg, doughs, pies, Pasta, eg, spaghetti, barley, noodles, Various cereal products, e.g., oatmeal, bran, Cereal. The potato and its varieties", 
               "The milk, Dairy products, e.g., yogurt, cheese, sour milk, etc.", 
               "The lentils, beans, chickpeas, fava bean, dry beans, Varieties of all of the above", 
               "Veal, beef, Pork, Lamb, sheep, goat, game: e.g., wild boar, deer, deer, all processed products of the above", 
               "Chicken, Turkey, Duck, Rabbit, game: eg, pheasant, quail, partridge. All processed products of the above", 
               "Eggs",
               "fish, e.g., sardine, bream, gopi, anchovy, atherina, ruff, flounder, grouper, cod, galley, tuna, sea bass, bream, bream, red snapper. Seafood (molluscs, shellfish, crustaceans), eg squid, cuttlefish, octopus, shrimp, mussels, oysters.",
               "Olive oil, other vegetable oils (seed oils): sunflower oil, corn oil, soybean oil, sesame oil, etc. Margarine and butter. Olives and nuts like Walnuts, almonds, peanuts, hazelnuts, etc. Sunflower seeds, sesame etc. Spreads derived from the above (eg tahini)."]

for i in range(10):
    image = fake.image_url()
    image_desc = fake.text(max_nb_chars=150)
    script += f'INSERT INTO food_groups (group_name, summary, group_image, image_description) VALUES ("{food_groups[i]}", "{description[i]}", "{image}", "{image_desc}");\n'

for id in range(1, Recipes_const+1):
    n = random.randint(1, Theme_const)
    dupl = []
    for i in range(n):
        j = random.randint(1, Theme_const)
        while j in dupl:
            j = random.randint(1, Theme_const)
        dupl.append(j)
        script += f'INSERT INTO recipe_themes (recipe_id, theme_id) VALUES ({id}, {j});\n'

#################################################################

Meal_const = len(meals)
for id in range(1, Recipes_const+1):
    n = random.randint(1, Meal_const)
    dupl = []
    for i in range(n):
        j = random.randint(1, Meal_const)
        while j in dupl:
            j = random.randint(1, Meal_const)
        dupl.append(j)
        script += f'INSERT INTO recipe_meal (recipe_id, meal_id) VALUES ({id}, {j});\n'

#################################################################

for id in range(1, Ingr_const+1):
    name = fake.unique.ingredient()
    calories = random.randint(10, 300)
    image = fake.image_url()
    image_desc = fake.text(max_nb_chars=150)
    script += f'INSERT INTO ingredients (ingr_name, calories, group_id, ingr_image, image_description) VALUES ("{name}", {calories}, {random.randint(1,10)}, "{image}", "{image_desc}");\n'
        
###############################################################

for id in range(1, Equip_const+1):
    name = fake.unique.word()
    summary = fake.text(max_nb_chars=150)
    image = fake.image_url()
    image_desc = fake.text(max_nb_chars=150)

    script += f'INSERT INTO equipment (equip_name, instructions, equip_image, image_description) VALUES ("{name}", "{summary}", "{image}", "{image_desc}");\n'

##############################################################

for id in range(1, Users_const+1):
    username = fake.unique.user_name()
    password = fake.text(max_nb_chars=15)
    script += f'INSERT INTO users (username, pass_word) VALUES ("{username}", "{password}");\n'
    
    # name = fake.unique.name()
    # name = name.split(' ', 1) 
    # first_name = name[0]
    # last_name = name[1]
    
    first_name = fake.first_name()
    last_name = fake.unique.last_name()
    
    phone = fake.phone_number()
    birth_date = fake.date_of_birth(minimum_age = 18, maximum_age=70)
    fake.add_provider(chef_profession_provider)
    profession_info = fake.chef_profession()
    experience = random.randint(1, 60)
    image = fake.image_url()
    image_desc = fake.text(max_nb_chars=150)
    script += f'INSERT INTO chefs (first_name, last_name, phone_number, date_of_birth, experience, profession_info, chef_image, image_description) VALUES ("{first_name}", "{last_name}", "{phone}", "{birth_date}", {experience}, "{profession_info}", "{image}", "{image_desc}");\n'

username = fake.unique.user_name()
password = fake.text(max_nb_chars=15)
script += f'INSERT INTO users (username, pass_word) VALUES ("{username}", "{password}");\n'
script += f'INSERT INTO admin_ (user_id) VALUES ({Users_const+1});\n'

################################################################
cuis_chef = [[] for j in range(Cuis_const)]
for id in range(1, Users_const+1):
    dupl = []
    for i in range(1, random.randint(2,Cuis_const)):
        n = random.randint(1,Cuis_const)
        while n in dupl:
            n = random.randint(1, Cuis_const)
        dupl.append(n)
        cuis_chef[n-1].append(id)
        script += f'INSERT INTO chef_cuisine (user_id, cuisine_id) VALUES ({id}, {n});\n'
        
entry_id = 0
judge_id = 0
ep_year = 2017
Chefs = [[] for j in range(Episodes_const)]
for id in range(1, Episodes_const+1):
    if (id % 10 == 1):
        ep_year += 1
    image = fake.image_url()
    image_desc = fake.text(max_nb_chars=150)
    
    script += f'INSERT INTO episode (ep_year, episode_image, image_description) VALUES ({ep_year},"{image}", "{image_desc}");\n'
    
    ep_judges = []
    for i in range(3):
        n = random.randint(1, Users_const)
        while n in ep_judges:
            n = random.randint(1, Users_const)
        ep_judges.append(n)
        judge_id += 1
        script += f'INSERT INTO judges (episode_id, user_id) VALUES ({id}, {n});\n'
    
    Cuis = []
    Rec = []
    for i in range(10):
        cuis = random.randint(1, Cuis_const)
        while cuis in Cuis:
            cuis = random.randint(1, Cuis_const)
        Cuis.append(cuis)
        
        recipe = random.choice(cuis_rec[cuis-1])
        while recipe in Rec:
            recipe = random.choice(cuis_rec[cuis-1])
        Rec.append(recipe)
        
        chef = random.choice(cuis_chef[cuis-1])
        if id > 4:
            while chef in Chefs[id-1] or chef in ep_judges or (chef in Chefs[id-2] and chef in Chefs[id-3] and chef in Chefs[id-4]):
                chef = random.choice(cuis_chef[cuis-1])
        else:
            while chef in Chefs[id-1] or chef in ep_judges:
                chef = random.choice(cuis_chef[cuis-1])
        Chefs[id-1].append(chef)
        
        entry_id += 1
        script += f'INSERT INTO episode_entry (episode_id, recipe_id, cuisine_id, user_id) VALUES ({id}, {recipe}, {cuis}, {chef});\n'
        for j in range(3):
            script += f'INSERT INTO score (entry_id, judge_id, s_value) VALUES ({entry_id}, {ep_judges[j]}, {random.randint(1,5)});\n'
    
    
################################################################

for id in range(1, Recipes_const+1):
    n = random.randint(2, Equip_const)
    dupl = []
    for i in range(n):
        j = random.randint(1, Equip_const)
        while j in dupl:
            j = random.randint(1, Equip_const)
        dupl.append(j)
        script += f'INSERT INTO recipe_equipment (recipe_id, equipment_id) VALUES ({id}, {j});\n'

ingr_num = 20
for id in range(1, Recipes_const+1):
    n = random.randint(4, ingr_num)
    dupl = []
    for i in range(n):
        q = random.choice([fake.measurement(), fake.metric_measurement(), fake.measurement_size()])
        j = random.randint(1, Ingr_const)
        while j in dupl:
            j = random.randint(1, Ingr_const)
        dupl.append(j)
        script += f'INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES ({id}, {j}, "{q}");\n'

with open("dummy_data.sql", "w") as f:
   f.write(script)