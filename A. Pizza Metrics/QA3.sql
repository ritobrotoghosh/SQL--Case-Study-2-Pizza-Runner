-- How many successful orders were delivered by each runner?

SELECT runner_id, COUNT(*) AS delivered
FROM runner_orders
WHERE pickup_time != 'null'
GROUP BY runner_id