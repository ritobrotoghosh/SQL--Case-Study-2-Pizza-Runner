-- How many of each type of pizza was delivered?

SELECT co.pizza_id, pizza_name, COUNT(*) AS delivered
FROM customer_orders co
JOIN pizza_names pn
ON co.pizza_id = pn.pizza_id
JOIN runner_orders ro
ON co.order_id = ro.order_id
WHERE pickup_time != 'null'
GROUP BY pizza_id, pizza_name