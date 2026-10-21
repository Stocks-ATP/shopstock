-- ShopStock MVP database schema for Supabase (Postgres)
-- Run in Supabase Dashboard > SQL Editor. Review before production use.
create extension if not exists pgcrypto;

create table if not exists public.shops (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  name text not null check (char_length(name) between 1 and 120),
  currency text not null default 'INR' check (currency = 'INR'),
  created_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  name text not null check (char_length(name) between 1 and 160),
  sku text not null check (char_length(sku) between 1 and 80),
  category text not null default 'General',
  quantity integer not null default 0 check (quantity >= 0),
  unit_price numeric(12,2) not null default 0 check (unit_price >= 0),
  low_stock_at integer not null default 5 check (low_stock_at >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (shop_id, sku)
);

create table if not exists public.stock_movements (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete cascade,
  movement_type text not null check (movement_type in ('opening_stock','stock_received','sale','correction')),
  quantity_change integer not null,
  quantity_after integer not null check (quantity_after >= 0),
  note text,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);

create index if not exists products_shop_id_idx on public.products(shop_id);
create index if not exists stock_movements_shop_created_idx on public.stock_movements(shop_id, created_at desc);

alter table public.shops enable row level security;
alter table public.products enable row level security;
alter table public.stock_movements enable row level security;

drop policy if exists "Owners can view their shops" on public.shops;
create policy "Owners can view their shops" on public.shops for select to authenticated using (owner_id = (select auth.uid()));
drop policy if exists "Owners can create their shops" on public.shops;
create policy "Owners can create their shops" on public.shops for insert to authenticated with check (owner_id = (select auth.uid()));
drop policy if exists "Owners can update their shops" on public.shops;
create policy "Owners can update their shops" on public.shops for update to authenticated using (owner_id = (select auth.uid())) with check (owner_id = (select auth.uid()));
drop policy if exists "Owners can delete their shops" on public.shops;
create policy "Owners can delete their shops" on public.shops for delete to authenticated using (owner_id = (select auth.uid()));

drop policy if exists "Shop owners can read products" on public.products;
create policy "Shop owners can read products" on public.products for select to authenticated using (exists (select 1 from public.shops s where s.id = shop_id and s.owner_id = (select auth.uid())));
drop policy if exists "Shop owners can add products" on public.products;
create policy "Shop owners can add products" on public.products for insert to authenticated with check (exists (select 1 from public.shops s where s.id = shop_id and s.owner_id = (select auth.uid())));
drop policy if exists "Shop owners can update products" on public.products;
create policy "Shop owners can update products" on public.products for update to authenticated using (exists (select 1 from public.shops s where s.id = shop_id and s.owner_id = (select auth.uid()))) with check (exists (select 1 from public.shops s where s.id = shop_id and s.owner_id = (select auth.uid())));
drop policy if exists "Shop owners can delete products" on public.products;
create policy "Shop owners can delete products" on public.products for delete to authenticated using (exists (select 1 from public.shops s where s.id = shop_id and s.owner_id = (select auth.uid())));

drop policy if exists "Shop owners can read stock movements" on public.stock_movements;
create policy "Shop owners can read stock movements" on public.stock_movements for select to authenticated using (exists (select 1 from public.shops s where s.id = shop_id and s.owner_id = (select auth.uid())));
drop policy if exists "Shop owners can add stock movements" on public.stock_movements;
create policy "Shop owners can add stock movements" on public.stock_movements for insert to authenticated with check (created_by = (select auth.uid()) and exists (select 1 from public.shops s where s.id = shop_id and s.owner_id = (select auth.uid())) and exists (select 1 from public.products p where p.id = product_id and p.shop_id = shop_id));

grant usage on schema public to authenticated;
grant select, insert, update, delete on public.shops, public.products to authenticated;
grant select, insert on public.stock_movements to authenticated;
