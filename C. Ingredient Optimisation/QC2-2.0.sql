-- What was the most commonly added extra?

WITH RECURSIVE unwound AS (
    SELECT order_id, extras
	FROM customer_orders
    UNION ALL
    SELECT order_id, regexp_replace(extras, '^[^,]*,', '') AS topping_id
	FROM unwound
	WHERE extras LIKE '%,%'
), my_cte AS (
	SELECT order_id, TRIM(regexp_replace(extras, ',.*', '')) AS topping_id
	FROM unwound
)

SELECT topping_name, COUNT(*) AS added
FROM my_cte
JOIN pizza_toppings pt
ON my_cte.topping_id = pt.topping_id
GROUP BY topping_name
ORDER BY added DESC
LIMIT 1