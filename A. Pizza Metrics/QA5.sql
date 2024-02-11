-- How many Vegetarian and Meatlovers were ordered by each customer?

SELECT customer_id, pizza_name, COUNT(*) AS ordered
FROM customer_orders co
JOIN pizza_names pn
ON co.pizza_id = pn.pizza_id
GROUP BY customer_id, pizza_name
ORDER BY customer_id