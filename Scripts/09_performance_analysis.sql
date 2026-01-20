/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

with yearly_product_sales AS
(
    SELECT 
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(sales_amount) AS current_sales
        FROM gold.fact_sales f
        LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
        WHERE order_date IS NOT NULL
        GROUP BY p.product_name,YEAR(f.order_date)
)

SELECT
order_year,
product_name,
current_sales,
AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
CASE 
    WHEN current_sales >AVG(current_sales) OVER(PARTITION BY product_name) THEN 'Above Average'
    WHEN current_sales <AVG(current_sales) OVER(PARTITION BY product_name) THEN 'Below Average'
    ELSE 'Equal to Average'
END avg_change,
LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS post_year_sales,
LAG(current_sales)OVER(PARTITION BY product_name ORDER BY order_year) - current_sales AS diif_py_sales,
CASE 
    WHEN current_sales<LAG(current_sales)OVER(PARTITION BY product_name ORDER BY order_year) THEN 'DECREASE'
    WHEN current_sales>LAG(current_sales)OVER(PARTITION BY product_name ORDER BY order_year) THEN 'INCREASE'
    ELSE 'No Change'
END AS post_year_sales_change
FROM yearly_product_sales
ORDER BY product_name,order_year;
