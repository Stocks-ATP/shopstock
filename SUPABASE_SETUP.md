# Connect ShopStock to Supabase

This repository currently contains a static marketing page and a browser-only inventory prototype. This setup adds a starter database schema; it does **not** by itself make the current app cloud-connected or production-ready.

## 1. Create a Supabase project
1. Open https://supabase.com/ and create a project in your own account.
2. Save the database password privately; never commit it to GitHub.
3. In Project Settings / API, copy the Project URL and the **publishable key** (or legacy anon key if that is what the dashboard provides).

## 2. Create the database tables
1. In the Supabase dashboard, open SQL Editor.
2. Open `supabase/schema.sql` in this repository and copy the SQL into a new query.
3. Run it. Confirm `shops`, `products`, and `stock_movements` appear in Table Editor.
4. Test with two separate test accounts before putting any real customer data into the app.

## 3. Important security notes
- Row Level Security (RLS) is enabled and policies restrict records to the authenticated shop owner.
- Never put a Supabase `service_role` / secret key in frontend code, HTML, mobile apps, screenshots, or GitHub.
- A publishable/anon key is designed for client-side use only when RLS is correctly configured.
- The current `app.html` uses browser local storage and does not yet call Supabase. Do not assume browser changes are cloud-synced.
- Stock updates should eventually be handled by a database transaction/RPC so quantity changes and movement history cannot get out of sync.
- Before production: add auth screens, shop onboarding, server-side validation, automated RLS tests, backups, privacy/terms, error monitoring, and payment-provider webhooks. Do not store card details yourself.

## Planned core tables
- `shops`: shop owner and workspace.
- `products`: per-shop SKU, quantity, unit price, and low-stock threshold.
- `stock_movements`: append-only history of stock changes.

## Current status
Database starter schema only. No live sign-in, cloud sync, subscription billing, or production guarantee yet.
