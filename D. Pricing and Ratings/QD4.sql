-- Using your newly generated table 
-- can you join all of the information together to form a table which has the following information for successful deliveries?
-- customer_id
-- order_id
-- runner_id
-- rating
-- order_time
-- pickup_time
-- Time between order and pickup
-- Delivery duration
-- Average speed
-- Total number of pizzas


SELECT *, COUNT(*) AS number_of_pizzas
FROM (
	SELECT customer_id, co.order_id, runner_id, ratings, order_time, pickup_time,
		TIMESTAMPDIFF(MINUTE, order_time, pickup_time) AS time_taken_in_min,
		CAST(REGEXP_REPLACE(duration,'[a-z]+','') AS UNSIGNED) AS delivery_duration_in_min,
		ROUND(CAST(REGEXP_REPLACE(distance,'[a-z]+','') AS FLOAT) * 60 / CAST(REGEXP_REPLACE(duration,'[a-z]+','') AS UNSIGNED), 2)  AS speed_in_kmph
	FROM customer_orders co
	JOIN runner_orders ro
	ON co.order_id = ro.order_id
	JOIN runner_ratings rat
	ON ro.order_id = rat.order_id
) sub
GROUP BY customer_id, co.order_id, runner_id, ratings, order_time, pickup_time, time_taken_in_min, delivery_duration_in_min, speed_in_kmph