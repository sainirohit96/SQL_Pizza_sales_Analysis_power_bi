use pizza_sales;
select * from order_details;

# Retrieve the total number of orders placed.

SELECT DISTINCT
    COUNT(order_id) AS total_order_placed
FROM
    order_details;

# Calculate the total revenue generated from pizza sales.

SELECT 
    SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;

# Identify the highest-priced pizza.
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SELECT 
    pizza_types.name, MAX(pizzas.price) AS highest_priced_pizza
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

# Identify the most common pizza size ordered.
SELECT 
    pizzas.size, SUM(order_details.quantity) AS quantity
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

# List the top 5 most ordered pizza types along with their quantities.

SELECT 
    SUM(od.quantity) AS quantity, p.pizza_type_id, pt.name
FROM
    order_details AS od
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY 3
ORDER BY 1 DESC
LIMIT 5;