/*										 | • | ○ | ■ | □ |

	• At the logical level of the database architecture, we find tables:
		○ DB Table: structured collection of data in rows and columns, similar to a spreadsheet.
			■ Table types
				□ Permanent tables: CREATE / INSERT | CTAS
				□ Temporary tables										

☲☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰ Create Table As Select (CTAS) ☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☲

	• CREATE/INSERT vs CTAS: 
		○ CREATE/INSERT: 1. Define structure of table | 2. Insert data into table	| From the scratch
		○ CTAS: Create a new table based on the result of a SQL query               | From other table

	• VIEWS vs CTAS: 
		○ VIEWS: Still hasn't been executed | Slower |  Auto-updates  | Not Stored
		○ CTAS: Has been executed already   | Faster | Needs updating | Stored

	• Syntax: 
		○ CREATE TABLE TABLE_NAME AS (SELECT FROM WHERE) [Postgres/MySQL]
		○ SELECT INTO Table_Name FROM WHERE [SSMS]
				 
════════════════════════════════════════════ USE CASES ══════════════════════════════════════════════ 
─────────────────────────────────────── Optimize performance ──────────────────────────────────────── 
	• Store permantently central, complex query logic, for access by multiple queries								*/	

--Refresh CTAS-------------------------------------
IF OBJECT_ID('Sales.MonthlyOrders','U') IS NOT NULL
	DROP TABLE Sales.MonthlyOrders;
GO
SELECT
	DATENAME(month,OrderDate) OrderMonth,
	COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(month,OrderDate)

--Select-------------------------------------------
SELECT * FROM Sales.MonthlyOrders

/*
──────────────────────────────────────────── Snapshots ──────────────────────────────────────────────  
	• When trying to fix a problem, can serve as a snapshot of the moment to prevent confusion in the analysis		

────────────────────────────────────────── Data Warehouse ─────────────────────────────────────────── 				
	• CTAS can be used as PERSISTENT Data Marts in Data Warehouse System because they provide a faster
	  retrieval of data compared to using views

*//*
☲☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰ Temporary (TEMP) Tables ☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☲

	• Stores intermediate results in temporary storage within the database ONLY during the session.

	• Syntax: 
		○ SELECT INTO #Table_Name FROM WHERE [SSMS]																    */

--Create TEMP Table -------------------------------------
SELECT 
	*
INTO #Orders
FROM Sales.Orders
--Query TEMP Table --------------------------------------
SELECT *
FROM #Orders

--Make TEMP Table Permanent -----------------------------
SELECT *
INTO Sales.OrdersTest
FROM #Orders

/*	
════════════════════════════════════════════ USE CASES ══════════════════════════════════════════════ 

─────────────────────────────────────── Intermediate results ────────────────────────────────────────
	• When doing tests or ETL. Use TEMP tables is a good idea before making real changes to a table.

*/
	
