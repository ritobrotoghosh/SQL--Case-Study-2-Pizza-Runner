-- What are the standard ingredients for each pizza?

SELECT pr.pizza_id, pizza_name, GROUP_CONCAT(topping_name) AS ingredients
FROM pizza_recipes pr
JOIN JSON_TABLE(REPLACE(json_array(toppings),',','","'),
	'$[*]' COLUMNS (topping_id VARCHAR(30) PATH '$')) jt
JOIN pizza_toppings pt
ON TRIM(jt.topping_id) = pt.topping_id
JOIN pizza_names pn
ON pr.pizza_id = pn.pizza_id
GROUP BY pizza_id, pizza_name