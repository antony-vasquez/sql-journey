/*
Function: given an input, provides an output.
	Single-row: 1 input --> 1 output | String, numeric, date & time, null
	Multi-row: n input --> 1 output | Aggregate, Window
*/
---------Date&Time function--------- Datetime (SQL Server) | Timestamp (Oracle, Postgres, MySQL)
-- Year/Month/Day | Hours:minutes:seconds
-- Uses: Part extraction, Format changes, Calculations, Validations
-- Dateparts: year, quarter, month, dayofyear, day, weekday, week, iso_week, hour, minute, second, ms, msc, ns, isowk

------Part extraction------
---DAY/MONTH/YEAR--- Extract day, month or year | Output: int
SELECT 
	OrderID,
	CreationTime,
	YEAR(CreationTime) YEAR,
	MONTH(CreationTime) MONTH,
	DAY(CreationTIme) DAY
FROM Sales.Orders

---DATEPART--- Extract specific part from a date (hour, week, quarter, weekday) | Output: int
SELECT 
	OrderID,
	CreationTime,
	DATEPART(HOUR, CreationTime) HOUR,
	DATEPART(QUARTER, CreationTime) QUARTER,
	DATEPART(WEEKDAY, CreationTime) WEEKDAY,
	DATEPART(WEEK,CreationTime) WEEK
FROM Sales.Orders

---DATENAME--- Extract NAME OF a specific part from a date | Output: str
SELECT 
	OrderID,
	CreationTime,
	DATENAME(MONTH, CreationTime) MONTH,
	DATENAME(DAY, CreationTime) DAY, --although the same result, this one is str, the other int
	DATENAME(WEEKDAY, CreationTime) WEEKDAY
FROM Sales.Orders

---DATETRUNC--- Truncate the date to a specified part | Output: datetime
SELECT 
	OrderID,
	CreationTime,
	DATETRUNC(Day,CreationTime) DayTruncated
FROM Sales.Orders

---EOMONTH--- Returns last day of the month | Output: date
SELECT 
	OrderID,
	CreationTime,
	EOMONTH(CreationTime) LastDay
FROM Sales.Orders

------Format & Casting------ SQL Format (ISO 8601): yyyy-MM-dd HH-mm-ss | Format: looks; Cast: datatype
---FORMAT--- Formats a date or time value | Usecase: date aggregation (customize for presentation), standarization (one format)
SELECT
	OrderID,
	CreationTime,
	FORMAT(CreationTime,'dddd') dd,
	FORMAT(CreationTime,'MM-dd-yyyy') USAstd,
	FORMAT(CreationTime,'dd-MM-yyyy') EUstd,
	FORMAT(CreationTime,'dd ddd MMM Q1 yyyy HH:mm:ss tt')
FROM Sales.Orders

---CONVERT--- Converts to a different datatype & formats 
SELECT
	CreationTime,
	CONVERT(INT,'123') AS [String to INT convert],
	CONVERT(DATE,'2025') AS [String to DATE convert],
	CONVERT(DATE,CreationTime) AS [Datetime to DATET convert],
	CONVERT(VARCHAR,CreationTime,32) AS [USA.std.Style:32],
	CONVERT(VARCHAR,CreationTime,34) AS [EU.std.Style:34]
FROM Sales.Orders

---CAST--- Converts to a different datatype 
SELECT
	OrderID,
	OrderDate,
	CreationTime,
	CAST(OrderID AS VARCHAR),
	CAST(OrderID AS FLOAT),
	CAST(OrderDate AS DATE)
FROM Sales.Orders

------Calculations------
---DATEADD--- ADDS or SUBSTRACTS an specific time interval from a date	
SELECT
	OrderDate,
	DATEADD(YEAR, 2, OrderDate) AS '+2YEARS',
	DATEADD(MONTH,-4,OrderDate) AS '-4MONTHS'
FROM Sales.Orders

---DATEDIFF--- Find differences between two dates
SELECT
	OrderDate,
	ShipDate,
	DATEDIFF(DAY,OrderDate,ShipDate)
FROM Sales.Orders

SELECT 
	BirthDate,
	DATEDIFF(YEAR,BirthDate,GETDATE()) AS Employee_Age
FROM Sales.Employees

SELECT
	MONTH(OrderDate),
	AVG(DATEDIFF(DAY,OrderDate,ShipDate)) AvgShip
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

------Validations------
---ISDATE--- Check if a value is a date
SELECT 
	ISDATE('123') DateCheck1,
	ISDATE('2025') DateCheck2,
	ISDATE('20-08-2025') DateCheck3,
	ISDATE('08-20-2025')DateCheck4