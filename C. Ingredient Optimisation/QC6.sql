-- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

WITH extras AS (
	SELECT row_no, order_id, pizza_id, extras, TRIM(jt.extra_toppings_id) AS extra_toppings, topping_name
	FROM (
	SELECT *, ROW_NUMBER() OVER() AS row_no FROM customer_orders
	) sub
	JOIN JSON_TABLE(REPLACE(JSON_ARRAY(extras),',','","'),
		'$[*]' COLUMNS (extra_toppings_id VARCHAR(30) PATH '$')) jt
	JOIN pizza_toppings pt
	ON TRIM(jt.extra_toppings_id) = pt.topping_id
	WHERE LENGTH(extra_toppings_id) > 0 AND extra_toppings_id != 'null'
),
excluded AS (
	SELECT row_no, order_id, pizza_id, exclusions, TRIM(jt.excluded_toppings_id) AS excluded_toppings_id, topping_name
	FROM (
	SELECT *, ROW_NUMBER() OVER() AS row_no FROM customer_orders
	) sub
	JOIN JSON_TABLE(REPLACE(JSON_ARRAY(exclusions),',','","'),
		'$[*]' COLUMNS (excluded_toppings_id VARCHAR(30) PATH '$')) jt
	JOIN pizza_toppings pt
	ON TRIM(jt.excluded_toppings_id) = pt.topping_id
	WHERE LENGTH(excluded_toppings_id) > 0 AND excluded_toppings_id != 'null'
),
orders AS (
	SELECT row_no, order_id, sub.pizza_id, exclusions, extras, TRIM(jt.topping_id) AS topping_id, topping_name
    FROM (
	SELECT *, ROW_NUMBER() OVER() AS row_no FROM customer_orders
	) sub
    JOIN pizza_recipes pr
    ON sub.pizza_id = pr.pizza_id
    JOIN JSON_TABLE(REPLACE(JSON_ARRAY(toppings),',','","'),
		'$[*]' COLUMNS (topping_id VARCHAR(30) PATH '$')) jt
	JOIN pizza_toppings pt
    ON TRIM(jt.topping_id) = pt.topping_id
),
orders_with_extras_and_exclusions AS (
	SELECT o.row_no, o.order_id, o.pizza_id, o.topping_name
	FROM orders o
	LEFT JOIN excluded exc
	ON o.order_id = exc.order_id AND o.pizza_id = exc.pizza_id AND o.topping_id = exc.excluded_toppings_id AND
		o.row_no = exc.row_no
	WHERE excluded_toppings_id IS NULL

	UNION ALL

	SELECT row_no, order_id, pizza_id, topping_name
	FROM extras ext
)

SELECT topping_name, COUNT(*) AS quantity
FROM orders_with_extras_and_exclusions ow
JOIN runner_orders ro
ON ow.order_id = ro.order_id
WHERE pickup_time != 'null'
GROUP BY topping_name
ORDER BY quantity DESC