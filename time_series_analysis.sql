/*
File: time_series_analysis.sql
Project: Bike Sales Analytics
Author: Connor Thornell
Date: 02-25-2026

Description:
Time-series analysis focused on bike revenue trends:
- Monthly Bike Revenue
- Monthly Revenue by Bike Subcategory
*/


--   SECTION 1: Monthly Bike Revenue

SELECT
    YEAR(f.order_date) AS order_year,
    MONTH(f.order_date) AS order_month,
    SUM(f.sales_amount) AS bike_revenue
FROM gold.fact_sales f
JOIN gold.dim_products p
    ON f.product_key = p.product_key
WHERE p.category = 'Bikes'
    AND f.order_date IS NOT NULL
GROUP BY 
    YEAR(f.order_date),
    MONTH(f.order_date)
ORDER BY 
    order_year,
    order_month;



--   SECTION 2: Monthly Bike Revenue by Subcategory

SELECT
    YEAR(f.order_date) AS order_year,
    MONTH(f.order_date) AS order_month,
    p.subcategory,
    SUM(f.sales_amount) AS revenue
FROM gold.fact_sales f
JOIN gold.dim_products p
    ON f.product_key = p.product_key
WHERE p.category = 'Bikes'
    AND f.order_date IS NOT NULL
GROUP BY 
    YEAR(f.order_date),
    MONTH(f.order_date),
    p.subcategory
ORDER BY 
    order_year,
    order_month,
    p.subcategory;