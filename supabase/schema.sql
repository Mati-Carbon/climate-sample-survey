-- Climate survey: run this in a new project (SQL Editor)

create table if not exists public.climate_survey_responses (
  id uuid primary key default gen_random_uuid(),
  language text not null default 'en',
  farmer_name text,
  village_name text,
  farmer_phone text,
  latitude double precision,
  longitude double precision,
  location_accuracy double precision,
  farmer_photo_url text,
  q1_text text,
  q1_audio_url text,
  q2_text text,
  q2_audio_url text,
  q3_aware text,
  q3_text text,
  q3_audio_url text,
  created_at timestamptz not null default now()
);

create index if not exists climate_survey_responses_created_at_idx
  on public.climate_survey_responses (created_at desc);

alter table public.climate_survey_responses enable row level security;

grant usage on schema public to anon, authenticated;
grant insert, select on table public.climate_survey_responses to anon, authenticated;

drop policy if exists "anon_can_insert_survey" on public.climate_survey_responses;
create policy "anon_can_insert_survey"
  on public.climate_survey_responses
  for insert
  to anon, authenticated
  with check (true);

drop policy if exists "anon_can_read_survey" on public.climate_survey_responses;
create policy "anon_can_read_survey"
  on public.climate_survey_responses
  for select
  to anon, authenticated
  using (true);

insert into storage.buckets (id, name, public)
values ('climate-survey-audio', 'climate-survey-audio', true)
on conflict (id) do update set public = true;

drop policy if exists "anon_can_upload_survey_audio" on storage.objects;
create policy "anon_can_upload_survey_audio"
  on storage.objects
  for insert
  to anon, authenticated
  with check (bucket_id = 'climate-survey-audio');

drop policy if exists "anon_can_read_survey_audio" on storage.objects;
create policy "anon_can_read_survey_audio"
  on storage.objects
  for select
  to anon, authenticated
  using (bucket_id = 'climate-survey-audio');
