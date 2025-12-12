use e_commerce_db;

-- 1. List all customers who signed up in 2024.
select * from customers
	where year(signup_date) = 2024;

-- 2. Show the full name (first_name + last_name) and email of all customers from California.
select concat(first_name,' ' , last_name) as full_name, email from customers
	where state = 'California';

-- 3. Find all products that belong to the category 'Electronics' and sub_category 'Laptops'.
select * from products
	where category = 'Electronics' and sub_category = 'Laptops';

-- 4. Display the 10 most expensive products with their manufacturer and price.
select product_id, product_name, manufacturer, unit_price_usd from products 
	order by unit_price_usd desc
		limit 10;
        
-- 5. Show all orders placed on '2025-05-15' along with customer name, email and total amount.
select c.first_name, c.email, o.total_amount, o.order_date from orders o
	left join customers c
	on o.customer_id = c.customer_id
	where order_date = '2025-05-15';

-- 6. How many customers are there per state? Show state and count, ordered descending.
select state, count(customer_id) as no_of_customers from customers
	group by state
    order by no_of_customers desc;

-- 7. What is the average order total_amount for completed orders (status = 'completed')?
select round(avg(total_amount),2) as  avg_amount from orders
	where status = 'Completed';

-- 8. List the top 5 customers by total money spent .
select customer_id , sum(total_amount) as total_spent from orders
	group by customer_id
    order by total_spent desc limit 5;

-- 9. Find all products that have never been ordered.
select p.* from  products p
	left join order_items i on
    p.product_id = i.product_id
    where p.product_id is null;

-- 10. Show monthly signup trend: number of customers who signed up each month in 2024 and 2025.
select date_format(signup_date, '%Y-%m') as yr_month, count(customer_id)  from customers
	group by yr_month
	order by yr_month;
    
-- 11. For each order, show order_id, order_date, customer full name, and email.
select o.order_id, o.order_date, concat(c.first_name,' ', c.last_name) as full_name, c.email
 from orders o
	left join customers c
    on o.customer_id = c.customer_id
    order by order_date;
    
-- 12. List all order items with order_id, product_name, quantity, unit_price_usd, and line_total.
select i.order_id, p.product_name,i.quantity, i.unit_price_usd, i.line_total from order_items i 
	left join products p 
    on i.product_id = p.product_id;
    
-- 13. Find customers who placed more than 1 orders in June 2025.
select customer_id, count(order_id) as no_of_orders from orders
	where date_format(order_date, '%Y-%m') = '2025-06'
	group by customer_id
    having  no_of_orders >=2;

-- 14. Show the most popular product (highest total quantity sold) and how many units were sold.
select i.product_id, product_name, sum(quantity) total_sold from order_items i
	join products p on i.product_id = p.product_id
	group by product_id, product_name
    order by total_sold desc
		limit 1;

-- 15. Display customers (customer_id, full name, email, product_name) who bought any product from the sub_category 'Laptops'.
select distinct c.customer_id, concat(c.first_name, ' ', c.last_name) as full_name, c.email, p.product_name
	from customers c join orders o 
    on c.customer_id = o.customer_id
	join order_items i
    on o.order_id = i.order_id
    join products p 
    on i.product_id = p.product_id
    where p.sub_category = 'Laptops';

-- 16. Rank customers by total spending in 2025 using RANK() or DENSE_RANK().
select *,
	dense_rank() over(order by total_spending desc) as customer_rank
    from (
select customer_id, sum(total_amount) as total_spending from orders
    where year(order_date) = 2025
    group by customer_id) t;

-- 17. Find customers whose very first order total_amount was above $500.
select t.customer_id, c.first_name, c.last_name, t.total_amount from 
	customers c join 
	(
select customer_id, total_amount,
	dense_rank() over(partition by customer_id order by order_date) as ranking
 from orders) t on c.customer_id = t.customer_id
 where t.ranking =1 and t.total_amount > 500;

-- 18. Show running total of daily sales (total_amount) in June 2025, ordered by date.
with cte as (
	select order_date, sum(total_amount) as daily_revenue from orders
		group by order_date
		order by order_date)
select *,
	sum(daily_revenue) over(order by order_date) as running_total
		from cte;    
    
-- 19. List the top 3 best-selling products per category.
select * from (
select t.category, t.product_id, t.total_sale,
	dense_rank() over(partition by category order by total_sale desc) as rnk
from (
select p.category, i.product_id, sum(i.line_total) as total_sale from order_items i
	join products p 
    on i.product_id = p.product_id
		group by p.category, i.product_id) t ) tt
        where tt.rnk < 4;
       
    
-- 20.Find customers who placed an order within 7 days of signing up.
select distinct c.customer_id, c.first_name, c.last_name, c.signup_date, o.order_id, o.order_date from customers c 
	join orders o
    on c.customer_id = o.customer_id 
    where datediff(o.order_date, c.signup_date) between 0 and 7;
    

    
