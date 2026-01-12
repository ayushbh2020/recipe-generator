-- Seed data for Meal Planner
-- Run this after schema.sql

-- ============================================================================
-- INGREDIENT CATEGORIES
-- ============================================================================

INSERT INTO ingredient_categories (name, slug, icon, display_order) VALUES
  ('Produce', 'produce', 'Carrot', 1),
  ('Proteins', 'proteins', 'Beef', 2),
  ('Dairy & Eggs', 'dairy-eggs', 'Milk', 3),
  ('Grains & Pasta', 'grains-pasta', 'Wheat', 4),
  ('Pantry Staples', 'pantry-staples', 'Package', 5),
  ('Canned & Jarred', 'canned-jarred', 'Container', 6),
  ('Spices & Seasonings', 'spices-seasonings', 'Flame', 7),
  ('Oils & Vinegars', 'oils-vinegars', 'Droplet', 8),
  ('Frozen', 'frozen', 'Snowflake', 9),
  ('Beverages', 'beverages', 'Cup', 10);

-- ============================================================================
-- COMMON INGREDIENTS
-- ============================================================================

-- Get category IDs for reference
DO $$
DECLARE
  produce_id UUID;
  proteins_id UUID;
  dairy_id UUID;
  grains_id UUID;
  pantry_id UUID;
  canned_id UUID;
  spices_id UUID;
  oils_id UUID;
  frozen_id UUID;
