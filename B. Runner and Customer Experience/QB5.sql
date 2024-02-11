-- What was the difference between the longest and shortest delivery times for all orders?

SELECT 
	MAX(CAST(REGEXP_REPLACE(duration, '[^0-9]', '') AS UNSIGNED))
    - MIN(CAST(REGEXP_REPLACE(duration, '[^0-9]', '') AS UNSIGNED)) AS difference
FROM runner_orders
WHERE pickup_time != 'null'