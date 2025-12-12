# Import Notes

All CSV files were imported into MySQL using the MySQL Workbench Table Data Import Wizard.  
The database schema was created beforehand using `schema.sql`.

### Import Process
1. Open MySQL Workbench and connect to the MySQL server.
2. Select the target schema: `e_commerce_db`.
3. Right-click the schema and choose **Table Data Import Wizard**.
4. Select the CSV file from the `datasets` folder.
5. Confirm that the column mappings match the table structure.
6. Proceed through the wizard to complete the import.
7. Repeat these steps for all csv files :
   - `customers.csv`
   - `products.csv`
   - `orders.csv`
   - `order_items.csv`

### Post-Import Checks
Basic validation was performed using row counts:
```sql
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
