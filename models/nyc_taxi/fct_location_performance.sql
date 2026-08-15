{{ config(materialized='table') }}
SELECT pickup_location_id,
total_trips,
total_revenue,
avg_trip_distance,
avg_tip,
ROUND(total_revenue / total_trips,2) AS revenue_per_trip,
ROUND(avg_tip / (total_revenue / total_trips) * 100, 2) AS tip_percentage,
CASE
    WHEN total_trips > 50000 THEN 'High Demand Zone'
    WHEN total_trips > 20000 THEN 'Medium Demand Zone'
    ELSE 'Low Demand Zone'
END AS demand_zone,
CASE 
    WHEN avg_trip_distance > 5 THEN 'Long Distance Zone'
        WHEN avg_trip_distance > 2 THEN 'Medium Distance Zone'
        ELSE 'Short Distance Zone'
    END AS distance_category
FROM {{ source('nyc_taxi', 'gold_location') }}
ORDER BY total_revenue DESC