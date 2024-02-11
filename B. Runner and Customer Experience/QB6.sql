-- What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT runner_id, order_id,
	ROUND(AVG((CAST(REPLACE(distance, 'km', '') AS DECIMAL(3,1))/
    (CAST(REGEXP_REPLACE(duration, '[^0-9]', '') AS UNSIGNED)/60))),2) AS "speed (km/hr)"
FROM runner_orders
WHERE pickup_time != 'null'
GROUP BY runner_id, order_id
ORDER BY runner_id, order_id