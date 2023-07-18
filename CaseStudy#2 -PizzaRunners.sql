/*

How many pizzas were delivered that had both exclusions and extras?
What was the total volume of pizzas ordered for each hour of the day?
What was the volume of orders for each day of the week?*/ 

-- How many pizzas were ordered? 14

select count(*)
from customer_orders;

-- How many unique customer orders were made? 10

select count(distinct order_id)
from customer_orders;

-- How many successful orders were delivered by each runner? 1/4, 2/3, 3/1

select runner_id, count(runner_id) as delivery_count
from runner_orders
where pickup_time is not null
group by runner_id;

select *
from customer_orders;

-- How many of each type of pizza was delivered? 1/9, 2/3

select co.pizza_id, count(co.pizza_id)
from customer_orders co
join runner_orders ro on co.order_id = ro.order_id and ro.pickup_time is not null
group by co.pizza_id;

-- How many Vegetarian and Meatlovers were ordered by each customer?

select customer_id, pizza_id, count( pizza_id )
from customer_orders
group by customer_id, pizza_id
order by customer_id;

-- What was the maximum number of pizzas delivered in a single order? 3

select order_id, count(*) as pizza_count
from customer_orders
group by order_id
order by pizza_count desc;

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT
    co.customer_id,
    SUM(CASE WHEN co.exclusions <> '' OR co.extras <> '' THEN 1 ELSE 0 END) AS pizzas_with_changes,
    SUM(CASE WHEN co.exclusions = '' AND co.extras = '' THEN 1 ELSE 0 END) AS pizzas_with_no_changes
FROM
    customer_orders co
INNER JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    ro.cancellation IS NULL
GROUP BY
    co.customer_id;
    
    -- How many pizzas were delivered that had both exclusions and extras?

