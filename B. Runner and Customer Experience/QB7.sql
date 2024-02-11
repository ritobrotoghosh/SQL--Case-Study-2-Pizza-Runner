-- What is the successful delivery percentage for each runner?

SELECT runner_id,
	SUM(CASE WHEN pickup_time = 'null' THEN 0 ELSE 1 END)/COUNT(CASE WHEN pickup_time = 'null' THEN 0 ELSE 1 END) * 100
    AS percentage
FROM runner_orders
GROUP BY runner_id
