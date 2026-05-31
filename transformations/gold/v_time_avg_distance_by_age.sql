CREATE MATERIALIZED VIEW marathos.gold.v_time_avg_distance_by_age AS 
SELECT
  athlete_age_category,
  AVG(event_distance_length) as avg_time_age
FROM
  marathos.gold.fct_results as r
    LEFT JOIN marathos.gold.dim_event as de
      ON r.event_id = de.event_id
WHERE
  de.event_type = 'time' AND athlete_age_category IS NOT NULL
GROUP BY
  athlete_age_category
ORDER BY
  avg_time_age DESC