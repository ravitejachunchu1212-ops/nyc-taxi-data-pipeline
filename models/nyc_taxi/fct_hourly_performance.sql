{{ config(materialized='table') }}
SELECT hour_of_day, 
CASE 
    WHEN hour_of_day BETWEEN 6 AND 11 THEN 'Morning'
    WHEN hour_of_day BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN hour_of_day BETWEEN 18 AND 22 THEN 'Evening'
    ELSE 'Night'
    END AS time_of_day,
    total_trips,
    total_amount AS total_revenue,
    avg_trip_duration,
    avg_tip,
    ROUND(total_amount / total_trips, 2) AS revenue_per_trip,
    CASE 
        WHEN avg_tip > 3 THEN 'High Tip Hour'
        WHEN avg_tip > 1.5 THEN 'Medium Tip Hour'
        ELSE 'Low Tip Hour'
    END AS tip_category,
     CASE
        WHEN total_trips > 10000 THEN 'Peak Hour'
        WHEN total_trips > 5000 THEN 'Busy Hour'
        ELSE 'Quiet Hour'
    END AS demand_category
FROM {{ source('nyc_taxi', 'gold_hourly') }}
ORDER BY total_trips DESC