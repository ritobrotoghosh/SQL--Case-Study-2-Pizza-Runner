-- What was the maximum number of pizzas delivered in a single order?

WITH my_cte AS (
	SELECT co.order_id, COUNT(*) AS pizzas, DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS d_rank
	FROM customer_orders co
	JOIN runner_orders ro
	ON co.order_id = ro.order_id
	WHERE pickup_time != 'null'
	GROUP BY order_id
)

SELECT pizzas
FROM my_cte
WHERE d_rank = 1