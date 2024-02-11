-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT customer_id,
	CASE
		WHEN (LENGTH(exclusions)>0 AND exclusions != 'null') OR (LENGTH(extras)>0 AND extras != 'null') = 1 THEN 'True' 
        ELSE 'False'
	END AS changes,
    COUNT(*) AS pizza_count
FROM customer_orders co
JOIN runner_orders ro
ON co.order_id = ro.order_id
WHERE pickup_time != 'null'
GROUP BY 1,2
ORDER BY 1