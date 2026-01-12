# Supabase Setup Guide

## 1. Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up/login
2. Click "New Project"
3. Fill in project details:
   - **Name**: meal-planner (or your preferred name)
   - **Database Password**: Generate a strong password (save it!)
   - **Region**: Choose closest to your users
4. Wait for project to initialize (~2 minutes)

## 2. Run Database Schema

1. In your Supabase dashboard, go to **SQL Editor**
2. Click **New Query**
3. Copy the contents of `supabase/schema.sql`
4. Paste into the SQL editor
5. Click **Run** to execute
6. You should see: "Success. No rows returned"

## 3. Seed Initial Data

1. In the same SQL Editor, click **New Query**
2. Copy the contents of `supabase/seed.sql`
3. Paste and click **Run**
4. This will populate ingredient categories and ~100 common ingredients

## 4. Get API Keys

1. In Supabase dashboard, go to **Settings** → **API**
2. Copy the following values:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon/public key**: Long string starting with `eyJ...`

## 5. Configure Environment Variables

1. Create a `.env.local` file in the project root (copy from `.env.example`):

```bash
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here

# OpenAI Configuration
OPENAI_API_KEY=your-openai-key
```

2. Add `.env.local` to `.gitignore` (already done)

## 6. Verify Setup

Run the development server:

```bash
npm run dev
```

The app should now be able to connect to Supabase. You can verify by:

1. Going to `/signup` and creating an account
2. Check your Supabase dashboard → **Authentication** → **Users**
3. You should see your new user listed

## Row Level Security (RLS)

The schema automatically enables RLS on all user tables. This means:

- Users can only access their own data
- Authentication is required for all protected routes
- The middleware handles redirects for unauthenticated users

## Database Structure

**User Tables:**

- `profiles` - User preferences and dietary restrictions
- `recipes` - Saved recipes
- `meal_prep_plans` - Batch cooking plans
- `weekly_meal_plans` - Calendar-based meal plans
- `shopping_lists` - Shopping lists

**Shared Tables (no RLS):**

- `ingredients` - Master ingredient list (read-only for users)
- `ingredient_categories` - Category definitions

## Adding More Ingredients

To add more ingredients, you can:

1. Use the SQL Editor to run INSERT statements
2. Or create an admin interface (future feature)
3. Or bulk import from CSV via Supabase Table Editor

Example:

```sql
INSERT INTO ingredients (name, slug, category_id, common_unit, is_common, dietary_tags)
VALUES ('Asparagus', 'asparagus',
  (SELECT id FROM ingredient_categories WHERE slug = 'produce'),
  'bunch', false, ARRAY['vegan', 'vegetarian', 'gluten-free']);
```
