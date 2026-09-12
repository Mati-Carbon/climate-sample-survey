-- Run once in Supabase → SQL Editor if the table already exists
alter table public.climate_survey_responses
  add column if not exists farmer_email text;
