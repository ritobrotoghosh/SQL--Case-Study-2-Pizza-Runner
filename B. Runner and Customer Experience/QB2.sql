-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT runner_id, ROUND(AVG(TIMESTAMPDIFF(MINUTE, order_time, pickup_time)),2) AS average_time
FROM customer_orders co
JOIN runner_orders ro
ON co.order_id = ro.order_id
WHERE pickup_time != 'null'
GROUP BY runner_id