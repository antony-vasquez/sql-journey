/*
Function: given an input, provides an output.
	Single-row: 1 input --> 1 output | String, numeric, date & time, null
	Multi-row: n input --> 1 output | Aggregate, Window
*/
---------NULL functions--------- 
	-- ISNULL, COALESCE, NULLIF | Useful to replace values
	-- IS NULL, IS NOT NULL | Check for NULLs

---ISNULL(value, replacement_value[static/column])--- Replaces NULL with a specified value
	--Limited to two values, fast, SQL server-->ISNULL, Oracle-->NVL, MySQL-->IFNULL

---COALESCE(value 1, value 2, value 3[static/column])--- Return the first not-NULL value from a list [Preffered]
	--Unilimited values, slow, avaliable in all databases

	---CASE USES:
	--Handling NULL: Data Aggregation
		SELECT
			CustomerID,
			Score,
			COALESCE(Score,0) Score2,
			AVG(Score) OVER() AvgScores,
			AVG(COALESCE(Score,0)) OVER() AvgScores2
		FROM Sales.Customers
	
	--Handling NULL: Mathematic Operations
		SELECT
			CustomerID,
			FirstName,
			LastName,
			CONCAT(COALESCE(FirstName,'N/A'),' ',COALESCE(LastName,'N/A')) AS FullName,
			Score,
			AVG(Score) OVER() AvgScore,
			COALESCE(Score,AVG(Score) OVER()) + 10 ScorePlus --Inputar con la media :D
		FROM Sales.Customers

	--Handling NULL: Joining Data
		SELECT
			c.CustomerID,
			c.Score,
			o.OrderID,
			o.ShipDate,
			o.ShipAddress
		FROM Sales.Customers as c
		LEFT JOIN Sales.Orders as o
		ON c.CustomerID=o.CustomerID
		AND ISNULL (c.CustomerID,' ') = ISNULL(o.CustomerID,' ') --Not in this cases, but can be for two keys

	--Handling NULL: Sorting Data
		SELECT 
			CustomerID,
			Country,
			Score,
			CASE WHEN Score IS NULL THEN 1 ELSE 0 END AS Flag
		FROM Sales.Customers
		ORDER BY Flag ASC

---NULLIF--- Compare two values, if theyre equal NULL, else, first value.
SELECT
	CustomerID,
	Country,
	COALESCE(Score,AVG(Score) OVER()) AS Score,
	NULLIF(CustomerID,5) AS CheckID
FROM Sales.Customers

SELECT
	OrderID,
	Sales,
	Quantity,
	Sales/NULLIF(Quantity,0) AS Price		--preventing from dividing with 0
FROM Sales.Orders

---ISNULL/ISNOTNULL--- Returns TRUE if NULL, else FALSE (boolean)| Lookout for NULLS | Very important for ANTIjoin
SELECT *
FROM Sales.Customers
WHERE Score IS NULL

SELECT *
FROM Sales.Customers
WHERE Score IS NOT NULL

SELECT 
	c.*,
	o.OrderID
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL