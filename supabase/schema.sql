-- Meal Planner Database Schema
-- Run this in your Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- USER PROFILES
-- ============================================================================

-- User Profiles (extends Supabase Auth)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  dietary_restrictions TEXT[] DEFAULT '{}',
  household_size INTEGER DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- INGREDIENTS
-- ============================================================================

-- Ingredient Categories
CREATE TABLE ingredient_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  slug TEXT NOT NULL UNIQUE,
  icon TEXT,
  display_order INTEGER DEFAULT 0
);

-- Master Ingredients List
CREATE TABLE ingredients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  category_id UUID REFERENCES ingredient_categories(id),
  common_unit TEXT,
  is_common BOOLEAN DEFAULT false,
  aliases TEXT[] DEFAULT '{}',
  dietary_tags TEXT[] DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Full-text search index for ingredients
CREATE INDEX ingredients_search_idx ON ingredients
  USING GIN (to_tsvector('english', name || ' ' || array_to_string(aliases, ' ')));

-- ============================================================================
-- RECIPES
-- ============================================================================

-- Recipes (AI-generated or saved)
CREATE TABLE recipes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  servings INTEGER DEFAULT 4,
  prep_time_minutes INTEGER,
  cook_time_minutes INTEGER,
  total_time_minutes INTEGER GENERATED ALWAYS AS (prep_time_minutes + cook_time_minutes) STORED,
  difficulty TEXT CHECK (difficulty IN ('easy', 'medium', 'hard')),
  instructions JSONB NOT NULL,
  nutrition_info JSONB,
  dietary_tags TEXT[] DEFAULT '{}',
  meal_type TEXT[] DEFAULT '{}',
  cuisine TEXT,
  image_url TEXT,
  is_public BOOLEAN DEFAULT false,
  source TEXT DEFAULT 'ai_generated',
  ai_generation_context JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Recipe Ingredients (junction table with quantities)
CREATE TABLE recipe_ingredients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  recipe_id UUID REFERENCES recipes(id) ON DELETE CASCADE,
  ingredient_id UUID REFERENCES ingredients(id),
  custom_ingredient_name TEXT,
  quantity DECIMAL(10, 2),
  unit TEXT,
  preparation_notes TEXT,
  is_optional BOOLEAN DEFAULT false,
  display_order INTEGER DEFAULT 0
);

-- ============================================================================
-- MEAL PREP PLANS
-- ============================================================================

-- Meal Prep Plans (batch cooking plans)
CREATE TABLE meal_prep_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  target_servings INTEGER DEFAULT 4,
  target_meals INTEGER DEFAULT 5,
  dietary_restrictions TEXT[] DEFAULT '{}',
  source_ingredients JSONB,
  prep_strategy TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Meal Prep Plan Recipes (junction)
CREATE TABLE meal_prep_plan_recipes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  meal_prep_plan_id UUID REFERENCES meal_prep_plans(id) ON DELETE CASCADE,
  recipe_id UUID REFERENCES recipes(id) ON DELETE CASCADE,
  portion_multiplier DECIMAL(4, 2) DEFAULT 1.0,
  prep_notes TEXT,
  storage_instructions TEXT,
  reheat_instructions TEXT,
  suggested_days TEXT[]
);

-- ============================================================================
-- WEEKLY MEAL PLANS
-- ============================================================================

-- Weekly Meal Plans (calendar-based)
CREATE TABLE weekly_meal_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  week_start_date DATE NOT NULL,
  title TEXT,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, week_start_date)
);

-- Meal Plan Entries (individual meals on specific days)
CREATE TABLE meal_plan_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  weekly_meal_plan_id UUID REFERENCES weekly_meal_plans(id) ON DELETE CASCADE,
  recipe_id UUID REFERENCES recipes(id) ON DELETE SET NULL,
  day_of_week INTEGER CHECK (day_of_week BETWEEN 0 AND 6),
  meal_type TEXT CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack')),
  servings INTEGER DEFAULT 1,
  notes TEXT,
  UNIQUE(weekly_meal_plan_id, day_of_week, meal_type)
);

-- ============================================================================
-- SHOPPING LISTS
-- ============================================================================

-- Shopping Lists
CREATE TABLE shopping_lists (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT,
  weekly_meal_plan_id UUID REFERENCES weekly_meal_plans(id) ON DELETE SET NULL,
  meal_prep_plan_id UUID REFERENCES meal_prep_plans(id) ON DELETE SET NULL,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'completed', 'archived')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  completed_at TIMESTAMP WITH TIME ZONE
);

