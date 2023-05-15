 -- 1. What is the total amount each customer spent at the restaurant?

Select s.customer_id,
sum(price) as total_amount
From sales s 
join menu m on s.product_id=m.product_id
group by s.customer_id;

-- 2. How many days has each customer visited the restaurant?

Select s.customer_id, count(distinct order_date) as visited_days
From sales s 
join menu m on s.product_id=m.product_id
group by s.customer_id;

-- 3. What was the first item from the menu purchased by each customer?

with cte_order_date as
(Select s.customer_id, m.product_id, order_date,
rank() over(partition by customer_id order by order_date) as rn
From sales s 
join menu m on s.product_id=m.product_id)
select customer_id, product_id, order_date
from cte_order_date
where rn=1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- product_id	product_name	purchase_count
--		3			ramen			8

select top 1 s.product_id, m.product_name,
count(s.product_id) as purchase_count
From sales s 
join menu m on s.product_id=m.product_id
group by s.product_id, m.product_name
order by purchase_count desc

-- 5. Which item was the most popular for each customer?

with cte_product_purchase_cnt as
		 (select s.customer_id, m.product_id, m.product_name,
		count(product_name) over(partition by s.customer_id, s.product_id ) as product_purchase_cnt
		From sales s 
		join menu m on s.product_id=m.product_id)
select *
from (select *,
rank() over (partition by customer_id order by product_purchase_cnt desc) rn
from cte_product_purchase_cnt) t
where t.rn = 1

-- 6. Which item was purchased first by the customer after they became a member?

select s.customer_id, s.product_id, s.order_date, m.join_date 
from sales s join members m on m.customer_id=s.customer_id
where m.join_date < s.order_date

-- 7. Which item was purchased just before the customer became a member?

select p.product_id, min(p.order_date) 
from (
select s.customer_id, s.product_id, s.order_date, m.join_date 
from sales s join members m on m.customer_id=s.customer_id
where m.join_date > s.order_date
) p
group by p.product_id

-- 8. What is the total items and amount spent for each member before they became a member?

select s.customer_id, count(s.product_id) as count, sum(mm.price) as order_price
from sales s right join members m on m.customer_id=s.customer_id
and m.join_date > s.order_date
join menu mm on mm.product_id = s.product_id
group by s.customer_id

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

Select
customer_id,
sum(case when m.product_name = 'sushi' then m.price * 20 else m.price * 10 end) as points
From sales s 
join menu m on s.product_id=m.product_id
group by customer_id

-- 10. In the first week after a customer joins the program (including their join date) 
-- they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?







