	-- Creating database 
create database e_commerce_db;

-- Using database
use e_commerce_db;

-- Creating Tables in the database

-- 1) Creating customer table
create table customers(
	customer_id varchar(20) not null,
    first_name varchar(256) not null,
    last_name varchar(256),
    email varchar(256) unique not null,
    age int,
    gender varchar(10),
    county varchar(128),
    state varchar(128),
    signup_date date not null,
    constraint cust_pk primary key (customer_id)
    );
    
-- 2) Creating products table
create table products(
	product_id varchar(20),
    product_name text not null,
    manufacturer varchar(256),
    category varchar(128) not null,
    sub_category varchar(256) not null,
    unit_price_usd decimal(10,2),
    constraint prod_pk primary key (product_id)
    );
    
-- 3) Creating orders table
create table orders(
	order_id varchar(30),
    customer_id varchar(20) not null, 
    order_date date not null, 
    status varchar(30) not null,
    total_amount decimal(10,2),
    payment_method varchar(20) not null,
    constraint orde_pk primary key (order_id),
    
    constraint order_cust_fk foreign key(customer_id)
		references customers(customer_id)
			ON UPDATE CASCADE
			ON DELETE RESTRICT
    );
    
-- Creating order_items
create table order_items(
	order_item_id varchar(50) not null,
    order_id varchar(30) not null,
    product_id varchar(20) not null, 
    quantity int not null,
    unit_price_usd decimal(10,2),
    line_total decimal(10,2),
    
    constraint ord_itm_pk primary key (order_item_id),
    
    constraint itm_ord_fk foreign key(order_id)
		references orders(order_id)
			on delete cascade
            on update cascade,
        
	constraint itm_pro_fk foreign key(product_id)
		references products(product_id)
			on delete restrict
            on update cascade
	);
    
		
desc customers;
desc products;
desc orders;
desc order_items;
