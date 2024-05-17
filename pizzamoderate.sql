# Join the necessary tables to find the total quantity of each pizza category ordered.
Select sum(order_details.quantity) as quantity_ordered, pizza_types.category as category
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizzas.pizza_type_id =pizza_types.pizza_type_id
group by 2
order by 1 DESC;

# Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(time) AS hour, COUNT(order_id) AS count_order
FROM
    orders
GROUP BY 1
ORDER BY 2 DESC;

# Join relevant tables to find the category-wise distribution of pizzas.
SELECT DISTINCT
    COUNT(name), category
FROM
    pizza_types
GROUP BY 2;

# Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(pizza_count), 0) AS Average_pizza_per_day
FROM
    (SELECT 
        orders.date, SUM(order_details.quantity) AS pizza_count
    FROM
        order_details
    JOIN orders ON order_details.order_id = orders.order_id
    GROUP BY 1) AS order_quantity;

# Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pizza_types.name,
    SUM(pizzas.price * order_details.quantity) AS total_revenue
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;