alter table public.expenses
alter column code set not null;

create unique index if not exists expenses_user_code_unique
on public.expenses(user_id, code);

alter table public.expenses enable row level security;

drop policy if exists "Users can view own expenses" on public.expenses;
create policy "Users can view own expenses"
on public.expenses
for select
using (auth.uid() = user_id);

drop policy if exists "Users can insert own expenses" on public.expenses;
create policy "Users can insert own expenses"
on public.expenses
for insert
with check (auth.uid() = user_id);

drop policy if exists "Users can update own expenses" on public.expenses;
create policy "Users can update own expenses"
on public.expenses
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "Users can delete own expenses" on public.expenses;
create policy "Users can delete own expenses"
on public.expenses
for delete
using (auth.uid() = user_id);
