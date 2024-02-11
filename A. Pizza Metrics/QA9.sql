-- What was the total volume of pizzas ordered for each hour of the day?

SELECT hours, COUNT(*) AS ordered
FROM (
	SELECT order_id, EXTRACT(HOUR FROM order_time) AS hours
	FROM customer_orders
) sub
GROUP BY hours
ORDER BY hours