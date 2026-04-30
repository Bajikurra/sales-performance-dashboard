-- ============================================================
--  End-to-End Sales Performance Dashboard
--  SQL Analysis Queries
--  Author: Baji Venkata Satya Krishna Kurra
--  GitHub: github.com/Bajikurra
-- ============================================================

-- ── TABLE SCHEMA ─────────────────────────────────────────────────

CREATE TABLE sales (
    order_id       VARCHAR(10)    PRIMARY KEY,
    order_date     DATE           NOT NULL,
    customer_id    VARCHAR(10)    NOT NULL,
    customer_name  VARCHAR(100),
    region         VARCHAR(20),
    city           VARCHAR(50),
    product_id     VARCHAR(10),
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


-- ── QUERY 1: Total Revenue, Orders & Avg Order Value ─────────────
SELECT
    COUNT(order_id)             AS total_orders,
    ROUND(SUM(revenue), 2)      AS total_revenue,
    ROUND(AVG(revenue), 2)      AS avg_order_value,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM sales
WHERE order_status = 'Delivered';


-- ── QUERY 2: Revenue by Region ────────────────────────────────────
SELECT
    region,
    COUNT(order_id)         AS total_orders,
    ROUND(SUM(revenue), 2)  AS total_revenue,
    ROUND(AVG(revenue), 2)  AS avg_revenue_per_order
FROM sales
WHERE order_status = 'Delivered'
GROUP BY region
ORDER BY total_revenue DESC;


-- ── QUERY 3: Top 10 Products by Revenue ──────────────────────────
SELECT
    product_id,
    product_name,
    category,
    SUM(quantity)           AS units_sold,
    ROUND(SUM(revenue), 2)  AS total_revenue,
    ROUND(AVG(discount_pct), 1) AS avg_discount_pct
FROM sales
WHERE order_status = 'Delivered'
GROUP BY product_id, product_name, category
ORDER BY total_revenue DESC
LIMIT 10;


-- ── QUERY 4: Monthly Revenue Trend ───────────────────────────────
SELECT
    YEAR(order_date)                        AS year,
    MONTH(order_date)                       AS month_num,
    DATE_FORMAT(order_date, '%b %Y')        AS month_label,
    COUNT(order_id)                         AS orders,
    ROUND(SUM(revenue), 2)                  AS monthly_revenue,
    ROUND(SUM(revenue) - LAG(SUM(revenue))
          OVER (ORDER BY YEAR(order_date), MONTH(order_date)), 2)
                                            AS mom_change
FROM sales
WHERE order_status = 'Delivered'
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month_num;


-- ── QUERY 5: Category Performance ────────────────────────────────
SELECT
    category,
    COUNT(DISTINCT product_id)  AS products_in_category,
    SUM(quantity)               AS units_sold,
    ROUND(SUM(revenue), 2)      AS total_revenue,
    ROUND(SUM(revenue) * 100.0 /
          SUM(SUM(revenue)) OVER (), 2) AS revenue_share_pct
FROM sales
WHERE order_status = 'Delivered'
GROUP BY category
ORDER BY total_revenue DESC;


-- ── QUERY 6: Payment Method Distribution ─────────────────────────
SELECT
    payment_method,
    COUNT(order_id)                                         AS total_orders,
    ROUND(COUNT(order_id) * 100.0 / SUM(COUNT(order_id))
          OVER (), 2)                                       AS order_share_pct,
    ROUND(SUM(revenue), 2)                                  AS total_revenue
FROM sales
GROUP BY payment_method
ORDER BY total_orders DESC;


-- ── QUERY 7: Order Status Breakdown ──────────────────────────────
SELECT
    order_status,
    COUNT(order_id)                                             AS orders,
    ROUND(COUNT(order_id) * 100.0 / SUM(COUNT(order_id))
          OVER (), 2)                                           AS pct_of_total,
    ROUND(SUM(revenue), 2)                                      AS revenue_impact
FROM sales
GROUP BY order_status
ORDER BY orders DESC;


-- ── QUERY 8: Customer Repeat Purchase Analysis ────────────────────
SELECT
    order_frequency,
    COUNT(customer_id) AS customer_count,
    ROUND(COUNT(customer_id) * 100.0 /
          SUM(COUNT(customer_id)) OVER (), 2) AS pct_of_customers
FROM (
    SELECT
        customer_id,
        CASE
            WHEN COUNT(order_id) = 1  THEN 'One-time buyer'
            WHEN COUNT(order_id) <= 3 THEN 'Occasional (2-3 orders)'
            ELSE 'Loyal (4+ orders)'
        END AS order_frequency
    FROM sales
    GROUP BY customer_id
) freq_table
GROUP BY order_frequency
ORDER BY customer_count DESC;


-- ── QUERY 9: Top 5 Cities by Revenue ─────────────────────────────
SELECT
    city,
    region,
    COUNT(order_id)        AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM sales
WHERE order_status = 'Delivered'
GROUP BY city, region
ORDER BY total_revenue DESC
LIMIT 5;


-- ── QUERY 10: Discount Impact on Revenue ─────────────────────────
SELECT
    discount_pct,
    COUNT(order_id)             AS orders,
    ROUND(AVG(quantity), 2)     AS avg_qty_per_order,
    ROUND(SUM(revenue), 2)      AS total_revenue,
    ROUND(AVG(revenue), 2)      AS avg_revenue_per_order
FROM sales
WHERE order_status = 'Delivered'
GROUP BY discount_pct
ORDER BY discount_pct;


-- ── QUERY 11: YoY Revenue Comparison ─────────────────────────────
SELECT
    YEAR(order_date)       AS year,
    ROUND(SUM(revenue), 2) AS total_revenue,
    COUNT(order_id)        AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM sales
WHERE order_status = 'Delivered'
GROUP BY YEAR(order_date)
ORDER BY year;


-- ── QUERY 12: High-Value Customers (Top 10) ───────────────────────
SELECT
    customer_id,
    customer_name,
    region,
    COUNT(order_id)        AS total_orders,
    ROUND(SUM(revenue), 2) AS lifetime_value
FROM sales
WHERE order_status = 'Delivered'
GROUP BY customer_id, customer_name, region
ORDER BY lifetime_value DESC
LIMIT 10;


-- ── QUERY 13: Product Return Rate ────────────────────────────────
SELECT
    product_name,
    category,
    COUNT(CASE WHEN order_status = 'Delivered' THEN 1 END) AS delivered,
    COUNT(CASE WHEN order_status = 'Returned'  THEN 1 END) AS returned,
    ROUND(COUNT(CASE WHEN order_status = 'Returned' THEN 1 END) * 100.0
          / COUNT(order_id), 2)                            AS return_rate_pct
FROM sales
GROUP BY product_name, category
ORDER BY return_rate_pct DESC;


-- ── QUERY 14: Weekend vs Weekday Orders ──────────────────────────
SELECT
    CASE WHEN DAYOFWEEK(order_date) IN (1, 7) THEN 'Weekend'
         ELSE 'Weekday' END      AS day_type,
    COUNT(order_id)              AS total_orders,
    ROUND(SUM(revenue), 2)       AS total_revenue,
    ROUND(AVG(revenue), 2)       AS avg_order_value
FROM sales
WHERE order_status = 'Delivered'
GROUP BY day_type
ORDER BY total_revenue DESC;


-- ── QUERY 15: Running Total Revenue by Month ─────────────────────
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    ROUND(SUM(revenue), 2)           AS monthly_revenue,
    ROUND(SUM(SUM(revenue))
          OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m')), 2)
                                     AS running_total
FROM sales
WHERE order_status = 'Delivered'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;
