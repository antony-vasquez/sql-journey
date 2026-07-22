/*
============================= WINDOW AGGREGATE FUNCTIONS =============================

		F(X) OVER()

	- X is REQUIRED and MUST be NUMERIC (except COUNT)
	- PARTITION and ORDER BY are optional
	- F(X) being COUNT, SUM, AVG, MIN, MAX
*/

-------------------------------------- COUNT --------------------------------------
	-- Number of rows in a window

SELECT 
	OrderID,
	OrderDate,
	CustomerID,
	COUNT(*) OVER() TotalOrders,
	COUNT(*) OVER(PARTITION BY CustomerID) OrderByCustomers
FROM Sales.Orders

SELECT 
	*,
	COUNT(*) OVER() TotalCustomers,
	COUNT(score) OVER() TotalScores,  --COUNT doesn't take into consideration NULLs
	COUNT(country) OVER() TotalCountry 
FROM Sales.Customers

-- Useful to check for duplicate rows
SELECT
	*
FROM(
	SELECT
		OrderID,
		COUNT(*) OVER (PARTITION BY OrderID) CheckPK
	FROM Sales.OrdersArchive
	)t 
WHERE CheckPK > 1

-------------------------------------- SUM --------------------------------------
	-- Sum of values in a window

SELECT 
	OrderID,
	OrderDate,
	ProductID,
	SUM(sales) OVER() TotalSales,
	SUM(sales) OVER(PARTITION BY ProductID) SalesByProducts
FROM Sales.Orders

-- Comparison use case
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	SUM(sales) OVER() TotalSales,
	ROUND(CAST(Sales AS float) / SUM(sales) OVER() * 100,2) Contribution
FROM Sales.Orders

-------------------------------------- AVG --------------------------------------
	-- Average of values in a window

SELECT 
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	AVG(sales) OVER() AvgSales,
	AVG(sales) OVER(PARTITION BY ProductID) AvgSalesByProducts
FROM Sales.Orders

SELECT 
	CustomerID,
	LastName,
	Coalesce(Score,0) ScoresNoNull,
	AVG(COALESCE(Score,0)) OVER() avgscoreNoNull
FROM Sales.Customers

SELECT 
	*
FROM (
	SELECT 
		OrderID,
		ProductID,
		Coalesce(Sales,0) Sales,
		AVG(COALESCE(Sales,0)) OVER() AvgSales
	FROM Sales.Orders
	) t
WHERE Sales>AvgSales

-------------------------------------- MIN/MAX --------------------------------------
	-- Min/Max of values in a window
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(sales) OVER(PARTITION BY ProductID) MaxProductSales,
	MIN(sales) OVER(PARTITION BY ProductID) MinProductSales,
	MAX(sales) OVER() OverallMax,
	MIN(sales) OVER() OverallMin
FROM Sales.Orders

SELECT
	EmployeeID,
	BirthDate,
	CONCAT(FirstName,' ',COALESCE(LastName,'Nigger')) FullName,
	MAX(Salary) OVER() HighestSalary
FROM(SELECT
		*,
		MAX(Salary) OVER() HighestSalary
	 FROM Sales.Employees) t
WHERE Salary=HighestSalary

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(sales) OVER() Highest,
	MIN(sales) OVER() Lowest,
	(MAX(sales) OVER() - MIN(sales) OVER()) SalaryDifference,
	(Sales - MIN(sales) OVER()) DeviationFromMin,
	(MAX(sales) OVER() - Sales) DeviationFromMax
FROM Sales.Orders

/*
================================== CASE USES ==================================
	RUNNING & ROLLING TOTAL: they aggregate sequence of members and the aggregation is updated each time a new member is added

	- RUNNING: from the beggining to the current point without dropping off older data
	- ROLLING: within a fixed time window, dropping off older data

	The difference is on the frame. 
		- Runnning uses default frame [ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW]
		- Rolling uses fixed frame [ROWS BETWEEN 2 PRECEDING AND CURRENT ROW]

	USES:
		* TRACKING: current sales with target sales
		* TREND ANALYSIS: insights into historical patterns


===============================================================================
			MOVING/ROLLING AVERAGE: similar to the RUNNING/ROLLING total

	- RUNNING: from the beggining to the current point without dropping off older data
	- ROLLING: within a fixed time window, dropping off older data

	The difference is on the frame. 
		- Runnning uses default frame [ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW]
		- Rolling uses fixed frame [ROWS BETWEEN 2 PRECEDING AND CURRENT ROW]
*/

	