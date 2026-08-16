# Elara — deployable employee scheduling app

A clean owner/employer scheduling dashboard with weekly calendar, employees, shift CRUD, hours totals, CSV export, responsive mobile UI, and optional Supabase authentication/database.

## Run immediately (demo mode)

```bash
npm install
npm run dev
```

Open the Vite URL. Demo mode works without any account and persists data in browser localStorage.

## Deploy as a real multi-user app

1. Create a Supabase project.
2. In Supabase SQL Editor, run `supabase.sql`.
3. Enable Email/Password auth in Supabase.
4. Copy the project URL and anon key into `.env` using `.env.example`.
5. Run `npm run build` locally to verify.
6. Deploy this folder to Vercel/Netlify/Cloudflare Pages and add the same two environment variables.

### Production data wiring

The UI is deliberately usable in demo mode first. The production database schema is included. To wire the UI to Supabase, replace the local `loadDemo/saveDemo/update` data layer in `src/main.jsx` with Supabase queries for `businesses`, `employees`, and `shifts`. Authentication is already initialized and the login screen is ready.

## Included

- Owner dashboard
- Weekly scheduling grid
- Add/edit/delete shifts
- Employee management
- Weekly hours calculation
- CSV export
- Responsive mobile layout
- Supabase schema + RLS
- Demo mode with seeded employees/shifts
