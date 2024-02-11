DROP TABLE IF EXISTS runner_ratings;

CREATE TABLE runner_ratings (
	order_id INTEGER, 
	ratings INTEGER, 
    feedback VARCHAR(100)
);

-- Order 6 and 9 were cancelled

INSERT INTO runner_ratings VALUES
	(1, 1, 'Poor service'),
	(2, 1, NULL),
	(3, 4, 'Took too long...'),
	(4, 1,'Runner got lost, delivered it AFTER an hour. Pizza arrived cold' ),
    (5, 2, 'Good service'),
	(7, 5, 'It was great, good service and fast'),
	(8, 2, 'He left it on the doorstep, poor service'),
    (10, 5, 'Delicious!, fast delivery!');


SELECT *
FROM runner_ratings;