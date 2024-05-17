use pizza_sales;
select * from order_details;


--Retrieve the total number of orders placed.

SELECT DISTINCT
    COUNT(order_id) AS total_order_placed
FROM
    order_details;


--Calculate the total revenue generated from pizza sales.

SELECT 
    SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;


--Identify the highest-priced pizza.
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


--Identify the most common pizza size ordered.
SELECT 
    pizzas.size, SUM(order_details.quantity) AS quantity
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


--List the top 5 most ordered pizza types along with their quantities.

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


--Join the necessary tables to find the total quantity of each pizza category ordered.
Select sum(order_details.quantity) as quantity_ordered, pizza_types.category as category
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizzas.pizza_type_id =pizza_types.pizza_type_id
group by 2
order by 1 DESC;


--Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(time) AS hour, COUNT(order_id) AS count_order
FROM
    orders
GROUP BY 1
ORDER BY 2 DESC;


--Join relevant tables to find the category-wise distribution of pizzas.
SELECT DISTINCT
    COUNT(name), category
FROM
    pizza_types
GROUP BY 2;


--Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(pizza_count), 0) AS Average_pizza_per_day
FROM
    (SELECT 
        orders.date, SUM(order_details.quantity) AS pizza_count
    FROM
        order_details
    JOIN orders ON order_details.order_id = orders.order_id
    GROUP BY 1) AS order_quantity;


--Determine the top 3 most ordered pizza types based on revenue.

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


-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types.category,
    ROUND(((SUM(pizzas.price * order_details.quantity) * 100) / (SELECT 
                    SUM(order_details.quantity * pizzas.price) AS total_revenue
                FROM
                    order_details
                        JOIN
                    pizzas ON order_details.pizza_id = pizzas.pizza_id)),2)
                    AS Percent_contribution
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY 1
ORDER BY 2 DESC;


-- Analyze the cumulative revenue generated over time.

Select date ,round(sum(day_revenue) over (order by date),2) as cumulative_revenue 
from (
Select orders.date as date, round(sum(order_details.quantity* pizzas.price),2) as day_revenue
from orders
join order_details on orders.order_id = order_details.order_id
join pizzas on order_details.pizza_id = pizzas.pizza_id
group by orders.date) as sales ;


--Determine the top 3 most ordered pizza types based on revenue for each pizza category.

Select name, category,total_revenue
from
(Select name, category, total_revenue, 
rank() over(partition by category order by total_revenue DESC) as rk
from
(Select pizza_types.name, pizza_types.category , sum(pizzas.price*order_details.quantity) as total_revenue
from pizzas
join order_details on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by 1,2) as a) as b
where rk <= 3;
