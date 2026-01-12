# Meal Planner App - Architecture Plan

## Overview

Transform the existing Next.js + FastAPI chat demo into a full-featured meal prep planning app with AI-generated recipes.

## Core Features

1. **Smart Ingredient Selection** - Search with autocomplete + category browsing
2. **AI Meal Prep Generation** - Generate 3-5 complementary meals for batch cooking
3. **Dietary Restrictions** - Vegetarian, vegan, gluten-free, dairy-free, nut-free
4. **Save & Plan** - Save recipes, weekly meal calendar, shopping lists
5. **Auth Required** - Supabase Auth for user accounts

---

## Tech Stack

- **Frontend**: Next.js 14 (App Router), Tailwind CSS, shadcn/ui
- **Backend**: FastAPI (Python)
- **Database**: Supabase (Postgres + Auth + RLS)
- **AI**: OpenAI GPT-4o for recipe generation

---

## Data Model (Supabase)

```
profiles          - User preferences, dietary restrictions
ingredients       - Master ingredient list with categories
ingredient_categories - Produce, Proteins, Dairy, etc.
recipes           - AI-generated or saved recipes
recipe_ingredients - Junction with quantities
meal_prep_plans   - Batch cooking plans
weekly_meal_plans - Calendar-based planning
meal_plan_entries - Individual meals on days
shopping_lists    - Generated from meal plans
shopping_list_items - Items with checkboxes
user_saved_recipes - Favorites/bookmarks
```

---

## Page Structure

```
app/
├── (auth)/login, signup
├── (app)/
│   ├── page.tsx              # Dashboard
│   ├── ingredients/          # Ingredient selection
│   ├── generate/             # AI recipe generation (streaming)
│   ├── recipes/[id]          # Saved recipes
│   ├── meal-prep/[id]        # Meal prep plans
│   ├── planner/              # Weekly calendar
│   ├── shopping-list/        # Shopping lists
│   └── settings/             # User preferences
```

---

## Key Components to Build

**Ingredients**

- `ingredient-search.tsx` - Autocomplete search
- `ingredient-grid.tsx` - Category browsing
- `selected-ingredients-panel.tsx` - Selection sidebar

**Recipes**

- `recipe-card.tsx` - Preview card
- `recipe-detail.tsx` - Full view with instructions
- `recipe-stream.tsx` - Streaming generation display

**Meal Prep**

- `meal-prep-overview.tsx` - Plan with all meals
- `batch-cooking-tips.tsx` - Cooking order/tips

**Planner**

- `week-calendar.tsx` - 7-day grid view
- `recipe-picker-modal.tsx` - Add recipe to day

**Shopping**

- `shopping-list.tsx` - Checklist view
- `shopping-list-generator.tsx` - Generate from plan

---

## API Endpoints

```
# Ingredients
GET  /api/ingredients/search?q=
GET  /api/ingredients/categories

# Generation (Streaming SSE)
POST /api/generate/meal-prep
  Body: { ingredients[], dietary_restrictions[], num_meals, servings }

# Recipes
GET/POST/DELETE /api/recipes
POST /api/recipes/:id/save

# Meal Plans
GET/POST /api/meal-plans
GET/PUT /api/weekly-plans?week=

# Shopping
POST /api/shopping-lists/from-plan
PUT  /api/shopping-lists/:id/items/:itemId (toggle checked)
```

---

## AI Prompt Strategy

**Meal Prep System Prompt:**

- Generate complementary meals sharing base ingredients
- Include batch cooking order and tips
- Provide storage/reheating instructions
- Output structured JSON with recipes, nutrition, prep order

**Response Format:**

```json
{
  "plan_overview": { "description", "total_prep_time", "batch_cooking_tips" },
  "recipes": [{ "title", "ingredients", "instructions", "nutrition", "storage" }],
  "prep_order": ["Step 1...", "Step 2..."],
  "shopping_additions": ["missing items"]
}
```

---

## User Flow

```
1. Login → Dashboard
2. "Start Meal Prep" → Ingredient Selection
   - Search or browse categories
   - Select 5+ ingredients
   - Set dietary filters
3. "Generate" → Streaming Recipe Display
   - See 3-5 meals generated
   - View batch cooking tips
4. "Save Plan" → Meal Prep saved to account
5. "Add to Calendar" → Weekly planner
6. "Generate Shopping List" → Aggregated ingredients
```

---

## Files to Modify/Remove

**Remove (chat demo):**

- `components/chat.tsx`
- `components/message.tsx`
- `components/multimodal-input.tsx`
- `components/weather.tsx`
- `components/overview.tsx`
- `api/utils/tools.py` (weather tool)

**Adapt:**

- `api/utils/stream.py` → Recipe streaming
- `api/index.py` → New routers
- `app/layout.tsx` → New navigation
- `app/(chat)/page.tsx` → Dashboard

**Keep:**

- `components/ui/*` (button, textarea)
- `components/navbar.tsx` (adapt branding)
- `lib/utils.ts`
- Tailwind/styling setup

---

## Implementation Phases

### Phase 1: Foundation

- Set up Supabase project + schema
- Configure Supabase Auth
- Create auth pages (login/signup)
- Set up protected route wrapper

### Phase 2: Ingredients

- Seed ingredient database (~200 common items)
- Build search API with Postgres full-text search
- Create ingredient selection UI

### Phase 3: AI Generation

- Design meal prep prompt
- Implement streaming endpoint
- Build recipe stream display component

### Phase 4: Save & Organize

- Recipe CRUD
- Meal prep plan saving
- Saved recipes page

### Phase 5: Planning

- Weekly calendar component
- Meal plan entries CRUD
- Recipe picker modal

### Phase 6: Shopping

- Shopping list generation logic
- Checklist UI with categories

---

## Verification Plan

1. **Auth Flow**: Sign up → Login → Access protected routes
2. **Ingredient Selection**: Search "chicken" → Select → See in panel
3. **Generation**: Select 5 ingredients → Generate → See streaming recipes
4. **Save**: Save recipe → View in saved recipes list
5. **Calendar**: Add recipe to Monday dinner → See in planner
6. **Shopping**: Generate list from plan → Check off items

---

## Open Questions for User

None - ready for approval.
