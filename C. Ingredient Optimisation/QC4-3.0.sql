-- Generate an order item for each record in the customers_orders table in the following format:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

WITH extras AS (
	SELECT order_id, pizza_id, co.extras, GROUP_CONCAT(DISTINCT topping_name) AS added_extras
	FROM customer_orders co
	JOIN JSON_TABLE(REPLACE(JSON_ARRAY(extras),',','","'),
		'$[*]' COLUMNS (extra_toppings_id VARCHAR(30) PATH '$')) jt
	JOIN pizza_toppings pt
	ON TRIM(jt.extra_toppings_id) = pt.topping_id
	WHERE LENGTH(extra_toppings_id) > 0 AND extra_toppings_id != 'null'
	GROUP BY order_id, pizza_id, extras
),
excluded AS (
	SELECT order_id, pizza_id, co.exclusions, GROUP_CONCAT(DISTINCT topping_name) AS excluded_items
	FROM customer_orders co
	JOIN JSON_TABLE(REPLACE(JSON_ARRAY(exclusions),',','","'),
		'$[*]' COLUMNS (excluded_toppings_id VARCHAR(30) PATH '$')) jt
	JOIN pizza_toppings pt
	ON TRIM(jt.excluded_toppings_id) = pt.topping_id
	WHERE LENGTH(excluded_toppings_id) > 0 AND excluded_toppings_id != 'null'
	GROUP BY order_id, pizza_id, exclusions
)

SELECT co.order_id, 
	CONCAT(CASE WHEN pizza_name = 'Meatlovers' THEN 'Meat Lovers' ELSE 'Vegetarian' END, 
	IFNULL(CONCAT(' - Extra - ', added_extras),''), 
    IFNULL(CONCAT(' - Exclude - ', excluded_items),'')
    ) AS order_item
FROM customer_orders co
LEFT JOIN extras ext
ON co.order_id = ext.order_id AND co.pizza_id = ext.pizza_id AND co.extras = ext.extras
LEFT JOIN excluded exc
ON co.order_id = exc.order_id AND co.pizza_id = exc.pizza_id AND co.exclusions = exc.exclusions
JOIN pizza_names pn
ON co.pizza_id = pn.pizza_id