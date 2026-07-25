/*										 | • | ○ | ■ | □ |
☲☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰ Views ☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☲
	• Virtual table based on the result of a query, without storing the data in the database.
		○ Persisted SQL queries in the database

	• Views vs Tables: 
		○ View: No persistance | Easy to mantain | Slow response | Read only
		○ Table: Persisted data | Hard to mantain | Fast response | Read and write

	• Views vs CTEs: 
		○ View: Reduce redundancy in multiple queries | Persisted logic | Need Maintenance
		○ CTE:	Reduce redundancy in 1 query		  | Temporary Logic | Auto clean-up

	• Syntax: CREATE VIEW VIEW_NAME AS (SELECT FROM WHERE)												*/

-- Create -----------------------------------------------
CREATE VIEW Sales.VIEW_MONTHLY_SUMMARY AS (
	SELECT
		DATETRUNC(month,OrderDate) OrderMonth,
		SUM(Sales) TotalSales,
		COUNT(OrderID) TotalOrders,
		SUM(Quantity) TotalQuantities
	FROM Sales.Orders
	GROUP BY DATETRUNC(month,OrderDate)
	)

-- Drop -----------------------------------------------
DROP VIEW VIEW_MONTHLY_SUMMARY

-- Modify -----------------------------------------------
IF OBJECT_ID('Sales.VIEW_MONTHLY_SUMMARY','V') IS NOT NULL
	DROP VIEW Sales.VIEW_MONTHLY_SUMMARY;
GO 
CREATE VIEW Sales.VIEW_MONTHLY_SUMMARY AS (
	SELECT
		DATETRUNC(month,OrderDate) OrderMonth,
		SUM(Sales) TotalSales,
		COUNT(OrderID) TotalOrders,
		SUM(Quantity) TotalQuantities
	FROM Sales.Orders
	GROUP BY DATETRUNC(month,OrderDate)
	)

-- Query -----------------------------------------------	
SELECT *
FROM Sales.VIEW_MONTHLY_SUMMARY

/*
════════════════════════════════════════════ USE CASES ══════════════════════════════════════════════ 
─────────────────────────────────── Central Complex Query Logic ───────────────────────────────────── 
	• Store central, complex query logic, for access by multiple queries, reducing project complexity			

───────────────────────────────────────── Hide Complexity ─────────────────────────────────────────── 
	• Views can be used to hide complexity, offering users more friendly and easy-to-work objects					 */

CREATE VIEW Sales.V_OrderDetail AS (
	SELECT 
		o.OrderID,
		o.OrderDate,
		p.Product,
		p.Category,
		CONCAT(COALESCE(c.FirstName,''),' ',COALESCE(c.LastName,'')) CustomerName,
		c.Country CustomerCountry,
		CONCAT(COALESCE(e.FirstName,''),' ',COALESCE(e.LastName,'')) SalesName,
		e.Department,
		o.Sales,
		o.Quantity
	FROM Sales.Orders o
	LEFT JOIN SALES.Products p
	ON p.ProductID = o.ProductID
	LEFT JOIN Sales.Customers c
	ON c.CustomerID = o.CustomerID
	LEFT JOIN Sales.Employees e
	ON e.EmployeeID = o.SalesPersonID
)

SELECT * 
FROM Sales.V_OrderDetail

/*
────────────────────────────────────────── Data Security ──────────────────────────────────────────── 
	• Use views to enforce security and protect sensitive data, by hiding columns/rows from tables				     */

-- CREATE VIEW Sales.V_OrderDetail AS (
	SELECT 
		o.OrderID,
		o.OrderDate,
		p.Product,
		p.Category,
		CONCAT(COALESCE(c.FirstName,''),' ',COALESCE(c.LastName,'')) CustomerName,
		c.Country CustomerCountry,
		CONCAT(COALESCE(e.FirstName,''),' ',COALESCE(e.LastName,'')) SalesName,
	--	e.Department,                      -- Column level security
		o.Sales,
		o.Quantity
	FROM Sales.Orders o
	LEFT JOIN SALES.Products p
	ON p.ProductID = o.ProductID
	LEFT JOIN Sales.Customers c
	ON c.CustomerID = o.CustomerID
	LEFT JOIN Sales.Employees e
	ON e.EmployeeID = o.SalesPersonID
	WHERE c.Country <> 'USA'               -- Row level security

/*	
─────────────────────────────────────────── Flexibility ───────────────────────────────────────────── 
	• When making changes to the database tables, just keep updated the view, in order to don't break
	  other people queries. So you don't have to contact every person in the org to make a simple change.

────────────────────────────────────────── Multi-Language ───────────────────────────────────────────
	• When working with international teams, create views in other languages. So it's accessible to
	  everyone while mantaining the original data in the tables of the database.

────────────────────────────────────────── Data Warehouse ─────────────────────────────────────────── 
	• Views can be used as Data Marts in Data Warehouse System because they provide a flexible and 
	  efficient way to present data                                            

*/
	
