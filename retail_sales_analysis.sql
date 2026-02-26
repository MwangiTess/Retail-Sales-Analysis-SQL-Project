-- 1. TABLE CREATION & DATA SETUP
CREATE TABLE retail_sales
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			)
			
-- 2. DATA CLEANING
SELECT * FROM retail_sales
LIMIT 10;

SELECT 
	COUNT(*)
FROM retail_sales;

-- Fix column name
ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity

-- Check for nulls
SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL OR 
    sale_date IS NULL OR 
    age IS NULL OR 
    category IS NULL OR 
    quantity IS NULL OR 
    price_per_unit IS NULL OR 
    cogs IS NULL OR 
    total_sale IS NULL;
	
-- Remove invalid records
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL OR 
    sale_date IS NULL OR 
    age IS NULL OR 
    category IS NULL OR 
    quantity IS NULL OR 
    price_per_unit IS NULL OR 
    cogs IS NULL OR 
    total_sale IS NULL;

-- 3. EXPLORATORY DATA ANALYSIS
-- 3.1 Sales Performance & Trends
--  	a) Total Revenue and Profit

SELECT
	COUNT(transactions_id) AS transactions,
	SUM(total_sale) AS total_revenue,
	SUM(total_sale - cogs) AS total_profit
FROM retail_sales;

--  	b) Highest Sales (Month or Days)
-- For monthly peaks

SELECT
	TO_CHAR(sale_date, 'Month') AS month_name,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY total_sales DESC;

-- For Daily Peaks (Day of Week)
SELECT
	TO_CHAR(sale_date, 'Day') as day_name,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY total_sales DESC;

--  C) Peak Sales Time (Shift Analysis - Staffing)
SELECT
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY shift
ORDER BY total_orders DESC;

--  C) Average Transaction Value (ATV)
SELECT
    ROUND(SUM(total_sale) / COUNT(transactions_id), 2) AS avg_transaction_value
FROM retail_sales;

-- d) ATV based on the no of customers visiting each day
SELECT
	TO_CHAR(sale_date, 'Day') as day_name,
	SUM(total_sale) AS total_sales,
	COUNT(customer_id) AS customers,
	SUM(total_sale) / COUNT(transactions_id) AS avg_transaction_value
FROM retail_sales
GROUP BY 1
ORDER BY avg_transaction_value DESC;

-- 3.2 Product & Category Performance
--  a) Top Performig Category

SELECT
	category,
	SUM(total_sale) AS total_revenue,
	SUM(total_sale - cogs) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_revenue DESC;

--  b) Quantity VS Category
SELECT
	category,
	SUM(quantity) AS total_quantity_sold,
	AVG(quantity) AS avg_items_per_order
FROM retail_sales
GROUP BY category;

--  c) Price-Point Sensitivity
SELECT
	price_per_unit,
	SUM(quantity) AS units_sold
FROM retail_sales
GROUP BY price_Per_unit
ORDER BY units_sold DESC;

-- 3.3 Customer Demographics
--  a) Spending by Gender and Category

SELECT
	gender,
	category,
	SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY gender, category
ORDER BY gender, total_revenue DESC;

-- b) Spending by Gender
SELECT
	gender,
	SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY gender
ORDER BY total_revenue DESC;

--  c) Primary Market(Age Brackest)
SELECT
	category,
	CASE
		WHEN age < 30 THEN 'Under 30'
		WHEN age BETWEEN 30 AND 50 THEN '30 - 50'
		ELSE 'Over 50'
	END AS age_group,
	SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY age_group, category
ORDER BY total_revenue DESC;

--  d) Most Loyal Customers (Power Users)
SELECT
	customer_id,
	COUNT(transactions_id) AS total_visits,
	SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- 3.4 Profitability & Operations
-- a) Profit Margins by Category

SELECT
	category,
	ROUND((SUM(total_sale - cogs) / SUM(total_sale) * 100)::numeric, 2) AS margin_percentage
FROM retail_sales
GROUP BY category;

-- b) Stocking Efficiency for Order Prediction

SELECT
    category,
    EXTRACT(MONTH FROM sale_date) AS month_number,
    TO_CHAR(sale_date, 'Month') AS month_name,
    SUM(quantity) AS units_needed
FROM retail_sales
GROUP BY category, month_number, month_name
ORDER BY category, month_number;









		
