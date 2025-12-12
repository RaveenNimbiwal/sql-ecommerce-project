use e_commerce_db;

-- 1. Show total sales amount for each month in 2025.
select date_format(order_date, '%Y-%m') as month_, sum(total_amount) as total_sales from orders
	where year(order_date) = 2025
    group by month_
    order by month_ ;

-- 2. How many new customers signed up each month in 2025?
select month(signup_date) as month_, count(customer_id) total_signup from customers
	where year(signup_date) = 2025
    group by month_
    order by month_;

-- 3. What is the average amount spent per order in 2025? Also show it month by month.
select month(order_date) as month_, round(avg(total_amount), 2) as  monthly_avg_amount,
	round((select avg(total_amount) from orders where year(order_date) = 2025),2) as avg_amount
	from orders 
    where year(order_date) = 2025
    group by month_
    order by month_;
	
-- 4. Which payment methods do people use the most? Show number of orders and total money for each.
select payment_method, count(order_id) as no_of_orders , sum(total_amount) as total_sale from orders
		group by payment_method;

-- 5. List the 10 products that made the most money in 2025, with their name and category.
select p.category, p.product_name, sum(i.line_total) as total_sale from order_items i
	join orders o 
    on i.order_id = o.order_id
    join products p
    on i.product_id = p.product_id
    where year(order_date) = 2025
    group by p.category, p.product_name
    order by total_sale desc limit 10 ;
    
-- 6. Which product categories made the most money? Show the money amount and percentage of total.
select p.category, sum(line_total) as total_sale_cat,
	round(100 * sum(line_total) /(select sum(line_total) from order_items),2) as percentage
 from order_items i 
	join products p 
    on i.product_id = p.product_id
    group by p.category;

-- 7. How many customers have bought more than one time?
select count(customer_id) from (
select customer_id, count(order_id) as no_of_orders from orders
	group by customer_id
    having no_of_orders > 1) t;

-- 8. On average, how many days pass between a customer signing up and placing their first order?
with cte as(    select customer_id, min(order_date) as first_order_date from orders 
		group by customer_id)
select  round(avg(datediff(cte.first_order_date, c.signup_date )),0) as avg_day from customers c
	join cte  
	on c.customer_id = cte.customer_id;

-- 9. Which 5 states have the most customers? And which 5 states spent the most money?
	select c.state, count(c.customer_id) no_of_customers from customers c
    left join orders o 
    on c.customer_id = o.customer_id
    group by c.state 
    order by no_of_customers desc limit 5;
    
    select c.state, sum(o.total_amount) total_spent from customers c
    join orders o 
    on c.customer_id = o.customer_id
    group by c.state 
    order by total_sale desc limit 5;
    
-- 10. List customers who spent more than $1000 in total, with their name and email.
	select concat(c.first_name,' ',c.last_name) as full_name, email, sum(total_amount) total_spent From orders o 
    join customers c on 
    o.customer_id = c.customer_id
		group by  email, full_name
        having total_spent > 1000
        order by total_spent desc;

-- 11. Show how sales changed from one month to the next in 2025 (percentage increase or decrease).
with cte as (
select date_format(order_date, '%Y-%m') as month_, sum(total_amount) as total_sale
	from orders
    where year(order_date) = 2025
    group by month_)
select month_, total_sale, previous_month, 
	100 * (total_sale - previous_month) / previous_month as percentage_change
    from(
	select month_, total_sale,
		nullif(lag(total_sale) over(order by month_), 0) as previous_month
		from cte
		order by month_) t;

-- 12. Who are the top 5 customers who spent the most in 2025? Show their first and last order dates too.
select customer_id, sum(total_amount) as total_bought, min(order_date) as first_order_date ,max(order_date) as last_order_date from orders
	where year(order_date) = 2025
	group by customer_id
    order by total_bought desc limit 5;
    
-- 13. In each category, show the top 3 products by number of units sold.
select *
 from 
(select p.category, p.product_id, product_name, sum(quantity) as total_unit_sold,
	dense_rank() over(partition by category order by sum(quantity) desc ) as cat_rank
	from order_items i
	join products p
    on i.product_id = p.product_id
    group by p.category, p.product_id, product_name) t
    where cat_rank <=3;

-- 14. Find products that no one bought in the last 90 days.
select p.product_id, p.product_name, max(order_date) as last_date from products p
	left join order_items i 
		on p.product_id = i.product_id
	left join orders o 
		on i.order_id = o.order_id
	group by p.product_id, p.product_name
		having max(order_date) < current_date() - interval 90 day
		or last_date is null;

-- 15. Find customers who bought before but not in the last 60 days — they might stop buying.
select c.customer_id, concat(c.first_name, ' ', coalesce (c.last_name,'')) as full_name ,max(order_date)  as last_date from customers c
	join orders o
    on c.customer_id = o.customer_id
    group by c.customer_id, full_name
    having max(order_date) < current_date() - interval 60 day;
    
    
-- 16. Which day of the week has the most sales money and the most orders?
	select dayname(order_date) day_of_week , sum(total_amount) as total_sale, count(order_id) as no_of_orders
		from orders 
			group by day_of_week 
            order by total_sale desc, no_of_orders desc;

-- 17. In each category, show the top 3 products by number of units sold.
select *
 from 
(select p.category, p.product_id, product_name, sum(quantity) as total_unit_sold,
	dense_rank() over(partition by category order by sum(quantity) desc ) as cat_rank
	from order_items i
	join products p
    on i.product_id = p.product_id
    group by p.category, p.product_id, product_name) t
    where cat_rank <=3;


    
    



