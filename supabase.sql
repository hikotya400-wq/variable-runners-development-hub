-- VARIABLE RUNNERS DEVELOPMENT HUB
-- 完全公開（認証なし）用スキーマ。実行すると誰でも読み書き・削除できます。
-- Supabase SQL Editorで一度だけ実行してください。

create extension if not exists pgcrypto;

create table if not exists public.assets (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  major text,
  middle text,
  minor text,
  status text not null default '制作中',
  tags text[] not null default '{}',
  description text,
  preview_url text,
  file_urls text[] not null default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text,
  priority text not null default '中',
  status text not null default '未着手',
  due_date date,
  description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.documents (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text not null default '基本システム',
  content text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.activity_logs (
  id uuid primary key default gen_random_uuid(),
  action text not null,
  entity_type text,
  entity_title text,
  created_at timestamptz not null default now()
);

alter table public.assets enable row level security;
alter table public.tasks enable row level security;
alter table public.documents enable row level security;
alter table public.activity_logs enable row level security;

drop policy if exists "public full access assets" on public.assets;
create policy "public full access assets" on public.assets for all to anon, authenticated using (true) with check (true);
drop policy if exists "public full access tasks" on public.tasks;
create policy "public full access tasks" on public.tasks for all to anon, authenticated using (true) with check (true);
drop policy if exists "public full access documents" on public.documents;
create policy "public full access documents" on public.documents for all to anon, authenticated using (true) with check (true);
drop policy if exists "public full access activity logs" on public.activity_logs;
create policy "public full access activity logs" on public.activity_logs for all to anon, authenticated using (true) with check (true);

grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on public.assets, public.tasks, public.documents, public.activity_logs to anon, authenticated;

-- 画像などを置く公開バケット（URLを知っている人はファイルを閲覧できます）
insert into storage.buckets (id, name, public, file_size_limit)
values ('vr-assets', 'vr-assets', true, 10485760)
on conflict (id) do update set public = true, file_size_limit = 10485760;

drop policy if exists "public read vr assets" on storage.objects;
create policy "public read vr assets" on storage.objects for select to anon, authenticated
using (bucket_id = 'vr-assets');
drop policy if exists "public upload vr assets" on storage.objects;
create policy "public upload vr assets" on storage.objects for insert to anon, authenticated
with check (bucket_id = 'vr-assets');
drop policy if exists "public update vr assets" on storage.objects;
create policy "public update vr assets" on storage.objects for update to anon, authenticated
using (bucket_id = 'vr-assets') with check (bucket_id = 'vr-assets');
drop policy if exists "public delete vr assets" on storage.objects;
create policy "public delete vr assets" on storage.objects for delete to anon, authenticated
using (bucket_id = 'vr-assets');
