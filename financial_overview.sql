/*
File: financial_overview.sql
Project: Bike Sales Analytics
Author: Connor Thornell
Date: 02-23-2026

Description:
Executive-level revenue performance analysis including:
- Total Revenue
- Yearly Revenue Trends
- Monthly Revenue Trends
- Average Order Value
- Year-over-Year Growth
*/



--  SECTION 1: Total Revenue

SELECT 
    SUM(sales_amount) AS total_revenue
FROM gold.fact_sales;



--   SECTION 2: Revenue by Year

SELECT
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_revenue
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;



--   SECTION 3: Monthly Revenue Trend

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS monthly_revenue
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 
    YEAR(order_date),
    MONTH(order_date)
ORDER BY 
    order_year,
    order_month;



--   SECTION 4: Average Order Value by Year

SELECT 
    YEAR(order_date) AS order_year,
    SUM(sales_amount) / COUNT(DISTINCT order_number) AS avg_order_value
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;



--   SECTION 5: Year-over-Year Growth

WITH yearly_revenue AS (
    SELECT 
        YEAR(order_date) AS order_year,
        SUM(sales_amount) AS total_revenue
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(order_date)
)

SELECT
    order_year,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY order_year) AS previous_year_revenue,
    CAST(
        ROUND(
            (total_revenue - LAG(total_revenue) OVER (ORDER BY order_year)) * 100.0
            / LAG(total_revenue) OVER (ORDER BY order_year),
        2)
    AS DECIMAL(10,2)
    ) AS yoy_growth_percent
FROM yearly_revenue
ORDER BY order_year;