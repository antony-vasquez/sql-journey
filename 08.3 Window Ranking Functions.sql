/*
============================== WINDOW RANK FUNCTIONS ==============================

		F(_) OVER()

	- Argument MUST be EMPTY, except NTILE (n)
	- PARTITION is optional, ORDER BY is REQUIRED, FRAME not ALLOWED

	- Methods:
		- Integer-based ranking: top/bottom N analysis | discrete values
		F: ROW_NUMBER, RANK, DENSE_RANK, NTILE
		- Percentage-based ranking: distribution analysis | continuos values
		F: CUME_DIST, PERCENT_RANK
*/
---------------------------------- ROW_NUMBER ----------------------------------
	-- Asign a unique number to each row, DOESN'T handle ties (unique rankings)

------------------------------------- RANK -------------------------------------
	-- Asign a rank to each row, DOES handle ties (GAPS in RANKING)

---------------------------------- DENSE_RANK ----------------------------------
	-- Asign a rank to each row, DOES handle ties (NO GAPS in RANKING)

SELECT 
	OrderID,
	ProductID,
	Sales,
	Quantity,
	ROW_NUMBER() OVER(ORDER BY Sales ASC) F_RN,
	RANK() OVER(ORDER BY Sales ASC) F_RANK,
	DENSE_RANK() OVER(ORDER BY Sales ASC) F_DR
FROM Sales.Orders

/*
================================== CASE USES ==================================
	TOP/BOTTOM N Analysis: ANALYZE the top/bottom performers to do targeted marketing
*/
SELECT *
FROM(
	SELECT 
		OrderID,
		ProductID,
		Sales,
		ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY SALES DESC) TopAnalysis  -- DESC for TOP
	FROM Sales.Orders
	)t 
WHERE TopAnalysis = 1

SELECT *
FROM(
	SELECT
		CustomerID,
		SUM(Sales) TotalSales,
		RANK() OVER(ORDER BY SUM(Sales) ASC) Ranking  -- ASC for BOTTOM
	FROM Sales.Orders
	GROUP BY CustomerID
	)t 
WHERE Ranking <= 2

/*
================================== CASE USES ==================================
	Assign UNIQUE IDs: help to assing unique identifier for each row to help paginating
		- Paginating: the process of breaking down a large data into smaller, more manageable chunks
*/

SELECT 
	ROW_NUMBER() OVER(ORDER BY OrderID) UniqueID,
	*
FROM Sales.OrdersArchive

/*
================================== CASE USES ==================================
	Identifying duplicates: identify and remove duplicate rows to improve data quality
*/

SELECT * FROM(
SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) rn
	
FROM Sales.OrdersArchive ) t
WHERE rn<>1

----------------------------------- CUME_DIST -----------------------------------
	-- Cumulative Distribution calculates the distribution of datapoints within a window
		-- CUME_DIST = Position N / N rows
		-- Rule for tie: Position is the LAST occurence of the value. Same values share same CUMDIST

---------------------------------- PERCENT_RANK ---------------------------------
	-- Calculates the relative position of each row
		-- CUME_DIST = Position N - 1 / N rows - 1
		-- Rule for tie: Position is the FIRST occurence of the value. Same values share same PERCENTRANK

SELECT
	Product,
	Price,
	CUME_DIST() OVER(ORDER BY Price DESC) DistRank,
	PERCENT_RANK() OVER(ORDER BY Price DESC) RelativePosition
FROM Sales.Products

---------------------------------- NTILE ---------------------------------
	-- Divides the rows into a specified number of approximately equal groups (Buckets)
		-- Bucket size: Number of rows/Number of buckets
		-- Rule: if odd, larger groups come first
SELECT 
	OrderID,
	Sales,
	NTILE(1) OVER(ORDER BY Sales DESC) OneBucket, -- Bucket = 10
	NTILE(2) OVER(ORDER BY Sales DESC) TwoBuckets, -- Bucket = 5
	NTILE(3) OVER(ORDER BY Sales DESC) ThreeBuckets, -- Larger groups came first | Bucket = 3.333 so 2 groups of 3 and one of 4
	NTILE(4) OVER(ORDER BY Sales DESC) FourBuckets -- Larger groups came first | Bucket = 2.5 so 2 groups of 3 and 2 groups of 2
FROM Sales.Orders

/*
================================== CASE USES ==================================
	Data Segmentation: divides a dataset into distinct subsets based on certain criteria
	Equalizing Load Processing: 
*/

-- Data Segmentation ---------------------------------------------------------
SELECT 
	*,
	NTILE(3) OVER(ORDER BY Sales ASC) AMB,
	CASE 
		WHEN NTILE(3) OVER(ORDER BY Sales ASC) = 1 THEN 'Low'
		WHEN NTILE(3) OVER(ORDER BY Sales ASC) = 2 THEN 'Medium'
		ELSE 'High'
	END
FROM Sales.Orders

-- Equalizing Load ---------------------------------------------------------
SELECT 
	*,
	NTILE(2) OVER(ORDER BY OrderID) Buckets
FROM Sales.Orders