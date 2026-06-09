# Marathos Lab

Medallion pipeline for ultra marathon race data built on Databricks with Delta Live Tables.

## Dataset

7.4M rows of ultra marathon results covering events from 1990 to 2022. Source: Kaggle.
Stockholm Marathon 2024 is LLM-generated mock data added to test pipeline ingestion of new files.


## Pipeline

```
Volume (CSV) → Bronze → Silver → Gold → Genie / Dashboard
```

All layers run as a single DLT pipeline with wildcard source (`transformations/**`).

## Layers

**Bronze** (`marathos.bronze.races`)  
Raw ingestion via `readStream` from volume. Schema inferred from a static read and passed to the stream. Column mapping enabled for column names with spaces.

**Silver** (`marathos.silver.races_clean_obt`)  
6.67M rows after cleaning (~10.6% dropped). Key transformations:
- Unit standardization: `Miles/Mile` → `mi`, trailing `k` -> `km`, `mi` -> `km` conversion
- `event_unit` extracted as separate column before distance cast
- Performance converted to decimal hours (distance races) or decimal km (timed races)
- Dates: start date extracted from interval format, parsed to `DateType`
- Gender mapped: `M/F/X` -> `Male/Female/Other`, `null` -> `Other`
- Year of birth outside 1700–2005 -> `null`
- `event_country` extracted via regex from event name
- `event_id` and `athlete_id` hashed with `sha2` on name/ID fields
- Relay races, distances > 500, and rows with invalid characters dropped

**Gold** (`marathos.gold`)  
Dimensional model:

| Table | Description |
|---|---|
| `fct_results` | One row per athlete result |
| `dim_event` | One row per unique event, `MAX` on finishers/dates |
| `dim_athlete` | One row per unique athlete, `MAX` on mutable attributes |
| `dim_date` | Calendar dimension covering 1900–2030, joinable on `event_dates` |


Analytical views:
- `mart_distance_speed_by_country` — avg speed per country, distance races
- `mart_distance_avg_time_by_bucket` — avg finish time per distance bucket
- `mart_time_avg_distance_by_age` — avg distance per age category, timed races
- `mart_time_top_events_by_finishers` — top 10 timed events by finisher count
- `mart_finishers_by_year` - amount of people completing a race yearly

## Dashboard

![Dashboard](assets/dashboard_1.png)
![Dashboard](assets/dashboard_2.png)

Dashboard datasets (SQL, not persisted in pipeline):
- `mart_total_results` — total race entries
- `mart_unique_events` — count of unique events
- `mart_start_year` — first year on record
- `mart_unique_countries` — count of countries represented
- `mart_gender_distribution` — race entries split by gender
- `mart_distance_top_events_by_finishers` — top 10 distance events by finisher count
- `mart_avg_distance_by_age` — avg distance by age category, timed races (top 15)

## Genie

Gold tables linked to a Databricks Genie space for ad hoc questions. Answers verified manually in `explorations/genie_validation`. All results matched manual SQL calculations.

![Genie](assets/genie_dashboard.png)

## Structure

```
transformations/
  bronze/     DLT ingestion
  silver/     cleaning and standardization
  gold/       dimensional model + analytical views
explorations/
  eda_bronze
  silver_validation
  genie_validation
dimensional_modeling/
  model.dbml
  _Dimensional modeling.png
utils/
  utils.py
  country_codes.py
assets/
  dashboard.png
  genie_dashboard.png
```

## Sources

- Course material: [AIgineerAB](https://github.com/AIgineerAB/cloud_databricks_azure_course)
- Date dimension: [Build & Refresh a Calendar Dates Table — Databricks Community](https://community.databricks.com/t5/community-articles/build-amp-refresh-a-calendar-dates-table/td-p/90809)
- Peer discussions: class Discord
- LLM assistance: Claude (Anthropic) — used for code review, debugging and smaller implementations