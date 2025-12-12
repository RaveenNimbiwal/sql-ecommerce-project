-- Baisc SQL practice Questions_Answers
use e_commerce_db;

select * From customers;
select * from products;
select * from orders;
select * From order_items;

-- 1. List all the customers from a Texas
select * from customers
	where state = 'Texas';
    
-- 2. Count total number of products in each category.
select category, count(product_id) from products
	group by category;

-- 3. Show the total number of orders placed in your dataset.
select count(order_id) from orders;

-- 4. Find the earliest and latest order dates.
select min(order_date) as earliest_date, max(order_date) as latest_date from  orders;

-- 5. List all orders placed by customer ID 'F-7857'.
select * From orders
	where customer_id = 'F-7857';

-- 6. Find the total number of orders per customer.
select customer_id, count(order_id) as total_orders from orders
	group by customer_id
    order by total_orders desc;

-- 7. Calculate total revenue (sum of total_amount).
select sum(total_amount) from orders;

-- 8. Show top 5 customers by total spending.
select customer_id, sum(total_amount) as total_spending from orders
	group by customer_id
    order by total_spending desc limit 5;
    
-- 9. Find the total quantity sold for each product.
select p.product_name, sum(i.quantity) as total_quantity from products p
	left join order_items i 
    on p.product_id = i.product_id
		group by p.product_name
		order by total_quantity desc;
        
-- 10. Calculate average order value.
select avg(total_amount) from orders;

-- 11. Show total revenue per category.
select p.category, sum(line_total) from order_items i 
	left join products p 
    on i.product_id = p.product_id
		group by p.category;
	
    
    
-- 12. For each state, show how many customers you have.
select state, count(customer_id) as no_of_customers from customers
	group by state
    order by no_of_customers desc;

-- 13. Find the total number of items in each order.
select o.order_id, sum(quantity) as total_items from orders o
	left join order_items i
	on o.order_id = i.order_id
		group by o.order_id
        order by total_items desc;

-- 14. Find the top 5 best-selling products.
select product_id, sum(quantity) as total_items from order_items
	group by product_id
	order by total_items desc
    limit 5;

-- 15. Show the monthly revenue (year-month + revenue).
select year(order_date) as year_, month(order_date) as month_, sum(total_amount) as revenue
	from orders 
	group by year_, month_
		order by year_ asc, month_ asc;        
    
-- 16. Which month had the highest sales.
select date_format(order_date, '%Y-%m') as yr_month, sum(total_amount) as total_sale
	from orders 
	group by yr_month
		order by total_sale desc
		limit 1; 
		
-- 17. Count number of orders per month.
select date_format(order_date, '%Y-%m') as yr_month, count(order_id) as total_orders
	from orders 
    group by yr_month
		order by yr_month asc;
        
-- 18. Find new customers added per month.
select date_format(signup_date, '%Y-%m') as yr_month, count(customer_id) as no_of_customers
	from customers group by yr_month;

-- 19. Show how many orders were placed in the last 30 days.
select * from orders
	where order_date >= (curdate() - interval 30 day);
    
-- 20. Which month had the third highest sales.
select date_format(order_date, '%Y-%m') as yr_month, sum(total_amount) as total_sale
	from orders 
	group by yr_month
		order by total_sale desc
		limit 2,1; 
