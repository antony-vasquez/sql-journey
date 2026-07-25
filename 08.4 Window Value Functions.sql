/*
============================== WINDOW RANK FUNCTIONS ==============================

		F(X) OVER()                             | Access a value from other row

	- Argument X can be any data type
	- PARTITION is optional, ORDER BY is REQUIRED, FRAME not ALLOWED for LEAD, LAG, ALLOWED for FIRST_VALUE and RECOMMENDED for LAST_VALUE

*/
-------------------------------- LEAD/LAG ------------------------------------
	-- Access a value from a the next/previous row within a window

-- Syntax: LEAD/LAG(expr., offset, default value) | default offest = 1, default value when no value found = NULL

/*
================================== CASE USES ==================================
	Time Series Analysis: understand patterns, trends and behaviors over time:
		- Month-over-Month (MoM): short term trends and seasonality
		- Year-over-Year (YoY): overall growth
*/
SELECT 
	*,
	MonthSales-PreviousMonthSales AS MoMChange,
	ROUND(CAST((MonthSales-PreviousMonthSales) AS FLOAT)/PreviousMonthSales*100,2) MoM_Perc
FROM(
	SELECT 
		MONTH(OrderDate) OrderMonth,
		SUM(Sales) MonthSales,
		LAG(SUM(Sales),1) OVER(ORDER BY MONTH(OrderDate)) PreviousMonthSales
	FROM Sales.Orders
	GROUP BY MONTH(OrderDate)
	)t

/*
================================== CASE USES ==================================
	Customer Retention Analysis: measure customers behavior and loyalty
*/

SELECT 
	CustomerID,
	ROUND(AVG(DaysBTOrders), 2) AvgDaysBTOrders,
	RANK() OVER(ORDER BY COALESCE(ROUND(AVG(DaysBTOrders), 2),999999)) RankAvg
FROM(
	SELECT
		CustomerID,
		OrderDate,
		LEAD(OrderDate,1) OVER(PARTITION BY CustomerID ORDER BY OrderDate) NextOrderDate,
		CAST(DATEDIFF(DAY,OrderDate,LEAD(OrderDate,1) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) AS FLOAT) DaysBTOrders
	FROM Sales.Orders
	)t
GROUP BY CustomerID

/*
================================== CASE USES ==================================
	Time-Gap Analysis
*/

SELECT 
	MONTH(OrderDate) OrderDate,
	AVG(DATEDIFF(DAY,OrderDate,ShipDate)) AvgShip
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

----------------------------- FIRST/LAST_VALUE ---------------------------------------
	-- Access a value from a the first/last row within a window

-- Syntax: FIRST/LAST_VALUE(expr)
	-- For LAST_VALUE using a frame is recommended, like ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
	-- FIRST_VALUE with the DESC ORDER BY, gives the same output as LAST_VALUE, so its recommended.

SELECT
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) LowestSales,
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) HighestSales2 -- Same result as above, more practical
FROM Sales.Orders

-- Best option:
SELECT
	ProductID,
	MAX(Sales) MaxSales,
	MIN(Sales) MinSales
FROM Sales.Orders
GROUP BY ProductID