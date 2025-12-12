# Datasets

This folder has all the CSV files that were used for the project.  
Each file matches a table in the database.

---

## customers.csv
This file has information about customers.

Columns:
- customer_id
- first_name
- last_name
- email
- age
- gender
- country
- state
- signup_date

---

## products.csv
This file has information about products.

Columns:
- product_id
- product_name
- manufacturer
- category
- sub_category
- unit_price_usd

---

## orders.csv
This file has the orders made by customers.

Columns:
- order_id
- customer_id
- order_date
- status
- total_amount
- payment_method

---

## order_items.csv
This file has the items inside each order.

Columns:
- order_item_id
- order_id
- product_id
- quantity
- unit_price_usd
- line_total

---

- All datasets are synthetic or sourced from publicly available data.  
- All files are normal as CSV  with headers.  
- These files can be imported into MySQL using the Workbench wizard or Python.

