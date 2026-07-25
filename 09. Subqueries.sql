/*                               | • | ○ | ■ | □ |
☲☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰ SubQuery ☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☲
	• A query inside another query. Sometimes nested queries
	• Importance: 
		○ Reduce complexity, improve understanding, dividing a process in steps.
	• Categories: 
		○ Based on dependancy:
			■ Non-Correlated Subquery  ■ Correlated Subquery
		○ Based on result types:
			■ Scalar Subquery  ■ Row Subquery  ■ Table Subquery
		○ Based on location/causes:
			■ SELECT  ■ FROM  ■ JOIN  ■ WHERE  
										□ Comparison operators
										□ Logical operators

═════════════════════════════════════ Result Types ═════════════════════════════════════ */
SELECT
	AVG(Sales)                          -- Scalar Query
FROM Sales.Orders

SELECT
	CustomerID                          -- Row Query
FROM Sales.Orders

SELECT
	OrderID,   
	CustomerID,                         -- Table Query
	Sales
FROM Sales.Orders
/*
═════════════════════════════════════ Location/Clause ═════════════════════════════════════ 
───────────────────────────────────── FROM Clause ───────────────────────────────────── */
	-- Used as temporary table for the main query
SELECT 
	*
FROM(
	SELECT 
		Product,
		Price,
		AVG(Price) OVER() AvgPrice
	FROM Sales.Products
	)t
WHERE Price>AvgPrice

SELECT 
	*
FROM(
	SELECT 
		Product,
		Price,
		AVG(Price) OVER() AvgPrice
	FROM Sales.Products
	)t
WHERE Price>AvgPrice

SELECT 
	*,
	DENSE_RANK() OVER(ORDER BY TotalCustomerSales DESC) Ranking
FROM(
	SELECT 
		CustomerID,
		SUM(Sales) TotalCustomerSales
	FROM Sales.Orders
	GROUP BY CustomerID
	)t
/*
───────────────────────────────────── SELECT Clause ───────────────────────────────────── */
	-- Used to aggregate data side by side with the main query's data. Allowing direct comparison
	-- Subquery MUST be SCALAR
SELECT 
	ProductID,
	Product,
	Price,
	(SELECT COUNT(*) FROM Sales.Orders) AS TotalOrders
FROM Sales.Products
/*
───────────────────────────────────── JOIN Clause ───────────────────────────────────── */
	-- Used to prepare the data (filter or aggregation) before joining with other tables
SELECT 
	c.*,
	o.CustomerTotalOrders
FROM Sales.Customers c
LEFT JOIN(
	SELECT 
		CustomerID,
		COUNT(*) AS CustomerTotalOrders
	FROM Sales.Orders
	GROUP BY CustomerID
		 ) o
ON c.CustomerID = o.CustomerID
/*
───────────────────────────────────── WHERE Clause ───────────────────────────────────── */
	-- Used for complex filtering logic. Makes queries more flexible and dynamic.

------ Comparison Operators: Subquery MUST be SCALAR

SELECT *
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products)

------ IN Operator: Checks whether a value matches any value from a list. Only works with equal operators. MUST be ROW Subquery

SELECT *
FROM Sales.Orders
WHERE CustomerID IN (SELECT CustomerID 
					 FROM Sales.Customers 
					 WHERE Country='Germany')

SELECT *
FROM Sales.Orders
WHERE CustomerID NOT IN (SELECT CustomerID 
					 FROM Sales.Customers 
					 WHERE Country='Germany')

------ ALL & ANY Operator: Checks if a value matches ANY or ALL values from a list. Works with all comparison operators. MUST be ROW Subquery

SELECT *
FROM Sales.Employees
WHERE GENDER = 'F' AND Salary > ANY (SELECT 
										 Salary
									 FROM Sales.Employees
									 WHERE Gender='M')

SELECT *
FROM Sales.Employees
WHERE GENDER = 'M' AND Salary > ALL (SELECT 
										 Salary
									 FROM Sales.Employees
									 WHERE Gender='F')

/*
═════════════════════════════════════ Dependancy ═════════════════════════════════════ 
───────────────────────────────────── Non-Correlated ───────────────────────────────────── 
• Subquery that can run independently from the Main Query
• Subquery is executed once and the result is used in the Main Query. Can be executed on its own
• Easier to read and write
• Executed only once leads to better performance
• Used for static comparisons, filtering with constants
───────────────────────────────────── Correlated ───────────────────────────────────── 
• Subquery that relies on values from the Main Query                                   
• Subquery is executed for EACH row processed by the Main Query. CAN'T be executed on its own
• Harder to read and more complex
• Executed multiple times leads to BAD performance
• Used for Row-by-Row Comparison, Dynamic Filtering                                            */

SELECT
	*,
	(SELECT COUNT(*) FROM Sales.Orders AS o WHERE o.CustomerID = c.CustomerID) TotalOrderSales
FROM Sales.Customers AS c

------ EXISTS Operator: checks if a subquery returns any rows. 
	-- No result? Row of the Main Query is excluded | Returns value? Row of the Main Query is included

SELECT *
FROM Sales.Orders AS o
WHERE EXISTS (SELECT 1 FROM Sales.Customers AS c								-- When working with EXISTS, the value doesn't matter.
			  WHERE Country = 'Germany' AND o.CustomerID = c.CustomerID)        -- Only if it exists, so its best practices to use 1





