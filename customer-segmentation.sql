-- ==========================================
-- PROJECT 2: CUSTOMER SEGMENTATION ANALYSIS
-- Objective: Identify valuable customers and buying behavior
-- ==========================================

-- 1. Customer Lifetime Value (Total Spend Per Customer)
SELECT `Customer ID`,
       SUM(Sales) AS lifetime_value
FROM superstore
GROUP BY `Customer ID`
ORDER BY lifetime_value DESC;

-- 2. Number of Orders Per Customer
SELECT `Customer ID`,
       COUNT(`Order ID`) AS total_orders
FROM superstore
GROUP BY `Customer ID`
ORDER BY total_orders DESC;

-- 3. Customer Segmentation Based on Spend
SELECT `Customer ID`,
       SUM(Sales) AS total_spent,
       CASE
           WHEN SUM(Sales) > 10000 THEN 'High Value'
           WHEN SUM(Sales) > 5000 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS customer_segment
FROM superstore
GROUP BY `Customer ID`
ORDER BY total_spent DESC;

-- 4. Average Order Value Per Customer
SELECT `Customer ID`,
       SUM(Sales)/COUNT(`Order ID`) AS avg_order_value
FROM superstore
GROUP BY `Customer ID`
ORDER BY avg_order_value DESC;

-- 5. Repeat Customers (More Than 5 Orders)
SELECT `Customer ID`,
       COUNT(`Order ID`) AS order_count
FROM superstore
GROUP BY `Customer ID`
HAVING COUNT(`Order ID`) > 5
ORDER BY order_count DESC;
