/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key =f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Complex but Flexibly Ranking Using Window Functions
SELECT * FROM(
SELECT 
p.product_name,
SUM(f.sales_amount) AS total_revenue,
RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS ranking_products
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key =f.product_key
GROUP BY p.product_name
)T WHERE ranking_products<=5
ORDER BY ranking_products;

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key =f.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;

-- Find the top 10 customers who have generated the highest revenue
SELECT * FROM(
SELECT 
c.customer_key,
c.first_name,
c.last_name,
SUM(f.sales_amount) AS total_revenue,
RANK()OVER(ORDER BY SUM(f.sales_amount) DESC) AS ranking_customers
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_key,c.first_name,c.last_name
) T WHERE ranking_customers<=10
ORDER BY ranking_customers
