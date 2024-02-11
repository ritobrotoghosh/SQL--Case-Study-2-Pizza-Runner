-- How many unique customer orders were made?

SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM customer_orders
