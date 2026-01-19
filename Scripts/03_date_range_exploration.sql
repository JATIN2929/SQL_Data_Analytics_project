/*
==================================================================
Date Range Exploration
==================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
==================================================================
*/

-- Determine the first and last order date and the total duration in months
SELECT 
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS order_range_months
FROM gold.fact_sales

-- Determine the first and last ship date and the total duration in months
SELECT 
MIN(shipping_date) AS first_shipping_date,
MAX(shipping_date) AS last_shipping_date,
DATEDIFF(MONTH,MIN(shipping_date),MAX(shipping_date)) AS shipping_range_months
FROM gold.fact_sales

--- Determine the youngest and the oldest customer in our dataset
SELECT *,
oldest_age - youngest_age AS date_range_between_customers
FROM(
SELECT 
MIN(birthdate) AS oldest_birthdate,
DATEDIFF(YEAR,MIN(birthdate),GETDATE()) AS oldest_age,
MAX(birthdate) AS youngest_birthdate,
DATEDIFF(YEAR,MAX(birthdate),GETDATE()) AS youngest_age
FROM gold.dim_customers
)T

---Determine the first and last date when product was started
SELECT 
MIN(start_date) AS oldest_product_created,
MAX(start_date) AS youngest_product_created
FROM gold.dim_products