BEGIN
  SELECT id INTO produce_id FROM ingredient_categories WHERE slug = 'produce';
  SELECT id INTO proteins_id FROM ingredient_categories WHERE slug = 'proteins';
  SELECT id INTO dairy_id FROM ingredient_categories WHERE slug = 'dairy-eggs';
  SELECT id INTO grains_id FROM ingredient_categories WHERE slug = 'grains-pasta';
  SELECT id INTO pantry_id FROM ingredient_categories WHERE slug = 'pantry-staples';
  SELECT id INTO canned_id FROM ingredient_categories WHERE slug = 'canned-jarred';
  SELECT id INTO spices_id FROM ingredient_categories WHERE slug = 'spices-seasonings';
  SELECT id INTO oils_id FROM ingredient_categories WHERE slug = 'oils-vinegars';
  SELECT id INTO frozen_id FROM ingredient_categories WHERE slug = 'frozen';

  -- Produce
  INSERT INTO ingredients (name, slug, category_id, common_unit, is_common, aliases, dietary_tags) VALUES
    ('Tomatoes', 'tomatoes', produce_id, 'piece', true, ARRAY['tomato'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Onions', 'onions', produce_id, 'piece', true, ARRAY['onion', 'yellow onion'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Garlic', 'garlic', produce_id, 'clove', true, ARRAY['garlic clove'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Bell Peppers', 'bell-peppers', produce_id, 'piece', true, ARRAY['bell pepper', 'red pepper', 'green pepper'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Carrots', 'carrots', produce_id, 'piece', true, ARRAY['carrot'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Potatoes', 'potatoes', produce_id, 'lb', true, ARRAY['potato', 'russet potato'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Broccoli', 'broccoli', produce_id, 'bunch', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Spinach', 'spinach', produce_id, 'bunch', true, ARRAY['fresh spinach'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Lettuce', 'lettuce', produce_id, 'head', true, ARRAY['romaine', 'iceberg'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Cucumber', 'cucumber', produce_id, 'piece', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Avocado', 'avocado', produce_id, 'piece', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Lemon', 'lemon', produce_id, 'piece', true, ARRAY['lemons'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Lime', 'lime', produce_id, 'piece', true, ARRAY['limes'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Mushrooms', 'mushrooms', produce_id, 'lb', true, ARRAY['button mushrooms', 'cremini'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Zucchini', 'zucchini', produce_id, 'piece', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Sweet Potatoes', 'sweet-potatoes', produce_id, 'lb', true, ARRAY['sweet potato', 'yam'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Cilantro', 'cilantro', produce_id, 'bunch', false, ARRAY['fresh cilantro', 'coriander'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Parsley', 'parsley', produce_id, 'bunch', false, ARRAY['fresh parsley'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Basil', 'basil', produce_id, 'bunch', false, ARRAY['fresh basil'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Ginger', 'ginger', produce_id, 'piece', true, ARRAY['fresh ginger'], ARRAY['vegan', 'vegetarian', 'gluten-free']);

  -- Proteins
  INSERT INTO ingredients (name, slug, category_id, common_unit, is_common, aliases, dietary_tags) VALUES
    ('Chicken Breast', 'chicken-breast', proteins_id, 'lb', true, ARRAY['boneless chicken breast', 'chicken breasts'], ARRAY['gluten-free']),
    ('Chicken Thighs', 'chicken-thighs', proteins_id, 'lb', true, ARRAY['boneless chicken thighs'], ARRAY['gluten-free']),
    ('Ground Beef', 'ground-beef', proteins_id, 'lb', true, ARRAY['beef mince'], ARRAY['gluten-free']),
    ('Ground Turkey', 'ground-turkey', proteins_id, 'lb', true, ARRAY['turkey mince'], ARRAY['gluten-free']),
    ('Salmon', 'salmon', proteins_id, 'lb', true, ARRAY['salmon fillet'], ARRAY['gluten-free']),
    ('Shrimp', 'shrimp', proteins_id, 'lb', true, ARRAY['prawns'], ARRAY['gluten-free']),
    ('Tofu', 'tofu', proteins_id, 'block', true, ARRAY['firm tofu', 'extra firm tofu'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Black Beans', 'black-beans', proteins_id, 'can', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Chickpeas', 'chickpeas', proteins_id, 'can', true, ARRAY['garbanzo beans'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Lentils', 'lentils', proteins_id, 'cup', true, ARRAY['red lentils', 'green lentils'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Pork Chops', 'pork-chops', proteins_id, 'lb', false, ARRAY['pork loin chops'], ARRAY['gluten-free']),
    ('Bacon', 'bacon', proteins_id, 'lb', false, ARRAY[], ARRAY['gluten-free']),
    ('Sausage', 'sausage', proteins_id, 'lb', false, ARRAY['italian sausage'], ARRAY[]);

  -- Dairy & Eggs
  INSERT INTO ingredients (name, slug, category_id, common_unit, is_common, aliases, dietary_tags) VALUES
    ('Eggs', 'eggs', dairy_id, 'piece', true, ARRAY['egg'], ARRAY['vegetarian', 'gluten-free']),
    ('Milk', 'milk', dairy_id, 'cup', true, ARRAY['whole milk', '2% milk'], ARRAY['vegetarian', 'gluten-free']),
    ('Cheddar Cheese', 'cheddar-cheese', dairy_id, 'cup', true, ARRAY['shredded cheddar'], ARRAY['vegetarian', 'gluten-free']),
    ('Mozzarella Cheese', 'mozzarella-cheese', dairy_id, 'cup', true, ARRAY['shredded mozzarella'], ARRAY['vegetarian', 'gluten-free']),
    ('Parmesan Cheese', 'parmesan-cheese', dairy_id, 'cup', true, ARRAY['grated parmesan'], ARRAY['vegetarian', 'gluten-free']),
    ('Greek Yogurt', 'greek-yogurt', dairy_id, 'cup', true, ARRAY['plain greek yogurt'], ARRAY['vegetarian', 'gluten-free']),
    ('Butter', 'butter', dairy_id, 'tbsp', true, ARRAY['unsalted butter'], ARRAY['vegetarian', 'gluten-free']),
    ('Cream Cheese', 'cream-cheese', dairy_id, 'oz', true, ARRAY[], ARRAY['vegetarian', 'gluten-free']),
    ('Sour Cream', 'sour-cream', dairy_id, 'cup', false, ARRAY[], ARRAY['vegetarian', 'gluten-free']),
    ('Feta Cheese', 'feta-cheese', dairy_id, 'cup', false, ARRAY['crumbled feta'], ARRAY['vegetarian', 'gluten-free']);

  -- Grains & Pasta
  INSERT INTO ingredients (name, slug, category_id, common_unit, is_common, aliases, dietary_tags) VALUES
    ('White Rice', 'white-rice', grains_id, 'cup', true, ARRAY['long grain rice', 'jasmine rice'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Brown Rice', 'brown-rice', grains_id, 'cup', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Pasta', 'pasta', grains_id, 'lb', true, ARRAY['spaghetti', 'penne', 'fettuccine'], ARRAY['vegan', 'vegetarian']),
    ('Quinoa', 'quinoa', grains_id, 'cup', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Oats', 'oats', grains_id, 'cup', true, ARRAY['rolled oats', 'old fashioned oats'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Bread', 'bread', grains_id, 'slice', true, ARRAY['sliced bread', 'whole wheat bread'], ARRAY['vegetarian']),
    ('Flour', 'flour', grains_id, 'cup', true, ARRAY['all-purpose flour'], ARRAY['vegan', 'vegetarian']),
    ('Tortillas', 'tortillas', grains_id, 'piece', true, ARRAY['flour tortillas'], ARRAY['vegetarian']),
    ('Couscous', 'couscous', grains_id, 'cup', false, ARRAY[], ARRAY['vegan', 'vegetarian']);

  -- Pantry Staples
  INSERT INTO ingredients (name, slug, category_id, common_unit, is_common, aliases, dietary_tags) VALUES
    ('Salt', 'salt', pantry_id, 'tsp', true, ARRAY['kosher salt', 'sea salt'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Black Pepper', 'black-pepper', pantry_id, 'tsp', true, ARRAY['ground black pepper'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Sugar', 'sugar', pantry_id, 'cup', true, ARRAY['granulated sugar', 'white sugar'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Brown Sugar', 'brown-sugar', pantry_id, 'cup', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Honey', 'honey', pantry_id, 'tbsp', true, ARRAY[], ARRAY['vegetarian', 'gluten-free']),
    ('Soy Sauce', 'soy-sauce', pantry_id, 'tbsp', true, ARRAY[], ARRAY['vegan', 'vegetarian']),
    ('Baking Powder', 'baking-powder', pantry_id, 'tsp', false, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Baking Soda', 'baking-soda', pantry_id, 'tsp', false, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Vanilla Extract', 'vanilla-extract', pantry_id, 'tsp', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']);

  -- Canned & Jarred
  INSERT INTO ingredients (name, slug, category_id, common_unit, is_common, aliases, dietary_tags) VALUES
    ('Crushed Tomatoes', 'crushed-tomatoes', canned_id, 'can', true, ARRAY['canned crushed tomatoes'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Diced Tomatoes', 'diced-tomatoes', canned_id, 'can', true, ARRAY['canned diced tomatoes'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Tomato Paste', 'tomato-paste', canned_id, 'can', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Coconut Milk', 'coconut-milk', canned_id, 'can', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Chicken Broth', 'chicken-broth', canned_id, 'cup', true, ARRAY['chicken stock'], ARRAY['gluten-free']),
    ('Vegetable Broth', 'vegetable-broth', canned_id, 'cup', true, ARRAY['vegetable stock'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Peanut Butter', 'peanut-butter', canned_id, 'tbsp', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']);

  -- Spices & Seasonings
  INSERT INTO ingredients (name, slug, category_id, common_unit, is_common, aliases, dietary_tags) VALUES
    ('Cumin', 'cumin', spices_id, 'tsp', true, ARRAY['ground cumin'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Paprika', 'paprika', spices_id, 'tsp', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Chili Powder', 'chili-powder', spices_id, 'tsp', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Oregano', 'oregano', spices_id, 'tsp', true, ARRAY['dried oregano'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Thyme', 'thyme', spices_id, 'tsp', true, ARRAY['dried thyme'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Cayenne Pepper', 'cayenne-pepper', spices_id, 'tsp', false, ARRAY['ground cayenne'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Curry Powder', 'curry-powder', spices_id, 'tsp', false, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Garlic Powder', 'garlic-powder', spices_id, 'tsp', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Onion Powder', 'onion-powder', spices_id, 'tsp', false, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Italian Seasoning', 'italian-seasoning', spices_id, 'tsp', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']);

  -- Oils & Vinegars
  INSERT INTO ingredients (name, slug, category_id, common_unit, is_common, aliases, dietary_tags) VALUES
    ('Olive Oil', 'olive-oil', oils_id, 'tbsp', true, ARRAY['extra virgin olive oil'], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Vegetable Oil', 'vegetable-oil', oils_id, 'tbsp', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Sesame Oil', 'sesame-oil', oils_id, 'tbsp', false, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Balsamic Vinegar', 'balsamic-vinegar', oils_id, 'tbsp', false, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Red Wine Vinegar', 'red-wine-vinegar', oils_id, 'tbsp', false, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Rice Vinegar', 'rice-vinegar', oils_id, 'tbsp', false, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']);

  -- Frozen
  INSERT INTO ingredients (name, slug, category_id, common_unit, is_common, aliases, dietary_tags) VALUES
    ('Frozen Peas', 'frozen-peas', frozen_id, 'cup', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Frozen Corn', 'frozen-corn', frozen_id, 'cup', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Frozen Mixed Vegetables', 'frozen-mixed-vegetables', frozen_id, 'cup', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']),
    ('Frozen Berries', 'frozen-berries', frozen_id, 'cup', true, ARRAY[], ARRAY['vegan', 'vegetarian', 'gluten-free']);

END $$;
