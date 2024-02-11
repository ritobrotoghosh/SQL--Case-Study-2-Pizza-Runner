WITH RECURSIVE my_cte AS (
	SELECT order_id, customer_id, pizza_id, order_time, exclusions, extras, ROW_NUMBER() OVER() AS row_no
    FROM customer_orders
    UNION ALL
    SELECT order_id, customer_id, pizza_id, order_time, regexp_replace(exclusions, '^[^,]*,', ''),
		regexp_replace(extras, '^[^,]*,', ''), row_no
    FROM my_cte
    WHERE (exclusions LIKE '%,%') OR (extras LIKE '%,%')
),
ungrouped_orders AS (
	SELECT order_id, customer_id, pizza_id, order_time, TRIM(regexp_replace(exclusions, ',.*', '')) AS exclusions, 
	TRIM(regexp_replace(extras, ',.*', '')) AS extras, row_no
	FROM my_cte
), 
orders AS (
	SELECT order_id, customer_id, uo.pizza_id, pizza_name, GROUP_CONCAT(DISTINCT pt1.topping_name) AS added, GROUP_CONCAT(DISTINCT pt2.topping_name) AS excluded
	FROM ungrouped_orders uo
	LEFT JOIN pizza_toppings pt1
	ON uo.extras = pt1.topping_id
	LEFT JOIN pizza_toppings pt2
	ON uo.exclusions = pt2.topping_id
	JOIN pizza_names pn
	ON uo.pizza_id = pn.pizza_id
	GROUP BY row_no, order_id, customer_id, pizza_id, pizza_name
)

SELECT order_id, customer_id, order_item
FROM (
	SELECT *,
		CASE 
			WHEN added IS NULL AND excluded IS NULL THEN pizza_name
			WHEN added IS NOT NULL AND excluded IS NULL THEN CONCAT(pizza_name,', Extra - ', added)
			WHEN added IS NULL AND excluded IS NOT NULL THEN CONCAT(pizza_name,', Exclude - ', excluded)
			ELSE CONCAT(pizza_name,', Exclude - ', excluded,', Extra - ', added)        
		END AS order_item
	FROM orders
) sub