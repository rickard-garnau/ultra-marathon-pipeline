CREATE MATERIALIZED VIEW marathos.gold.dim_event AS
SELECT
    event_id,
    event_name,
    CASE
        WHEN event_unit = 'h' THEN 'time'
        ELSE 'distance'
    END AS event_type,
    event_country,
    event_distance_length,
    MAX(event_number_of_finishers) AS event_number_of_finishers,
    MAX(event_dates)               AS event_dates
FROM marathos.silver.races_clean_obt
GROUP BY
    event_id,
    event_name,
    event_unit,
    event_country,
    event_distance_length;