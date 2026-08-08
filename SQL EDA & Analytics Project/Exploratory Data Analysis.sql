/* 												  • | ○ | ■ | □ 
☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰ EDA Project ☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰
════════════════════════════════════ LOAD DATABASE ════════════════════════════════════
───────────────────────  METHOD 1 ───────────────────────
	• 1. Create new DB
	• 2. Create SCHEMA
	CREATE SCHEMA gold
	• 3. Task Import flat files

───────────────────────  METHOD 2 ───────────────────────
	• 1. Databases
	• 2. Restore DB from .bak

════════════════════════════════ DIMENSION v. MEASURES ════════════════════════════════

	• DataType is NUMBER? Does it make sense to aggregate?
		○ NO --> Dimension
		○ YES --> Measure

═════════════════════════════════ DATABASE EXPLORATION ════════════════════════════════ */

USE dwh_analytics
-- Explore ALL objects in DB
SELECT * FROM INFORMATION_SCHEMA.TABLES
-- Explore ALL columns in DB or filter with WHERE clause
SELECT * FROM INFORMATION_SCHEMA.COLUMNS

/*
════════════════════════════════ DIMENSIONS EXPLORATION ═══════════════════════════════ 
	• Identifying unique values (categories) in each dimension
	• Recognizing how data might be grouped or segmented
*/
-- Granularity of products
SELECT DISTINCT
	category,
	subcategory,
	product_name
FROM gold.dim_products
ORDER BY 1,2,3
-- Countries
SELECT DISTINCT
	country
FROM gold.dim_customers

/*
════════════════════════════════ DATE EXPLORATION ═══════════════════════════════ 
	• Time boundaries in the dataset 
	• Understand scope and timestamp
*/
-- First & Last Order
SELECT
	MIN(order_date) AS FirstOrderDate,
	MAX(order_date) AS LastOrderDate,
	DATEDIFF(month,MIN(order_date),MAX(order_date)) AS OrdersMonthsSpan,
	DATEDIFF(year,MIN(order_date),MAX(order_date)) AS OrdersYearsSpan
FROM gold.fact_sales
-- Youngest & Oldest Customer
SELECT
	DATEDIFF(year,MIN(birthdate),GETDATE()) OldestCustomer,
	DATEDIFF(year,MAX(birthdate),GETDATE()) YoungestCustomer
FROM gold.dim_customers

/*
══════════════════════════════ MEASURE EXPLORATION ══════════════════════════════
	• Calculate key metric of the business 
	• Highest Level of Aggregation, Lowest Level of Details
*/
SELECT *
FROM gold.dim_customers c

SELECT *
FROM gold.fact_sales

SELECT *
FROM gold.dim_products

-- Total sales
SELECT
	SUM(sales_amount) TotalSales
FROM gold.fact_sales
-- Total items sold
SELECT
	SUM(quantity) TotalItemsSold
FROM gold.fact_sales
-- Average price
SELECT
	AVG(price) AvgPrice
FROM gold.fact_sales
-- Total orders
SELECT
	COUNT(order_number) AS total_orders,
	COUNT(DISTINCT (order_number)) AS total_unique_orders
FROM gold.fact_sales
-- Total products
SELECT
	COUNT(product_id) AS total_products
FROM gold.dim_products
-- Total customers
SELECT 
	COUNT(customer_key) AS total_customers 
FROM gold.dim_customers
-- Total customers with order
SELECT 
	COUNT(DISTINCT customer_key) AS total_customers 
FROM gold.fact_sales

-- Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers;
/*
═══════════════════════════════ MAGNITUDE ANALYSIS ══════════════════════════════
	• Compare measure values by categories
*/
-- Total customers by country
SELECT
	country,
	COUNT(customer_key) TotalCustomers
FROM gold.dim_customers
GROUP BY country
ORDER BY COUNT(customer_key) DESC
-- Total customers by gender
SELECT
	gender,
	COUNT(customer_key) TotalCustomers
FROM gold.dim_customers
GROUP BY gender
ORDER BY COUNT(customer_key) DESC
-- Total products by category
SELECT
	category,
	COUNT(product_id) TotalProducts
FROM gold.dim_products
GROUP BY category
ORDER BY COUNT(product_id) DESC
-- Average costs by category
SELECT
	category,
	AVG(cost) AvgCost
FROM gold.dim_products
GROUP BY category
ORDER BY AVG(cost) DESC
-- Total revenue by category
SELECT
	category,
	SUM(s.sales_amount) TotalRevenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY category
ORDER BY SUM(s.sales_amount) DESC
-- Total revenue by customer
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;
-- Total sold items by country
SELECT
    c.country,
    SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;
/*
════════════════════════════════ RANKING ANALYSIS ═══════════════════════════════
	• Order the dimensions by measure
*/
-- TOP 5 highest-selling products

SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount) TotalSales
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY SUM(s.sales_amount) DESC;

SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(s.sales_amount) AS TotalSales,
        RANK() OVER (ORDER BY SUM(s.sales_amount) DESC) AS rank_products
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
    ON p.product_key = s.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- Top 5 lowest-selling products

SELECT TOP 5
	p.product_name,
	SUM(s.sales_amount) TotalSales
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY TotalSales;

SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) ASC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- Top 10 customers with the highest revenue
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- TOP 3 customers with the fewest orders
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ;