-- Is there any relationship between the number of pizzas and how long the order takes to prepare?

WITH my_cte AS (
	SELECT order_id, minutes, COUNT(*) as pizzas
	FROM (
		SELECT co.order_id, TIMESTAMPDIFF(MINUTE, order_time, CAST(pickup_time AS DATETIME)) AS minutes
		FROM customer_orders co
		JOIN runner_orders ro
		ON co.order_id = ro.order_id
		WHERE pickup_time!= 'null'
        ) sub
	GROUP BY order_id, minutes
)

SELECT pizzas, ROUND(AVG(minutes)) AS time_taken
FROM my_cte
GROUP BY pizzas