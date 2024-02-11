-- What was the volume of orders for each day of the week?

SELECT DAYOFWEEK(order_time) AS day_number, DAYNAME(order_time) AS day_of_week, 
	COUNT(*) AS ordered
FROM customer_orders
GROUP BY DAYOFWEEK(order_time), DAYNAME(order_time)
ORDER BY day_number