-- Shopping List Items
CREATE TABLE shopping_list_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  shopping_list_id UUID REFERENCES shopping_lists(id) ON DELETE CASCADE,
  ingredient_id UUID REFERENCES ingredients(id),
  custom_item_name TEXT,
  quantity DECIMAL(10, 2),
  unit TEXT,
  category TEXT,
  is_checked BOOLEAN DEFAULT false,
  source_recipe_ids UUID[] DEFAULT '{}',
  notes TEXT
);

-- ============================================================================
-- USER SAVED RECIPES
-- ============================================================================

-- User Saved Recipes (favorites/bookmarks)
CREATE TABLE user_saved_recipes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  recipe_id UUID REFERENCES recipes(id) ON DELETE CASCADE,
  collection_name TEXT DEFAULT 'favorites',
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, recipe_id, collection_name)
);

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_prep_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_prep_plan_recipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE weekly_meal_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_plan_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE shopping_lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE shopping_list_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_saved_recipes ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Recipes policies
CREATE POLICY "Users can view own recipes" ON recipes FOR SELECT
  USING (auth.uid() = user_id OR is_public = true);
CREATE POLICY "Users can insert own recipes" ON recipes FOR INSERT
  WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own recipes" ON recipes FOR UPDATE
  USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own recipes" ON recipes FOR DELETE
  USING (auth.uid() = user_id);

-- Meal prep plans policies
CREATE POLICY "Users can view own meal prep plans" ON meal_prep_plans FOR SELECT
  USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own meal prep plans" ON meal_prep_plans FOR INSERT
  WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own meal prep plans" ON meal_prep_plans FOR UPDATE
  USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own meal prep plans" ON meal_prep_plans FOR DELETE
  USING (auth.uid() = user_id);

-- Meal prep plan recipes policies
CREATE POLICY "Users can view meal prep plan recipes" ON meal_prep_plan_recipes FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM meal_prep_plans
    WHERE id = meal_prep_plan_id AND user_id = auth.uid()
  ));
CREATE POLICY "Users can manage meal prep plan recipes" ON meal_prep_plan_recipes FOR ALL
  USING (EXISTS (
    SELECT 1 FROM meal_prep_plans
    WHERE id = meal_prep_plan_id AND user_id = auth.uid()
  ));

-- Weekly meal plans policies
CREATE POLICY "Users can view own weekly meal plans" ON weekly_meal_plans FOR SELECT
  USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own weekly meal plans" ON weekly_meal_plans FOR ALL
  USING (auth.uid() = user_id);

-- Meal plan entries policies
CREATE POLICY "Users can view meal plan entries" ON meal_plan_entries FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM weekly_meal_plans
    WHERE id = weekly_meal_plan_id AND user_id = auth.uid()
  ));
CREATE POLICY "Users can manage meal plan entries" ON meal_plan_entries FOR ALL
  USING (EXISTS (
    SELECT 1 FROM weekly_meal_plans
    WHERE id = weekly_meal_plan_id AND user_id = auth.uid()
  ));

-- Shopping lists policies
CREATE POLICY "Users can view own shopping lists" ON shopping_lists FOR SELECT
  USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own shopping lists" ON shopping_lists FOR ALL
  USING (auth.uid() = user_id);

-- Shopping list items policies
CREATE POLICY "Users can view shopping list items" ON shopping_list_items FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM shopping_lists
    WHERE id = shopping_list_id AND user_id = auth.uid()
  ));
CREATE POLICY "Users can manage shopping list items" ON shopping_list_items FOR ALL
  USING (EXISTS (
    SELECT 1 FROM shopping_lists
    WHERE id = shopping_list_id AND user_id = auth.uid()
  ));

-- User saved recipes policies
CREATE POLICY "Users can view own saved recipes" ON user_saved_recipes FOR SELECT
  USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own saved recipes" ON user_saved_recipes FOR ALL
  USING (auth.uid() = user_id);

-- ============================================================================
-- FUNCTIONS & TRIGGERS
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for profiles
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger for recipes
CREATE TRIGGER update_recipes_updated_at BEFORE UPDATE ON recipes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to create profile on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'display_name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile on signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
