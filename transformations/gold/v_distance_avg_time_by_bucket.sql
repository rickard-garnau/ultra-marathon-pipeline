CREATE MATERIALIZED VIEW marathos.gold.v_distance_avg_time_by_bucket AS
SELECT
CASE 
  WHEN de.event_distance_length <= 50 THEN '0-50km'
  WHEN de.event_distance_length <= 100 THEN '50-100km'
  WHEN de.event_distance_length <= 200 THEN '100-200km'
  ELSE '200km+'
END AS distance_bucket,
AVG(r.athlete_performance) AS avg_time
FROM marathos.gold.dim_event as de
LEFT JOIN marathos.gold.fct_results AS r ON r.event_id = de.event_id
WHERE de.event_type = 'distance'
GROUP BY distance_bucket
ORDER BY avg_time

