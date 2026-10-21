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

This repository is the initial project scaffold. It is **not production-ready yet**. No cloud database, authentication, payment integration, or mobile app is connected at this stage. Do not enter real customer, supplier, or financial data into a prototype.

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

1. Product requirements and database model
2. Authentication, shop setup, roles, and secure tenant isolation
3. Inventory, purchases, sales, and stock movement ledger
4. Reports, imports/exports, and backup/recovery
5. Subscription and payment integration
6. QA, pilot shops, privacy/terms, and production deployment
7. Mobile/PWA polish and scale testing

## Local preview

Open `index.html` in a browser to preview the public landing page. The landing page does not process payments or store inventory data.

## Business contact

Add an official support email and business details before public launch.
