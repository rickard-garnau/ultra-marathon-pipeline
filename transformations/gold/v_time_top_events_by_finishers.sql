CREATE MATERIALIZED VIEW marathos.gold.v_time_top_events_by_finishers AS
SELECT
  event_name,
  MAX(event_number_of_finishers) AS most_finishers
FROM marathos.gold.dim_event
WHERE event_type = 'time'
GROUP BY event_name
ORDER BY most_finishers DESC
LIMIT 10;