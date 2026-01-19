/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

---Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales;

---Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales;

---Find the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales;

---Find the Total number of Orders
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales;

---Find the total number of products
SELECT COUNT(product_name) AS total_products FROM gold.dim_products;

---Find the average cost of product
SELECT AVG(cost) AS avg_cost FROM gold.dim_products;

---Find the total number of customers
SELECT COUNT(DISTINCT customer_key) FROM gold.dim_customers;

-- Generate a Report that shows all key metrics of the business
SELECT 'TOTAL SALES' AS measure_name,SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'TOTAL QUANTITY',SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'AVERAGE PRICE',AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'TOTAL ORDERS',COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'TOTAL PRODUCTS',COUNT(product_name) FROM gold.dim_products
UNION ALL
SELECT 'AVERAGE PRODUCT COST',AVG(cost) FROM gold.dim_products
UNION ALL 
SELECT 'TOTAL CUSTOMERS',COUNT(DISTINCT customer_key) FROM gold.dim_customers;
