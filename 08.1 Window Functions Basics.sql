--- Intro on data aggregation ---
USE MyDatabase
SELECT
customer_id,
COUNT(*) AS total_nr_sales,
SUM(sales) AS total_sales,
AVG(sales) AS avg_sales,
MAX(sales) AS max_sales,
MIN(sales) AS lowest_sales
FROM orders
GROUP BY customer_id

--- Window functions (row-level-functions) vs Group by --- Granularity stays | Granularity changes
USE SalesDB
SELECT 
	ProductID,
	OrderDate,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesbyProducts
FROM Sales.Orders 

--- Window Functions Syntax
								-- WindowFunction[Fx] OVER (PARTITION BY, ORDER BY, FRAME)

--- PARTITION BY: divide the result sets into windows (partitions). Can be empty, single column or combined columns (Nxn)
SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	OrderStatus,
	SUM(Sales) OVER() TotalSales,
	SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesPerProduct,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) TotalSalesPerProductAndStatus
FROM Sales.Orders

SELECT *
FROM Sales.Orders

--- ORDER BY: sort the data within a window (Asc/Desc)
SELECT
	OrderID,
	OrderDate,
	RANK() OVER(ORDER BY sales DESC) OrderBySales
FROM Sales.Orders

--- FRAME: defines a subset of rows within each window that is relevant to the calculation. Framing the data

-- ROWS/RANGE | BETWEEN | CURRENT ROW/N PRECEDING/UNBOUNDED PRECEDING | AND | CURRENT ROW/N FOLLOWING/UNBOUNDED FOLLOWING

		-- Can only be used with ORDER BY
		-- If frame not specified, predetermined frame is ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY OrderStatus 
			   ORDER BY OrderDate 
			   ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) TotalSales
FROM Sales.Orders

		-- RULES for the WINDOW functions --
/*
	1. Can only be used with SELECT and ORDER BY Clauses
	2. Nesting is not allowed
	3. SQL executes after WHERE Clause
	4. Can be used with GROUP BY ONLY if the same columns are used
*/