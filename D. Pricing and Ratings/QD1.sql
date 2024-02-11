-- If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
-- how much money has Pizza Runner made so far if there are no delivery fees?

SELECT CONCAT('$',
	SUM(CASE
		WHEN pizza_id = 1 THEN 12
        ELSE 10
	END)) AS total_revenue
FROM customer_orders co
JOIN runner_orders ro
ON co.order_id = ro.order_id
WHERE pickup_time != 'null'