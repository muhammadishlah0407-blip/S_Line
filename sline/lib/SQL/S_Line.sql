-- 1. Tabel profiles
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  email text,
  avatar_url text
);

-- 2. Tabel wishlist
create table if not exists public.wishlist (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  product_id text not null,
  created_at timestamptz default now()
);

-- 3. Function & Trigger: Otomatis insert ke profiles saat user baru register
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, display_name)
  values (new.id, new.email, new.raw_user_meta_data->>'display_name');
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

-- 4. Policy untuk profiles
alter table public.profiles enable row level security;

create policy "User can select own profile" on public.profiles
  for select using (auth.uid() = id);

create policy "User can update own profile" on public.profiles
  for update using (auth.uid() = id);

-- 5. Policy untuk wishlist
alter table public.wishlist enable row level security;

create policy "Allow select for authenticated users" on public.wishlist
  for select using (auth.uid() = user_id);

create policy "Allow insert for authenticated users" on public.wishlist
  for insert with check (auth.uid() = user_id);

create policy "Allow update for authenticated users" on public.wishlist
  for update using (auth.uid() = user_id);

create policy "Allow delete for authenticated users" on public.wishlist
  for delete using (auth.uid() = user_id);

-- 6. (Opsional) Index untuk performa
create index if not exists idx_wishlist_user_id on public.wishlist(user_id);
create index if not exists idx_wishlist_product_id on public.wishlist(product_id);

-- 7. Policy Storage Bucket avatars (jalankan setelah membuat bucket 'avatars' di Storage UI)
-- Allow all insert to avatars
create policy "Allow all insert to avatars" on storage.objects
  for insert using (bucket_id = 'avatars' and auth.role() = 'authenticated');

-- Allow public download
create policy "Allow public download" on storage.objects
  for select using (bucket_id = 'avatars');