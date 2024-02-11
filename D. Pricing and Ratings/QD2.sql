-- What if there was an additional $1 charge for any pizza extras?
-- Add cheese is $1 extra

WITH revenue AS (
	SELECT sub.order_id, pizza_id,
		SUM(CASE WHEN LENGTH(jt.extras) > 0 AND jt.extras != 'null' THEN 1 ELSE 0 END) AS extra_charges
	FROM (
		SELECT *, ROW_NUMBER() OVER() AS row_no FROM customer_orders
	)sub
	JOIN JSON_TABLE(REPLACE(JSON_ARRAY(extras),',','","'),
		'$[*]' COLUMNS (extras VARCHAR(30) PATH '$')) jt
	JOIN runner_orders ro
	ON sub.order_id = ro.order_id
	WHERE pickup_time != 'null'
	GROUP BY row_no, sub.order_id, pizza_id
)

SELECT CONCAT('$',SUM(CASE	WHEN pizza_id = 1 THEN 12 ELSE 10 END) + SUM(extra_charges)) AS total_revenue
FROM revenue