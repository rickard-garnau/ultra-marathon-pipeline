CREATE MATERIALIZED VIEW marathos.gold.fct_results AS
SELECT
  event_id,
  athlete_id,
  athlete_performance,
  athlete_age_category,
  athlete_average_speed,
  year_of_event,
  event_unit
FROM marathos.silver.races_clean