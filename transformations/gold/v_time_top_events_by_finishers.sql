CREATE MATERIALIZED VIEW marathos.gold.v_time_top_events_by_finishers AS
SELECT DISTINCT
  de.event_name,
  de.event_number_of_finishers AS most_finishers
FROM
  marathos.gold.dim_event AS de
WHERE
  de.event_type = 'time'
ORDER BY
  most_finishers DESC
LIMIT 10