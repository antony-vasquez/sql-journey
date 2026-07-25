/*                               | • | ○ | ■ | □ |
☲☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰ Common Table Expressions (CTE) ☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☲
	• Temporary, named result set (virtual table)
	• Importance: 
		○ Can be used MULTIPLE times within your main query. Simplifies and organizes complex queries.
		○ Differences with subqueries: Can be used multiple times, reduces redundandcy, (CTE --> Main Query) | (Main query --> Subquery)
		○ Characteristics: Readability, modularity, reusability
	• Categories: 
		○ None-Recursive CTE:
			■ Standalone CTE  ■ Nested CTE
		○ Recursive CTE
	• SYNTAX: WITH CTE_Name AS ( SELECT FROM WHERE )
	• Best practices: try to not overuse CTES, merge them, rethink and refactor.

═════════════════════════════════════ None-Recursive ═════════════════════════════════════ 
───────────────────────────────────── Standalone CTE ───────────────────────────────────── */
	-- Defined and used independently. As is self-contained, doesn't rely on others CTEs or queries
WITH CTE_TotalSales AS (
	SELECT
		CustomerId,
		SUM(Sales) TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
	)
SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cte.TotalSales
FROM Sales.Customers as c
LEFT JOIN CTE_TotalSales cte
ON cte.CustomerID = c.CustomerID
/*
───────────────────────────────────── Multiple Standalone CTE ───────────────────────────────────── */
WITH CTE_TotalSales AS(
	SELECT
		CustomerId,
		SUM(Sales) TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
	),
	 CTE_LastOrder AS(
	SELECT
		CustomerID,
		MAX(OrderDate) AS Last_Order
	FROM Sales.Orders
	GROUP BY CustomerID
	)
SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cte.TotalSales,
	cte2.Last_Order
FROM Sales.Customers as c
LEFT JOIN CTE_TotalSales cte
ON cte.CustomerID = c.CustomerID
LEFT JOIN CTE_LastOrder cte2
ON cte2.CustomerID = c.CustomerID
/*
───────────────────────────────────── Nested CTE ───────────────────────────────────── */
	-- CTE inside another CTE. It can't run independently
WITH CTE_TotalSales AS(
	SELECT
		CustomerId,
		SUM(Sales) TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID
	),
	 CTE_LastOrder AS(
	SELECT
		CustomerID,
		MAX(OrderDate) AS Last_Order
	FROM Sales.Orders
	GROUP BY CustomerID
	),
	 CTE_RankingSales AS(
	SELECT
		CustomerID,
		DENSE_RANK() OVER(ORDER BY TotalSales DESC)RankSales
	FROM CTE_TotalSales
	)
	,
	 CTE_CustomerSegmentation AS(
	SELECT
		CustomerID,
		CASE
			WHEN TotalSales>100 THEN 'High'
			WHEN TotalSales>50 THEN 'Medium'
			ELSE 'Low'
		END CustomerSegments
	FROM CTE_TotalSales
	)
SELECT
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cte.TotalSales,
	cte2.Last_Order,
	cte3.RankSales,
	cte4.CustomerSegments
FROM Sales.Customers as c
LEFT JOIN CTE_TotalSales cte
ON cte.CustomerID = c.CustomerID
LEFT JOIN CTE_LastOrder cte2
ON cte2.CustomerID = c.CustomerID
LEFT JOIN CTE_RankingSales cte3
ON cte3.CustomerID = c.CustomerID
LEFT JOIN CTE_CustomerSegmentation cte4
ON cte4.CustomerID = c.CustomerID
ORDER BY RankSales
/*
═════════════════════════════════════ Recursive CTE ═════════════════════════════════════
	• Self-referencing query that repeats until a specific condition is met.
	• Recommended when working with hierarchy.

	• SYNTAX: WITH CTE_Name AS ( SELECT FROM WHERE                          [anchor query]
								 UNION ALL 
								 SELECT FROM CTE_Name WHERE BreakCondition) [recursive query]
───────────────────────────────────── Sequence of numbers ───────────────────────────────────── */
WITH Series AS (
	SELECT 
		1 AS MyNumber        -- Anchor query
	UNION ALL
	SELECT
		MyNumber + 1         -- Recursive query
	FROM Series     
	WHERE MyNumber<100
	)
SELECT *
FROM Series
OPTION(MAXRECURSION 100)
/*
───────────────────────────────────── Employee hierarchy ──────────────── */
WITH CTE_Hierarchy AS(
	SELECT
		EmployeeID,
		FirstName,
		ManagerID,
		1 AS Level
	FROM Sales.Employees
	WHERE ManagerID is NULL
	UNION ALL
	SELECT
		e.EmployeeID,
		e.FirstName,
		e.ManagerID,
		Level + 1
	FROM Sales.Employees as e
	INNER JOIN CTE_Hierarchy ceh
	ON e.ManagerID = ceh.EmployeeID
	)
SELECT *
FROM CTE_Hierarchy