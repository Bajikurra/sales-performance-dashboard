-- ============================================================
--  Sales Dashboard — Database Schema & Data Load
--  Run this first before analysis_queries.sql
-- ============================================================

-- Create database
CREATE DATABASE IF NOT EXISTS sales_dashboard;
USE sales_dashboard;

-- Drop table if re-running
DROP TABLE IF EXISTS sales;

-- Create table
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

-- Add indexes for faster query performance
CREATE INDEX idx_order_date     ON sales(order_date);
CREATE INDEX idx_region         ON sales(region);
CREATE INDEX idx_category       ON sales(category);
CREATE INDEX idx_order_status   ON sales(order_status);
CREATE INDEX idx_customer_id    ON sales(customer_id);

-- Load CSV data (update path as needed)
LOAD DATA INFILE '/path/to/data/sales_data_cleaned.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, order_date, customer_id, customer_name, region, city,
 product_id, product_name, category, unit_price, discount_pct,
 selling_price, quantity, revenue, payment_method, order_status);

-- Verify load
SELECT COUNT(*) AS total_rows FROM sales;
