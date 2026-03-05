/*
File: profitability_analysis.sql
Project: Bike Sales Analytics
Author: Connor Thornell
Date: 02-25-2026

Description:
Profit and margin analysis across categories and bike subcategories.
*/


--   SECTION 1: Profit & Margin by Category

SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue,
    SUM(f.quantity * p.cost) AS total_cost,
    SUM(f.sales_amount) - SUM(f.quantity * p.cost) AS total_profit,
    CAST(
        (SUM(f.sales_amount) - SUM(f.quantity * p.cost)) * 100.0
        / SUM(f.sales_amount)
        AS DECIMAL(6,2)
    ) AS margin_percent
FROM gold.fact_sales f
JOIN gold.dim_products p
    ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_profit DESC;



--   SECTION 2: Profit & Margin by Bike Subcategory

SELECT
    p.subcategory,
    SUM(f.sales_amount) AS revenue,
    SUM(f.quantity * p.cost) AS cost,
    SUM(f.sales_amount) - SUM(f.quantity * p.cost) AS profit,
    CAST(
        (SUM(f.sales_amount) - SUM(f.quantity * p.cost)) * 100.0
        / SUM(f.sales_amount)
        AS DECIMAL(6,2)
    ) AS margin_percent
FROM gold.fact_sales f
JOIN gold.dim_products p
    ON f.product_key = p.product_key
WHERE p.category = 'Bikes'
GROUP BY p.subcategory
ORDER BY margin_percent DESC;

