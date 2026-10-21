-- ShopStock safety upgrade: atomic stock adjustments and tighter movement policy
-- Run after schema.sql in Supabase SQL Editor.

drop policy if exists "Shop owners can add stock movements" on public.stock_movements;
create policy "Shop owners can add stock movements"
on public.stock_movements
for insert to authenticated
with check (
  created_by = (select auth.uid())
  and exists (
    select 1 from public.shops s
    where s.id = stock_movements.shop_id
      and s.owner_id = (select auth.uid())
  )
  and exists (
    select 1 from public.products p
    where p.id = stock_movements.product_id
      and p.shop_id = stock_movements.shop_id
  )
);

create or replace function public.adjust_shopstock_inventory(
  p_product_id uuid,
  p_delta integer,
  p_note text default null
)
returns public.products
language plpgsql
security invoker
set search_path = public
as $$
declare
  v_product public.products;
  v_movement_type text;
begin
  if auth.uid() is null then
    raise exception 'Please sign in first';
  end if;
  if p_delta is null or p_delta = 0 then
    raise exception 'Quantity change must not be zero';
  end if;

  update public.products p
     set quantity = p.quantity + p_delta,
         updated_at = now()
   where p.id = p_product_id
     and p.quantity + p_delta >= 0
     and exists (
       select 1 from public.shops s
       where s.id = p.shop_id and s.owner_id = auth.uid()
     )
   returning p.* into v_product;

  if not found then
    raise exception 'Product not found, access denied, or insufficient stock';
  end if;

  v_movement_type := case when p_delta > 0 then 'stock_received' else 'sale' end;

  insert into public.stock_movements (
    shop_id, product_id, movement_type, quantity_change,
    quantity_after, note, created_by
  ) values (
    v_product.shop_id, v_product.id, v_movement_type, p_delta,
    v_product.quantity, coalesce(nullif(trim(p_note), ''), v_movement_type),
    auth.uid()
  );

  return v_product;
end;
$$;

grant execute on function public.adjust_shopstock_inventory(uuid, integer, text) to authenticated;
