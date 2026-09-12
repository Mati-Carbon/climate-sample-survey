-- Climate survey: run this in Supabase → SQL Editor

create table if not exists public.climate_survey_responses (
  id uuid primary key default gen_random_uuid(),
  language text not null default 'hi',
  farmer_name text,
  farmer_phone text,
  farmer_name_transcript text,
  farmer_phone_transcript text,
  farmer_name_audio_path text,
  farmer_phone_audio_path text,
  q1_text text,
  q1_transcript text,
  q1_audio_path text,
  q2_text text,
  q2_transcript text,
  q2_audio_path text,
  q3_aware text,
  q3_text text,
  q3_transcript text,
  q3_audio_path text,
  user_agent text,
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

-- Audio files. Keep the bucket private; review clips in Storage or via signed URLs.
insert into storage.buckets (id, name, public)
values ('climate-survey-audio', 'climate-survey-audio', false)
on conflict (id) do nothing;

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
