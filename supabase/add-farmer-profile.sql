-- Run once in Supabase → SQL Editor
alter table public.climate_survey_responses
  add column if not exists village_name text,
  add column if not exists latitude double precision,
  add column if not exists longitude double precision,
  add column if not exists location_accuracy double precision,
  add column if not exists farmer_photo_url text;
