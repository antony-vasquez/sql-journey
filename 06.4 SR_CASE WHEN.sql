/*
Function: given an input, provides an output.
	Single-row: 1 input --> 1 output | String, numeric, date & time, null
	Multi-row: n input --> 1 output | Aggregate, Window

---------CASE Statement--------- Evalues a list of conditions and returns a value when the first condition is met
		Main use is Data Transformation, to derive new information
Syntax:
	CASE
		WHEN Condition1 THEN Result1
		WHEN Condition1 THEN Result2
		ELSE Result3					[Optional]
	END			
Rules: Datatypes of the output MUST match
Use Cases: Categorizing Data, Mapping Values, Handling Nulls, Conditional Aggregation
																								*/
---USE CASE: Categorizing Data--- Group the data in categorie based on certain conditions
SELECT
	Category,
	SUM(Sales) AS TotalSales
	FROM(
		SELECT 
			OrderID,
			Sales,
			CASE 
				WHEN Sales>50 THEN 'High'
				WHEN Sales>20 THEN 'Medium'
				ELSE 'Low'
			END AS Category
		FROM Sales.Orders
	)t
GROUP BY Category
ORDER BY TotalSales DESC

---USE CASE: Mapping Values--- Transform the values from one form to another
SELECT
	EmployeeID,
	FirstName,
	LastName,
	Gender,
	CASE
		WHEN Gender = 'F' THEN 'Female'
		WHEN Gender = 'M' THEN 'Male'
		ELSE 'Not available'
	END GenderFullText
FROM Sales.Employees

SELECT
	CustomerID,
	FirstName,
	LastName,
	Country,
		--
		CASE
			WHEN Country = 'Germany' THEN 'DE'
			WHEN Country = 'USA' THEN 'US'
			ELSE 'Not available'
		END CountryShort,
		--
		CASE Country					--Can be used only with one column name and only with the equal
			WHEN 'Germany' THEN 'DE'
			WHEN 'USA' THEN 'US'
			ELSE 'Not available'
		END CountryShort
		--
FROM Sales.Customers;

SELECT DISTINCT
	Country
FROM Sales.Customers

---USE CASE: Handling Nulls--- Replace NULLS with a specified VALUE
SELECT
	CustomerID,
	LastName,
	Score,
	CASE
		WHEN Score IS NULL THEN 0
		ELSE Score
	END ScoreClean,
	AVG(CASE
			WHEN Score IS NULL THEN 0
			ELSE Score
		END) OVER() AvgCustomerClean,
	AVG(Score) OVER() AvgCustomer
FROM Sales.Customers

---USE CASE: Conditional Aggregation--- Aggregate functions only on subsets of data that fulfill certain conditions
SELECT
	CustomerID,
	SUM(CASE
			WHEN Sales>30 THEN 1
			ELSE 0
		END
		) TotalOrders,
	COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID