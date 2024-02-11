-- If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras 
-- and each runner is paid $0.30 per kilometre traveled 
-- how much money does Pizza Runner have left over after these deliveries?


SELECT CONCAT('$', ROUND(SUM(price_per_order - (distance * 0.30)),2)) AS actual_revenue
FROM (
	SELECT co.order_id, CAST(REGEXP_REPLACE(distance,'[a-z]+','') AS FLOAT) AS distance,
		SUM(CASE WHEN pizza_id = 1 THEN 12 ELSE 10 END) AS price_per_order
	FROM customer_orders co
	JOIN runner_orders ro
	ON co.order_id = ro.order_id
	WHERE pickup_time != 'null'
    GROUP BY order_id, distance
) sub