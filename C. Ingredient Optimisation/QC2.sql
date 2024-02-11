-- What was the most commonly added extra?

SELECT TRIM(extra_toppings_id) AS extra_toppings_id, topping_name, COUNT(*) AS n
FROM customer_orders
JOIN JSON_TABLE(REPLACE(JSON_ARRAY(extras),',','","'),
	'$[*]' COLUMNS (extra_toppings_id VARCHAR(30) PATH '$')) jt
JOIN pizza_toppings pt
ON TRIM(jt.extra_toppings_id) = pt.topping_id
WHERE LENGTH(extra_toppings_id) > 0 AND extra_toppings_id != 'null'
GROUP BY extra_toppings_id, topping_name
ORDER BY n DESC
LIMIT 1