-- Generate an order item for each record in the customers_orders table in the following format:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

DROP TABLE IF EXISTS customer_orders_reformed;

CREATE TEMPORARY TABLE customer_orders_reformed AS

SELECT row_no, order_id, customer_id, pizza_id, TRIM(jt1.exclusions) AS exclusions, TRIM(jt2.extras) AS extras
FROM (
SELECT *, ROW_NUMBER() OVER() AS row_no
FROM customer_orders
) sub
JOIN JSON_TABLE(REPLACE(JSON_ARRAY(exclusions),',','","'),
	'$[*]' COLUMNS (exclusions VARCHAR(30) PATH '$')) AS jt1
JOIN JSON_TABLE(REPLACE(JSON_ARRAY(extras),',','","'),
	'$[*]' COLUMNS (extras VARCHAR(30) PATH '$')) AS jt2;
    
WITH order_info AS (
	SELECT order_id, customer_id, cor.pizza_id, pizza_name, GROUP_CONCAT(DISTINCT pt1.topping_name) AS added_extras,
		GROUP_CONCAT(DISTINCT pt2.topping_name) AS excluded_items
	FROM customer_orders_reformed cor
	LEFT JOIN pizza_toppings pt1
	ON cor.extras = pt1.topping_id
	LEFT JOIN pizza_toppings pt2
	ON cor.exclusions = pt2.topping_id
    JOIN pizza_names pn
    ON cor.pizza_id = pn.pizza_id
	GROUP BY row_no, order_id, customer_id, pizza_id, pizza_name
)

SELECT order_id, order_item
FROM (
SELECT *,
	CASE 
		WHEN added_extras IS NULL AND excluded_items IS NULL THEN pizza_name
        WHEN added_extras IS NOT NULL AND excluded_items IS NULL THEN CONCAT(pizza_name,' - Extra - ', added_extras)
        WHEN added_extras IS NULL AND excluded_items IS NOT NULL THEN CONCAT(pizza_name,' - Exclude - ', excluded_items)
        ELSE CONCAT(pizza_name,'- Exclude - ', excluded_items,' - Extra - ', added_extras)        
	END AS order_item
FROM order_info
) sub