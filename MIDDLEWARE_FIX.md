# Middleware Fix - API Routes Exclusion

## Issue

The middleware was blocking all unauthenticated requests, including API routes to the FastAPI backend. This would have caused recipe generation and all backend functionality to fail.

## Changes Made

### 1. Updated Middleware Matcher (`middleware.ts`)

**Before:**

```typescript
'/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)';
```

**After:**

```typescript
'/((?!_next/static|_next/image|favicon.ico|api|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)';
//                                          ^^^ Added API exclusion
```

This prevents the middleware from even running on `/api/*` routes, improving performance.

### 2. Updated Authentication Logic (`lib/supabase/middleware.ts`)

**Before:**

```typescript
if (
  !user &&
  !request.nextUrl.pathname.startsWith('/login') &&
  !request.nextUrl.pathname.startsWith('/signup')
) {
  // Redirect to login
}
```

**After:**

```typescript
if (
  !user &&
  !request.nextUrl.pathname.startsWith('/login') &&
  !request.nextUrl.pathname.startsWith('/signup') &&
  !request.nextUrl.pathname.startsWith('/api') // Added
) {
  // Redirect to login
}
```

This provides defense-in-depth by explicitly checking for API routes in the authentication logic.

## Impact

### ✅ What Now Works

- FastAPI backend endpoints (`/api/*`) are accessible without authentication
- Recipe generation will work when implemented in Phase 2/3
- Client-side API calls won't be redirected to login
- No performance overhead for API requests (excluded from matcher)

### 🔒 What's Still Protected

- All app pages (`/ingredients`, `/recipes`, `/planner`, etc.)
- Dashboard (`/`)
- Settings page
- Any non-API routes

### 🔓 What's Public

- Login page (`/login`)
- Signup page (`/signup`)
- API routes (`/api/*`)
- Static files (`/_next/static`, `/_next/image`)
- Favicon and images

## Testing

To verify the fix works:

1. **Start the dev server:**

   ```bash
   npm run dev
   ```

2. **Test protected routes (should redirect to login):**

   ```bash
   curl -I http://localhost:3000/
   # Should return 307 redirect to /login
   ```

3. **Test API routes (should NOT redirect):**

   ```bash
   curl -I http://localhost:3000/api/health
   # Should return 404 or 200 (not 307 redirect)
   ```

4. **Test public routes (should work):**
   ```bash
   curl -I http://localhost:3000/login
   # Should return 200 OK
   ```

## Next Steps

With this fix in place, Phase 2 and Phase 3 can proceed safely:

- ✅ Ingredient search API endpoints will be accessible
- ✅ Recipe generation streaming endpoints will work
- ✅ Shopping list generation will function correctly

No further middleware changes needed for remaining phases.
