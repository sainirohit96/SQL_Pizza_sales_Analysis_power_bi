# Calculate the percentage contribution of each pizza type to total revenue.

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

# Analyze the cumulative revenue generated over time.

Select date ,round(sum(day_revenue) over (order by date),2) as cumulative_revenue 
from (
Select orders.date as date, round(sum(order_details.quantity* pizzas.price),2) as day_revenue
from orders
join order_details on orders.order_id = order_details.order_id
join pizzas on order_details.pizza_id = pizzas.pizza_id
group by orders.date) as sales ;

# Determine the top 3 most ordered pizza types based on revenue for each pizza category.

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