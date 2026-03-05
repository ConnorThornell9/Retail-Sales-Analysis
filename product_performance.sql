/*
File: product_performance.sql
Project: Bike Sales Analytics
Author: Connor Thornell
Date: 02-25-2026

Description:
Product-level revenue performance analysis:
- Top Products
- Lowest Performing Products
- Revenue by Category
- Revenue by Bike Subcategory
*/


--   SECTION 1: Top 10 Products by Revenue

SELECT TOP 10
    p.product_name,
    SUM(f.sales_amount) AS total_revenue,
    SUM(f.quantity) AS total_quantity_sold
FROM gold.fact_sales f
JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;



--   SECTION 2: Lowest Performing Products

SELECT TOP 10
    p.product_name,
    SUM(f.sales_amount) AS total_revenue,
    SUM(f.quantity) AS total_quantity_sold
FROM gold.fact_sales f
JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;



--   SECTION 3: Revenue by Category

SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue,
    SUM(f.quantity) AS total_quantity_sold,
    CAST(
        SUM(f.sales_amount) * 100.0
        / SUM(SUM(f.sales_amount)) OVER ()
        AS DECIMAL(5,2)
    ) AS percent_of_revenue
FROM gold.fact_sales f
JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;



--   SECTION 4: Revenue by Bike Subcategory

SELECT
    p.subcategory,
    SUM(f.sales_amount) AS total_revenue,
    SUM(f.quantity) AS total_units_sold,
    CAST(
        SUM(f.sales_amount) * 100.0
        / SUM(SUM(f.sales_amount)) OVER ()
        AS DECIMAL(5,2)
    ) AS percent_of_bike_revenue
FROM gold.fact_sales f
JOIN gold.dim_products p
    ON f.product_key = p.product_key
WHERE p.category = 'Bikes'
GROUP BY p.subcategory
ORDER BY total_revenue DESC;