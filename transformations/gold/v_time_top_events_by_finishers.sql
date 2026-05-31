CREATE MATERIALIZED VIEW marathos.gold.v_time_top_events_by_finishers
SELECT event_name, event_number_of_finishers as most_finishers
FROM marathos.gold.dim_event AS de
WHERE de.event_type = 'time'
ORDER BY event_number_of_finishers DESC
LIMIT 10
