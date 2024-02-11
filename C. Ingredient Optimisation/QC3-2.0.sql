-- What was the most common exclusion?

WITH RECURSIVE unwound AS (
    SELECT order_id, exclusions
	FROM customer_orders
    UNION ALL
    SELECT order_id, TRIM(regexp_replace(exclusions, '^[^,]*,', '')) AS topping_id
	FROM unwound
	WHERE exclusions LIKE '%,%'
), my_cte AS (
	SELECT order_id, TRIM(regexp_replace(exclusions, ',.*', '')) AS topping_id
	FROM unwound
)

SELECT topping_name, COUNT(*) AS excluded
FROM my_cte
JOIN pizza_toppings pt
ON my_cte.topping_id = pt.topping_id
GROUP BY topping_name
ORDER BY excluded DESC
LIMIT 1