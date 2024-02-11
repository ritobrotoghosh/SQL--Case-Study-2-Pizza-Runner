-- What was the average distance travelled for each customer?

SELECT customer_id, ROUND(AVG(CAST(REPLACE(distance,'km','') AS DECIMAL(3,1))),2) AS "average_distance(km)"
FROM runner_orders ro
JOIN customer_orders co
ON ro.order_id = co.order_id
WHERE pickup_time != 'null'
GROUP BY customer_id