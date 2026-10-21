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

## 3. Open the cloud workspace
1. Visit https://stocks-atp.github.io/shopstock/cloud.html (or use the “Open inventory workspace” button on the home page).
2. In Supabase Project Settings / API, copy the Project URL and publishable key (or legacy anon key).
3. Paste those two public values into the workspace and press Connect. Never use a service-role/secret key.
4. Create an account, confirm your email if Supabase asks, then sign in and create your shop.
5. Add a test product and test stock received / sale actions. Use product search and Export CSV to verify the inventory list can be filtered and downloaded.

## 4. Atomic stock update upgrade
The cloud workspace now uses a database function so stock quantity and movement history update together. To enable it:
1. Supabase Dashboard → SQL Editor → New query.
2. Open `supabase/upgrade_atomic_stock.sql` in GitHub and copy its full contents.
3. Paste and Run. Confirm the query succeeds before testing stock actions.

## 5. Important security notes
- Row Level Security (RLS) is enabled and policies restrict records to the authenticated shop owner.
- Never put a Supabase `service_role` / secret key in frontend code, HTML, mobile apps, screenshots, or GitHub.
- A publishable/anon key is designed for client-side use only when RLS is correctly configured.
- The legacy `app.html` prototype still uses browser local storage. Use `cloud.html` for the Supabase-backed workspace; it saves to Supabase only after a project is connected and you are signed in.
- Stock updates should eventually be handled by a database transaction/RPC so quantity changes and movement history cannot get out of sync.
- The cloud workspace includes signup/sign-in, password reset, shop onboarding, product search, CSV export, low-stock indicators, and stock movement history. Before production: test auth email redirects, RLS isolation with two accounts, backups, privacy/terms, error monitoring, and payment-provider webhooks. Do not store card details yourself.

## Planned core tables
- `shops`: shop owner and workspace.
- `products`: per-shop SKU, quantity, unit price, and low-stock threshold.
- `stock_movements`: append-only history of stock changes.

## Current status
Starter schema and cloud workspace UI are committed. The app still requires the project URL/public key entered by the owner, the atomic-stock upgrade SQL to be run, and end-to-end testing. Subscription billing is not enabled; do not treat this as production-ready until RLS and account-isolation tests pass.
