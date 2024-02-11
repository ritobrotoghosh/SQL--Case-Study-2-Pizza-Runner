-- What are the standard ingredients for each pizza?

WITH RECURSIVE unwound AS (
    SELECT *
	FROM pizza_recipes
    UNION ALL
    SELECT pizza_id, TRIM(regexp_replace(toppings, '^[^,]*,', '')) AS topping_id
	FROM unwound
	WHERE toppings LIKE '%,%'
  ), my_cte AS (
	SELECT pizza_id, TRIM(regexp_replace(toppings, ',.*', '')) AS topping_id
	FROM unwound
)

SELECT pn.pizza_id, pizza_name, GROUP_CONCAT(topping_name) AS toppings
FROM my_cte
JOIN pizza_toppings pt
ON my_cte.topping_id = pt.topping_id
JOIN pizza_names pn
ON my_cte.pizza_id = pn.pizza_id
GROUP BY pizza_id, pizza_name
