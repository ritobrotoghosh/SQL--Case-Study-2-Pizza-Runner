-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

WITH my_cte AS (
	SELECT runner_id,
		CASE
			WHEN day_diff < 7 THEN 'Week 1'
			WHEN day_diff >= 7 AND day_diff < 14 THEN 'Week 2'
			ELSE 'Week 3'
		END AS weeks
	FROM (
		SELECT *, DATEDIFF(registration_date, '2021-01-01') AS day_diff
		FROM runners
	) sub
)

SELECT weeks, COUNT(*) AS registrations
FROM my_cte
GROUP BY weeks