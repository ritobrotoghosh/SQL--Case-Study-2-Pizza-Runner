-- If Danny wants to expand his range of pizzas - how would this impact the existing data design? 
-- Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

INSERT INTO pizza_names VALUES
	(3, 'Supreme');
    
INSERT INTO pizza_recipes VALUES
	(3, (SELECT GROUP_CONCAT(topping_id) AS toppings FROM pizza_toppings));
    

    
