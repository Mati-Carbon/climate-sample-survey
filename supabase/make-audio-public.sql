-- Run once so new rows store playable URLs instead of file paths.
update storage.buckets
set public = true
where id = 'climate-survey-audio';
