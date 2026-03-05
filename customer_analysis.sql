/*
File: customer_analysis.sql
Project: Bike Sales Analytics
Author: Connor Thornell
Date: 02-24-2026

Description:
Customer behavior and revenue contribution analysis:
- Top Customers
- One-Time vs Repeat Customers
- Revenue by Gender
- Revenue by Country
*/


--   SECTION 1: Top 10 Customers by Revenue

SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;



--   SECTION 2: One-Time vs Repeat Customers

WITH customer_orders AS (
    SELECT 
        customer_key,
        COUNT(DISTINCT order_number) AS total_orders
    FROM gold.fact_sales
    GROUP BY customer_key
),
customer_type AS (
    SELECT 
        customer_key,
        CASE 
            WHEN total_orders = 1 THEN 'One-Time'
            ELSE 'Repeat'
        END AS customer_type
    FROM customer_orders
)

SELECT
    ct.customer_type,
    COUNT(DISTINCT ct.customer_key) AS number_of_customers, 
    SUM(fs.sales_amount) AS total_revenue,
    CAST(
        COUNT(DISTINCT ct.customer_key) * 100.0 
        / SUM(COUNT(DISTINCT ct.customer_key)) OVER ()
        AS DECIMAL(5,2)
    ) AS percent_of_customers,
    CAST(
        SUM(fs.sales_amount) * 100.0 
        / SUM(SUM(fs.sales_amount)) OVER ()
        AS DECIMAL(5,2)
    ) AS percent_of_revenue
FROM customer_type ct
JOIN gold.fact_sales fs
    ON ct.customer_key = fs.customer_key
GROUP BY ct.customer_type
ORDER BY ct.customer_type;



--   SECTION 3: Revenue by Gender

WITH customer_revenue AS (
    SELECT 
        f.customer_key,
        SUM(f.sales_amount) AS total_revenue
    FROM gold.fact_sales f
    GROUP BY f.customer_key
)

SELECT
    c.gender,
    COUNT(DISTINCT c.customer_key) AS number_of_customers,
    SUM(cr.total_revenue) AS total_revenue,
    CAST(
        SUM(cr.total_revenue) * 100.0 
        / SUM(SUM(cr.total_revenue)) OVER ()
        AS DECIMAL(5,2)
    ) AS percent_of_revenue
FROM gold.dim_customers c
JOIN customer_revenue cr
    ON c.customer_key = cr.customer_key
WHERE c.gender <> 'N/A'
GROUP BY c.gender
ORDER BY total_revenue DESC;



--   SECTION 4: Revenue by Country

WITH customer_revenue AS (
    SELECT 
        f.customer_key,
        SUM(f.sales_amount) AS total_revenue
    FROM gold.fact_sales f
    GROUP BY f.customer_key
)

SELECT
    c.country,
    COUNT(DISTINCT c.customer_key) AS number_of_customers,
    SUM(cr.total_revenue) AS total_revenue,
    CAST(
        SUM(cr.total_revenue) * 100.0 
        / SUM(SUM(cr.total_revenue)) OVER ()
        AS DECIMAL(5,2)
    ) AS percent_of_revenue
FROM gold.dim_customers c
JOIN customer_revenue cr
    ON c.customer_key = cr.customer_key
WHERE c.country <> 'N/A'
GROUP BY c.country
ORDER BY total_revenue DESC;