--- Extract all dates between 1900 and 2030. Using formatpattern from Java's SimpleDateFormat to get the full day and month name.

CREATE MATERIALIZED VIEW marathos.gold.dim_date AS
WITH dates AS (SELECT
    explode(sequence(make_date(1900, 1, 1), make_date(2030, 1, 1), interval 1 day)) AS calendar_date
)
SELECT
  calendar_date,
  year(calendar_date) AS year,
  month(calendar_date) AS month,
  day(calendar_date) AS day,
  quarter(calendar_date) AS quarter,
  dayofweek(calendar_date) AS day_of_week,
  date_format(calendar_date, 'EEEE') AS day_name,
  date_format(calendar_date, 'MMMM') AS month_name
FROM
  dates