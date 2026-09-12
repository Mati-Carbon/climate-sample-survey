-- Run once in Supabase → SQL Editor to match the simplified form.
-- Keeps existing name, phone, answers, and audio. Drops unused columns.

alter table public.climate_survey_responses
  add column if not exists q1_audio_url text,
  add column if not exists q2_audio_url text,
  add column if not exists q3_audio_url text;

update public.climate_survey_responses
set
  q1_audio_url = coalesce(q1_audio_url, q1_audio_path),
  q2_audio_url = coalesce(q2_audio_url, q2_audio_path),
  q3_audio_url = coalesce(q3_audio_url, q3_audio_path);

alter table public.climate_survey_responses
  drop column if exists farmer_email,
  drop column if exists farmer_name_transcript,
  drop column if exists farmer_phone_transcript,
  drop column if exists farmer_name_audio_path,
  drop column if exists farmer_phone_audio_path,
  drop column if exists q1_transcript,
  drop column if exists q1_audio_path,
  drop column if exists q2_transcript,
  drop column if exists q2_audio_path,
  drop column if exists q3_transcript,
  drop column if exists q3_audio_path,
  drop column if exists user_agent;

update storage.buckets
set public = true
where id = 'climate-survey-audio';
