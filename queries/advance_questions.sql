-- Advanced Questions practice
use e_commerce_db;

-- 21. Find repeat customers (customers with more than 1 order).
select customer_id, no_of_orders from (
	select customer_id, count(order_id) as no_of_orders from orders
		group by customer_id ) t
		where no_of_orders > 1;

-- 22. Calculate customer lifetime value (total spent per customer).
select customer_id, sum(total_amount) as total_spent from orders
	group by customer_id;

-- 23. For each customer, calculate average items per order.
select o.customer_id, sum(quantity)/count(distinct(o.order_id)) as avg_item_order from orders o
	left join order_items i
    on o.order_id = i.order_id
		group by o.customer_id
        order by avg_item_order desc;

-- 24. Identify products with high price but low sales.
	select p.product_id, p.unit_price_usd, sum(i.quantity) as total_sales from products p
		left join order_items i
        on p.product_id = i.product_id
			group by p.product_id, p.unit_price_usd
				order by p.unit_price_usd desc, total_sales asc;

-- 25. Find orders where line_total does not match quantity×price (data quality check).
	select  * from order_items
		where quantity * unit_price_usd <> line_total;

-- 26. Show daily revenue trends over the past 90 days.
select order_date, sum(total_amount) from orders
	where order_date >= curdate() - interval 90 day
	group by order_date
    order by order_date;

-- 27. Find the top subcategory contributing the most revenue.
select p.sub_category, sum(line_total) as total_revenue from order_items i
	left join products p
    on i.product_id = p.product_id
    group by sub_category
    order by total_revenue desc 
    limit 3;
    
-- Window Functions
-- 28. Rank customers by their total spending.
select *,
	rank() over(order by t.total_spending desc) as ranking
		from (
			select customer_id, sum(total_amount) as total_spending from orders
			group by customer_id) t;
    
-- 29. Calculate running total of revenue by order_date.
select * ,
	sum(t.revenue_day) over(order by t.order_date asc) as running_revenue
    from (    
		select order_date, sum(total_amount) as revenue_day from orders
		group by order_date) t;

-- 30. Rank manufacturer by revenue within each categories.
select * ,
	dense_rank() over(partition by category order by total_revenue desc) as cat_rank
    from (
		select category, manufacturer, sum(line_total) as total_revenue
		from order_items i
		left join products p
			on i.product_id = p.product_id 
			group by category, manufacturer) t;

-- 31. For each month, show revenue + percentage change from previous month.
select *,
	lag(total_revenue) over (order by yr_month) as prev_revenue,
    round(100 * (total_revenue - lag(total_revenue) over(order by yr_month)) / lag(total_revenue) over(order by yr_month),2) as percentage_change
	from (
		select date_format(order_date, '%Y-%m') as yr_month ,sum(total_amount) total_revenue
			from orders
				group by yr_month) t
                order by yr_month;
                
                

	
