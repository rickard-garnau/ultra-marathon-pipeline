CREATE MATERIALIZED VIEW marathos.gold.dim_event AS
SELECT DISTINCT
  event_id,
  event_name,
  CASE
    WHEN event_unit = 'h' THEN 'time'
    ELSE 'distance'
  END AS event_type,
  event_country,
  event_distance_length,
  event_number_of_finishers,
  event_dates
FROM
  marathos.silver.races_clean