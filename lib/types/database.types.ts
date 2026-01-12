// Database types generated from Supabase schema

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string;
          display_name: string | null;
          dietary_restrictions: string[];
          household_size: number;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id: string;
          display_name?: string | null;
          dietary_restrictions?: string[];
          household_size?: number;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          display_name?: string | null;
          dietary_restrictions?: string[];
          household_size?: number;
          created_at?: string;
          updated_at?: string;
        };
      };
      ingredient_categories: {
        Row: {
          id: string;
          name: string;
          slug: string;
          icon: string | null;
          display_order: number;
        };
        Insert: {
          id?: string;
          name: string;
          slug: string;
          icon?: string | null;
          display_order?: number;
        };
        Update: {
          id?: string;
          name?: string;
          slug?: string;
          icon?: string | null;
          display_order?: number;
        };
      };
      ingredients: {
        Row: {
          id: string;
          name: string;
          slug: string;
          category_id: string | null;
          common_unit: string | null;
          is_common: boolean;
          aliases: string[];
          dietary_tags: string[];
          created_at: string;
        };
        Insert: {
          id?: string;
          name: string;
          slug: string;
          category_id?: string | null;
          common_unit?: string | null;
          is_common?: boolean;
          aliases?: string[];
          dietary_tags?: string[];
          created_at?: string;
        };
        Update: {
          id?: string;
          name?: string;
          slug?: string;
          category_id?: string | null;
          common_unit?: string | null;
          is_common?: boolean;
          aliases?: string[];
          dietary_tags?: string[];
          created_at?: string;
        };
      };
      recipes: {
        Row: {
          id: string;
          user_id: string;
          title: string;
          description: string | null;
          servings: number;
          prep_time_minutes: number | null;
          cook_time_minutes: number | null;
          total_time_minutes: number | null;
          difficulty: 'easy' | 'medium' | 'hard' | null;
          instructions: Json;
          nutrition_info: Json | null;
          dietary_tags: string[];
          meal_type: string[];
          cuisine: string | null;
          image_url: string | null;
          is_public: boolean;
          source: string;
          ai_generation_context: Json | null;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          user_id: string;
          title: string;
          description?: string | null;
          servings?: number;
          prep_time_minutes?: number | null;
          cook_time_minutes?: number | null;
          difficulty?: 'easy' | 'medium' | 'hard' | null;
          instructions: Json;
          nutrition_info?: Json | null;
          dietary_tags?: string[];
          meal_type?: string[];
          cuisine?: string | null;
          image_url?: string | null;
          is_public?: boolean;
          source?: string;
          ai_generation_context?: Json | null;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          user_id?: string;
          title?: string;
          description?: string | null;
          servings?: number;
          prep_time_minutes?: number | null;
          cook_time_minutes?: number | null;
          difficulty?: 'easy' | 'medium' | 'hard' | null;
          instructions?: Json;
          nutrition_info?: Json | null;
          dietary_tags?: string[];
          meal_type?: string[];
          cuisine?: string | null;
          image_url?: string | null;
          is_public?: boolean;
          source?: string;
          ai_generation_context?: Json | null;
          created_at?: string;
          updated_at?: string;
        };
      };
      meal_prep_plans: {
        Row: {
          id: string;
          user_id: string;
          title: string;
          description: string | null;
          target_servings: number;
          target_meals: number;
          dietary_restrictions: string[];
          source_ingredients: Json | null;
          prep_strategy: string | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          user_id: string;
          title: string;
          description?: string | null;
          target_servings?: number;
          target_meals?: number;
          dietary_restrictions?: string[];
          source_ingredients?: Json | null;
          prep_strategy?: string | null;
          created_at?: string;
        };
        Update: {
          id?: string;
          user_id?: string;
          title?: string;
          description?: string | null;
          target_servings?: number;
          target_meals?: number;
          dietary_restrictions?: string[];
          source_ingredients?: Json | null;
          prep_strategy?: string | null;
          created_at?: string;
        };
      };
      weekly_meal_plans: {
        Row: {
          id: string;
          user_id: string;
          week_start_date: string;
          title: string | null;
          notes: string | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          user_id: string;
          week_start_date: string;
          title?: string | null;
          notes?: string | null;
          created_at?: string;
        };
        Update: {
          id?: string;
          user_id?: string;
          week_start_date?: string;
          title?: string | null;
          notes?: string | null;
          created_at?: string;
        };
      };
      shopping_lists: {
        Row: {
          id: string;
          user_id: string;
          title: string | null;
          weekly_meal_plan_id: string | null;
          meal_prep_plan_id: string | null;
          status: 'active' | 'completed' | 'archived';
          created_at: string;
          completed_at: string | null;
        };
        Insert: {
          id?: string;
          user_id: string;
          title?: string | null;
          weekly_meal_plan_id?: string | null;
          meal_prep_plan_id?: string | null;
          status?: 'active' | 'completed' | 'archived';
          created_at?: string;
          completed_at?: string | null;
        };
        Update: {
          id?: string;
          user_id?: string;
          title?: string | null;
          weekly_meal_plan_id?: string | null;
          meal_prep_plan_id?: string | null;
          status?: 'active' | 'completed' | 'archived';
          created_at?: string;
          completed_at?: string | null;
        };
      };
    };
  };
}

// Helper types
export type Profile = Database['public']['Tables']['profiles']['Row'];
export type Ingredient = Database['public']['Tables']['ingredients']['Row'];
export type IngredientCategory =
  Database['public']['Tables']['ingredient_categories']['Row'];
export type Recipe = Database['public']['Tables']['recipes']['Row'];
export type MealPrepPlan =
  Database['public']['Tables']['meal_prep_plans']['Row'];
export type WeeklyMealPlan =
  Database['public']['Tables']['weekly_meal_plans']['Row'];
export type ShoppingList =
  Database['public']['Tables']['shopping_lists']['Row'];

// Dietary restriction options
export const DIETARY_RESTRICTIONS = [
  'vegetarian',
  'vegan',
  'gluten-free',
  'dairy-free',
  'nut-free',
] as const;

export type DietaryRestriction = (typeof DIETARY_RESTRICTIONS)[number];
