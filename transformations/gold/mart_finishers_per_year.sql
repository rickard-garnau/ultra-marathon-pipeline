CREATE MATERIALIZED VIEW marathos.gold.mart_finishers_per_year AS
SELECT
  d.year,
  COUNT(*) AS Finishers
FROM
  marathos.gold.dim_date d
    JOIN marathos.gold.dim_event de
      ON de.event_dates = d.calendar_date
    JOIN marathos.gold.fct_results r
      ON r.event_id = de.event_id
GROUP BY
  d.year
ORDER BY
  d.year