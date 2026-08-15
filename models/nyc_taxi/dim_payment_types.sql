{{ config(materialized='table') }}

SELECT
    payment_type_desc,
    total_trips,
    total_revenue,
    avg_tip,
    avg_tip_percentage
FROM {{ source('nyc_taxi', 'gold_payment') }}
ORDER BY total_trips DESC