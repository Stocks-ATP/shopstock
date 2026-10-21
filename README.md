# ShopStock

**Inventory management for small shops.**

ShopStock is being built as a mobile-friendly inventory and sales management SaaS for small retailers, with a target subscription price of ₹2,599/year (final pricing to be validated).

## Product goals

- Product catalogue with SKU/barcode-ready fields
- Stock-in, sales, returns, and stock adjustments
- Low-stock alerts and inventory valuation
- Supplier and purchase tracking
- Sales, margin, and stock reports
- Multiple staff roles and shop-level data isolation
- Secure authentication, cloud sync, and backups
- Subscription billing and account management
- Responsive web app, followed by Android/iOS delivery

## Current status

The repository currently contains a public landing page and an early Supabase-backed browser workspace (cloud.html). The workspace includes email/password signup and sign-in, shop setup, product catalogue, stock-in/sale adjustments with movement history, low-stock indicators, search, and CSV export. It is still a pilot build and **not production-ready**: the owner must configure Supabase, run the schema and stock RPC upgrade SQL, and complete account-isolation and end-to-end testing. Subscription billing, supplier/purchase management, full sales reporting, staff roles, and mobile apps are not yet implemented. Do not enter real customer, supplier, or financial data until security and backups have been reviewed.

## Planned architecture

- Web app: TypeScript + React (responsive/PWA)
- Backend and database: Supabase/PostgreSQL with Row Level Security
- Authentication: Supabase Auth
- Payments: Razorpay subscriptions/orders, verified server-side via webhooks
- Hosting: a production web host with environment-based configuration
- Mobile: PWA first; native app decision after pilot feedback

Architecture and provider choices will be finalized before production deployment.

## Security requirements before launch

- Enforce shop-level access with database Row Level Security
- Keep service-role keys and payment secrets server-side only
- Verify payment webhooks and prevent replay/duplicate processing
- Validate inputs and use auditable stock movements
- Configure backups, monitoring, error reporting, and recovery tests
- Test authorization, concurrent stock updates, and data export/deletion

## Development roadmap

1. Starter Supabase schema and browser workspace (in progress; pilot only)
2. Finish database setup and test tenant isolation with separate accounts
3. Add purchase/supplier records, sales records, and reports
4. Improve import/export, backups, recovery, and auditability
5. Integrate subscription billing with server-side payment verification
6. Add privacy/terms, monitoring, QA, and production deployment
7. Polish PWA/mobile experience and test with pilot shops

## Local preview

Open `index.html` in a browser to preview the public landing page. The landing page does not process payments or store inventory data.

## Business contact

Add an official support email and business details before public launch.
