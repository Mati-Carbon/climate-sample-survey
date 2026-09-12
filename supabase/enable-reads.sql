-- Run this once in Supabase → SQL Editor so the app can list responses and play audio.

grant select on table public.climate_survey_responses to anon, authenticated;

drop policy if exists "anon_can_read_survey" on public.climate_survey_responses;
create policy "anon_can_read_survey"
  on public.climate_survey_responses
  for select
  to anon, authenticated
  using (true);

drop policy if exists "anon_can_read_survey_audio" on storage.objects;
create policy "anon_can_read_survey_audio"
  on storage.objects
  for select
  to anon, authenticated
  using (bucket_id = 'climate-survey-audio');
