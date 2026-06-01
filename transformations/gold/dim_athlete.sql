CREATE MATERIALIZED VIEW marathos.gold.dim_athlete AS
SELECT
  athlete_id,
  MAX(athlete_gender) AS athlete_gender,
  MAX(athlete_club) AS athlete_club,
  MAX(athlete_country) AS athlete_country,
  MAX(athlete_year_of_birth) AS athlete_year_of_birth
FROM
  marathos.silver.races_clean_obt
GROUP BY
  athlete_id;