CREATE MATERIALIZED VIEW marathos.gold.mart_distance_speed_by_country AS
SELECT cc.country_name, AVG(r.athlete_average_speed) AS avg_speed
FROM marathos.gold.fct_results AS r
LEFT JOIN marathos.gold.dim_event AS de ON r.event_id = de.event_id
LEFT JOIN marathos.gold.dim_athlete AS da ON r.athlete_id = da.athlete_id
LEFT JOIN marathos.default.country_codes AS cc ON da.athlete_country = cc.code
WHERE de.event_type = 'distance'
GROUP BY cc.country_name
ORDER BY avg_speed DESC
LIMIT 20