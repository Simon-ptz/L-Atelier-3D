-- L'ATELIER 3D — schéma Supabase
-- À exécuter dans Supabase > SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create or replace function public.is_atelier_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.admin_users
    where user_id = (select auth.uid())
  );
$$;

create table if not exists public.products (
  id text primary key,
  name text not null,
  price numeric(10,2) not null default 0 check (price >= 0),
  unit text not null default 'la pièce',
  description text not null default '',
  symbol text not null default '✳',
  tag text not null default 'CRÉATION',
  stock integer not null default 0 check (stock >= 0),
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.sales (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  customer_name text not null,
  customer_email text,
  amount numeric(10,2) not null default 0 check (amount >= 0),
  status text not null default 'à préparer'
    check (status in ('à préparer','en cours','terminée','annulée')),
  details text not null default ''
);

alter table public.admin_users enable row level security;
alter table public.products enable row level security;
alter table public.sales enable row level security;

drop policy if exists "Public can read active products" on public.products;
create policy "Public can read active products"
on public.products for select
to anon, authenticated
using (active = true or public.is_atelier_admin());

drop policy if exists "Admins manage products" on public.products;
create policy "Admins manage products"
on public.products for all
to authenticated
using (public.is_atelier_admin())
with check (public.is_atelier_admin());

drop policy if exists "Admins read own admin record" on public.admin_users;
create policy "Admins read own admin record"
on public.admin_users for select
to authenticated
using (user_id = (select auth.uid()));

drop policy if exists "Admins manage sales" on public.sales;
create policy "Admins manage sales"
on public.sales for all
to authenticated
using (public.is_atelier_admin())
with check (public.is_atelier_admin());

insert into public.products (id,name,price,unit,description,symbol,tag,stock,active)
values
('flakes','Flocons & Étoiles de sapin',3,'la pièce','Des décorations délicates pour faire briller le sapin.','✳','DÉCORATION',0,true),
('animals','Mini-animaux articulés',3,'la pièce','De petites créatures ludiques à collectionner ou à offrir.','♧','PETIT CADEAU',0,true),
('initial','Porte-clés Initiale (A–Z)',3,'la pièce','Une initiale personnalisée à emporter partout.','A','PERSONNALISABLE',0,true),
('napkin','Ronds de serviette Initiale',6,'les 4','Une jolie attention personnalisée pour votre table de fête.','M','ART DE LA TABLE',0,true),
('lantern','Photophore village de Noël',5,'la pièce','Un petit village pour une grande ambiance. Bougie LED uniquement.','⌂','AMBIANCE',0,true),
('puzzle','Boîte casse-tête secrète',8,'la pièce','Un cadeau dans le cadeau… à vous de percer le secret.','◇','JEU & SURPRISE',0,true)
on conflict (id) do nothing;

-- Après avoir créé le compte dans Authentication > Users,
-- remplacez l'adresse ci-dessous par votre vraie adresse e-mail puis exécutez.
insert into public.admin_users (user_id)
select id from auth.users where email = 'VOTRE-EMAIL-ADMIN'
on conflict (user_id) do nothing;
