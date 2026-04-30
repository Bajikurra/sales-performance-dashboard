-- ============================================================
--  Sales Performance Dashboard - SQL Queries
--  Author: Baji Venkata Satya Krishna Kurra
-- ============================================================

-- Create table
CREATE TABLE IF NOT EXISTS sales (
    order_id       VARCHAR(10) PRIMARY KEY,
    order_date     DATE,
    customer_id    VARCHAR(10),
    customer_name  VARCHAR(100),
    region         VARCHAR(20),
    city           VARCHAR(50),
    product_name   VARCHAR(100),
    category       VARCHAR(50),
    unit_price     DECIMAL(10,2),
    discount_pct   INT,
    selling_price  DECIMAL(10,2),
    quantity       INT,
    revenue        DECIMAL(10,2),
    payment_method VARCHAR(30),
    order_status   VARCHAR(20)
);


-- Q1: Total revenue from delivered orders
SELECT
    COUNT(order_id)         AS total_orders,
    SUM(revenue)            AS total_revenue,
    ROUND(AVG(revenue), 2)  AS avg_order_value
FROM sales
WHERE order_status = 'Delivered';


-- Q2: Revenue by region
SELECT
    region,
    COUNT(order_id)        AS orders,
    SUM(revenue)           AS total_revenue
FROM sales
WHERE order_status = 'Delivered'
GROUP BY region
ORDER BY total_revenue DESC;


-- Q3: Top 5 products by revenue
SELECT
    product_name,
    category,
    SUM(quantity)   AS units_sold,
    SUM(revenue)    AS total_revenue
FROM sales
WHERE order_status = 'Delivered'
GROUP BY product_name, category
ORDER BY total_revenue DESC
LIMIT 5;


-- Q4: Monthly revenue trend
SELECT
    MONTH(order_date)                AS month_num,
    DATE_FORMAT(order_date, '%b')    AS month_name,
    COUNT(order_id)                  AS orders,
    SUM(revenue)                     AS monthly_revenue
FROM sales
WHERE order_status = 'Delivered'
GROUP BY MONTH(order_date), DATE_FORMAT(order_date, '%b')
ORDER BY month_num;


-- Q5: Revenue by category
SELECT
    category,
    SUM(revenue)    AS total_revenue,
    SUM(quantity)   AS units_sold
FROM sales
WHERE order_status = 'Delivered'
GROUP BY category
ORDER BY total_revenue DESC;


-- Q6: Payment method breakdown
SELECT
    payment_method,
    COUNT(order_id)  AS total_orders
FROM sales
GROUP BY payment_method
ORDER BY total_orders DESC;


-- Q7: Order status breakdown
SELECT
    order_status,
    COUNT(order_id)  AS count
FROM sales
GROUP BY order_status
ORDER BY count DESC;


-- Q8: Revenue by city
SELECT
    city,
    region,
    SUM(revenue)    AS total_revenue
FROM sales
WHERE order_status = 'Delivered'
GROUP BY city, region
ORDER BY total_revenue DESC;


-- Q9: Effect of discount on revenue
SELECT
    discount_pct,
    COUNT(order_id)         AS orders,
    ROUND(AVG(revenue), 2)  AS avg_revenue
FROM sales
WHERE order_status = 'Delivered'
GROUP BY discount_pct
ORDER BY discount_pct;


-- Q10: Customers who ordered more than once
SELECT
    customer_id,
    customer_name,
    COUNT(order_id)  AS total_orders,
    SUM(revenue)     AS total_spent
FROM sales
WHERE order_status = 'Delivered'
GROUP BY customer_id, customer_name
HAVING COUNT(order_id) > 1
ORDER BY total_spent DESC;
