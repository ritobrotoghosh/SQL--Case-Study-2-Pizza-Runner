-- Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table 
-- and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

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
),
summary AS (
	SELECT order_id, pizza_id, pizza_name,
		GROUP_CONCAT(
		CASE
			WHEN n > 1 THEN CONCAT(n, 'x', topping_name)
			ELSE topping_name
		END) AS ingredients
	FROM (
		SELECT row_no, order_id, ow.pizza_id, pizza_name, topping_name, COUNT(*) AS n
		FROM orders_with_extras_and_exclusions ow
		JOIN pizza_names pn
		ON ow.pizza_id = pn.pizza_id
		GROUP BY row_no, order_id, pizza_id, pizza_name, topping_name
		ORDER BY order_id, pizza_id, topping_name
	) sub
	GROUP BY row_no, order_id, pizza_id, pizza_name
)

SELECT order_id, 
	CASE
		WHEN pizza_id = 1 THEN CONCAT('Meat Lovers',': ', ingredients) 
        ELSE CONCAT('Vegetarian',': ', ingredients)
	END AS ingredients_list
FROM summary