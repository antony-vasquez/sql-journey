/*										 | • | ○ | ■ | □ |
☲☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰ Partitioning ☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☲

	• Divides big tables in smaller partitions while still being treated as a single logical table.
		○ Generally done by date. Helps with performance, reduce size of big indexes
				 
════════════════════════════════════════ PARTITION FUNCTION ═════════════════════════════════════════

	• Define the logic on how to divide the data into partitions. Based on partition key
		○ Set the boundaries. Between them partitions will be formed.
		○ Set the logic:
			■ Right: boundary closed to the right
			■ Left: boundary closed to the left	

	• They're not attached to a specific table. Its a logic to the DB


────────────────────────────────────────── Filegroups ───────────────────────────────────────────────
	• Logical container of one or more data files to help organize partitions

*/	
-- 1. Create a PARTITION Function-------------------------------------

CREATE PARTITION FUNCTION PartitionByYear (DATE)
AS RANGE LEFT FOR VALUES ('2023-12-31', '2024-12-31', '2025-12-31')

-- Query existing PARTITION Functions---------------------------------

SELECT 
	name,
	function_id,					-- Check if there is already a similar partition function
	type,
	type_desc,
	boundary_value_on_right
FROM sys.partition_functions

-- 2. Create filegroups ----------------------------------------------

ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;						-- For deleting, change ADD for REMOVE

-- Query existing filegroups -----------------------------------------
SELECT *
FROM sys.filegroups					-- Check if there is already a similar filegroup
WHERE type='FG'

-- 3. Create datafiles -----------------------------------------------

ALTER DATABASE SalesDB ADD FILE
(
	NAME=P_2023, -- Logical name
	FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2023.ndf'
) TO FILEGROUP FG_2023;

ALTER DATABASE SalesDB ADD FILE
(
	NAME=P_2024, -- Logical name
	FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2024.ndf'
) TO FILEGROUP FG_2024;

ALTER DATABASE SalesDB ADD FILE
(
	NAME=P_2025, -- Logical name
	FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2025.ndf'
) TO FILEGROUP FG_2025;

ALTER DATABASE SalesDB ADD FILE
(
	NAME=P_2026, -- Logical name
	FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\P_2026.ndf'
) TO FILEGROUP FG_2026;

-- Query datafiles for the database ----------------------------------

SELECT 
	fg.name AS FileGroupName,
	mf.name AS LogicalFileName,
	mf.physical_name AS PhysicalFilePath,
	mf.size / 128 AS SizeInMB
FROM sys.filegroups fg
JOIN sys.master_files mf ON fg.data_space_id = mf.data_space_id
WHERE mf.database_id = DB_ID('SalesDB')

-- 4. Create PARTITION Scheme ----------------------------------------

CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023,FG_2024,FG_2025,FG_2026)			-- Order is VERY IMPORTANT; there is +1 filegroups than boundaries	

-- Query list ALL partition scheme -----------------------------------

SELECT
	ps.name AS PartitionSchemeName,
	pf.name AS PartitionFunctionName,
	ds.destination_id AS PartitionNumber,
	fg.name AS FilegroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds ON ps.data_space_id= ds.partition_scheme_id
JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id

-- 5. Create PARTITION Table -----------------------------------------

CREATE TABLE Sales.Orders_Partitioned
(
	OrderID INT,
	OrderDate DATE,
	Sales INT
) ON SchemePartitionByYear(OrderDate)

-- 5. Insert data on PARTITION Table ---------------------------------

INSERT INTO Sales.Orders_Partitioned VALUES (1,'2023-05-15',100); -- It is important to test the boundaries

SELECT * FROM Sales.Orders_Partitioned


-- Query NUMBER of rows in each partitions  --------------------------
SELECT
	p.partition_number AS PartitionNumber,
	f.name AS PartitionFi1egroup,			-- important to check that the logic is working
	p.rows AS NumberOfRows
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'Orders_Partitioned';