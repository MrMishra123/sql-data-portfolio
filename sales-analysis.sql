-- ==========================================
-- PROJECT: SALES ANALYSIS
-- Dataset: Superstore.csv
-- Objective: Analyze revenue, profit, and sales trends
-- ==========================================

-- 1. Total Revenue
SELECT SUM(Sales) AS total_revenue
FROM superstore;

-- 2. Top Products
SELECT `Product Name`,
       SUM(Sales) AS revenue
FROM superstore
GROUP BY `Product Name`
ORDER BY revenue DESC
LIMIT 10;

-- 3. Sales by Region
SELECT Region,
       SUM(Sales) AS regional_sales
FROM superstore
GROUP BY Region
ORDER BY regional_sales DESC;

-- 4. Monthly Sales Trend
SELECT DATE_FORMAT(`Order Date`, '%Y-%m') AS month,
       SUM(Sales) AS monthly_sales
FROM superstore
GROUP BY month
ORDER BY month;

-- 5. Loss-making Orders
SELECT *
FROM superstore
WHERE Profit < 0;
