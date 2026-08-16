-- Elara production schema. Run this in Supabase SQL Editor.
create extension if not exists pgcrypto;
create table if not exists public.businesses (
 id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
 name text not null, timezone text not null default 'America/New_York', created_at timestamptz not null default now()
);
create table if not exists public.employees (
 id uuid primary key default gen_random_uuid(), business_id uuid not null references public.businesses(id) on delete cascade,
 name text not null, email text, role text not null default 'Employee', availability text, active boolean not null default true, created_at timestamptz not null default now()
);
create table if not exists public.shifts (
 id uuid primary key default gen_random_uuid(), business_id uuid not null references public.businesses(id) on delete cascade,
 employee_id uuid not null references public.employees(id) on delete cascade, date date not null, start_time time not null, end_time time not null,
 role text not null, location text, notes text, created_at timestamptz not null default now(),
 constraint shift_time_order check (end_time > start_time)
);
create index if not exists employees_business_idx on public.employees(business_id);
create index if not exists shifts_business_date_idx on public.shifts(business_id,date);

alter table public.businesses enable row level security;
alter table public.employees enable row level security;
alter table public.shifts enable row level security;

create or replace function public.is_business_owner(bid uuid) returns boolean language sql stable security definer set search_path=public as $$ select exists(select 1 from businesses where id=bid and owner_id=auth.uid()); $$;
create or replace function public.employee_business(eid uuid) returns uuid language sql stable security definer set search_path=public as $$ select business_id from employees where id=eid; $$;

create policy "owners manage businesses" on public.businesses for all using (owner_id=auth.uid()) with check (owner_id=auth.uid());
create policy "owners manage employees" on public.employees for all using (is_business_owner(business_id)) with check (is_business_owner(business_id));
create policy "owners manage shifts" on public.shifts for all using (is_business_owner(business_id)) with check (is_business_owner(business_id));

-- Optional employee read access can be added later after implementing employee identities/invites.
