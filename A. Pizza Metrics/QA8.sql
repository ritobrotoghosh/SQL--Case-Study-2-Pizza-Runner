-- How many pizzas were delivered that had both exclusions and extras?

SELECT COUNT(*) AS pizzas
FROM (
	SELECT *
	FROM customer_orders
	WHERE order_id IN (SELECT order_id FROM runner_orders	WHERE pickup_time != 'null')
) sub
WHERE exclusions NOT IN ('', 'null') AND extras NOT IN ('', 'null')

