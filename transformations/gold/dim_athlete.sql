CREATE MATERIALIZED VIEW marathos.gold.dim_athlete AS
SELECT DISTINCT
  athlete_id,
  athlete_gender,
  athlete_club,
  athlete_country,
  athlete_year_of_birth
FROM marathos.silver.races_clean_obt