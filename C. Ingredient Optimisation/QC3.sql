-- What was the most common exclusion?

SELECT TRIM(excluded_toppings_id) AS excluded_toppings_id, topping_name, COUNT(*) AS n
FROM customer_orders
JOIN JSON_TABLE(REPLACE(JSON_ARRAY(exclusions),',','","'),
	'$[*]' COLUMNS (excluded_toppings_id VARCHAR(30) PATH '$')) jt
JOIN pizza_toppings pt
ON TRIM(jt.excluded_toppings_id) = pt.topping_id
WHERE LENGTH(excluded_toppings_id) > 0 AND excluded_toppings_id != 'null'
GROUP BY excluded_toppings_id, topping_name
ORDER BY n DESC
LIMIT 1