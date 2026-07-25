/*										 | • | ○ | ■ | □ |
☲☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰ Stored Procedures ☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☲
	
	• Storing SQL statements into database. Works like a program.
		○ Can have: Loops, control flow, parameters, error handling					   

	• Store Procedures vs Queries 
		○ Store Procedures: multiple requests
		○ Query: one time request

	• Store Procedures vs Python
		○ Store Procedures: it's part of the database | pre-compiled | flexible, better version control, easier to implement complex logics
		○ Python: needs a conection with the database | no compiled  |

		Disclaimer: DON'T USE STORED PROCEDURES IN BIG PROJECTS | Hard to test, debug | Always use Python

	• Syntax: 
		○ CREATE PROCEDURE ProcedureName @PARAMETER = 'X' AS      - If no parameter is given, use 'X'
		  BEGIN
			-- SQL Statement
		  END

		  EXEC ProcedureName																						*/	
				 
--CREATE A STORED PROCEDURE----------------------------
CREATE PROCEDURE GetUSACustomerSummary AS            -- TO ALTER/DROP use that functions
BEGIN
	SELECT 
		COUNT(*) TotalCustomers,
		AVG(Score) AvgScore
	FROM Sales.Customers
	WHERE Country = 'USA'
END

EXEC GetUSACustomerSummary

/*
────────────────────────────────────────── Parameters ─────────────────────────────────────────────── 
	• Placeholders used to pass values as input from the caller to the procedure, allowing dynamic data.			*/					

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN
	SELECT 
		COUNT(*) TotalCustomers,
		AVG(Score) AvgScore
	FROM Sales.Customers
	WHERE Country = @Country
END

EXEC GetCustomerSummary @Country = 'Germany'
EXEC GetCustomerSummary
/*
─────────────────────────────────────── Multiple queries ────────────────────────────────────────────
	• We can have multiple queries in one single procedure                                                			*/					

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' -- Predetermined value
AS
BEGIN
	SELECT 
		COUNT(*) TotalCustomers,
		AVG(Score) AvgScore
	FROM Sales.Customers
	WHERE Country = @Country;

	SELECT
		COUNT(OrderID) TotalOrders,
		SUM(Sales) TotalSales
	FROM Sales.Orders o
	JOIN Sales.Customers c
	ON o.CustomerID = c.CustomerID
	WHERE c.Country = @Country
END

EXEC GetCustomerSummary @Country = 'Germany'
EXEC GetCustomerSummary
/*
────────────────────────────────────────── Variables ────────────────────────────────────────────────
	• Placeholders used to store values to be used later in the procedure                                           */					

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN
	DECLARE @TotalCustomers INT, @AvgScore FLOAT;
		SELECT 
			@TotalCustomers = COUNT(*),
			@AvgScore = AVG(Score)
		FROM Sales.Customers
		WHERE Country = @Country;
	PRINT 'Total Customers from' + @Country + ':' + CAST(@TotalCustomers AS	NVARCHAR);
	PRINT 'Average Score from' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);
		SELECT
			COUNT(OrderID) TotalOrders,
			SUM(Sales) TotalSales
		FROM Sales.Orders o
		JOIN Sales.Customers c
		ON o.CustomerID = c.CustomerID
		WHERE c.Country = @Country
END

EXEC GetCustomerSummary @Country = 'Germany'
EXEC GetCustomerSummary

/*
───────────────────────────────────────── Control Flow ──────────────────────────────────────────────
	• Treating NULLS                                                                                                */					

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN

	DECLARE @TotalCustomers INT, @AvgScore FLOAT;

	IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
		BEGIN 
			PRINT('Updating NULL Scores to 0')
			UPDATE Sales.Customers
			SET Score = 0
			WHERE Score IS NULL AND Country = @Country
		END
	ELSE
		BEGIN
			PRINT('No Null Scores Found')
		END;

		SELECT 
			@TotalCustomers = COUNT(*),
			@AvgScore = AVG(Score)
		FROM Sales.Customers
		WHERE Country = @Country;

	PRINT 'Total Customers from' + @Country + ':' + CAST(@TotalCustomers AS	NVARCHAR);
	PRINT 'Average Score from' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

		SELECT
			COUNT(OrderID) TotalOrders,
			SUM(Sales) TotalSales
		FROM Sales.Orders o
		JOIN Sales.Customers c
		ON o.CustomerID = c.CustomerID
		WHERE c.Country = @Country
END

EXEC GetCustomerSummary @Country = 'Germany'
EXEC GetCustomerSummary

/*
──────────────────────────────────────── Error handling ─────────────────────────────────────────────
	• Placeholders used to store values to be used later in the procedure                                           */	

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN
BEGIN TRY
DECLARE @TotalCustomers INT, @AvgScore FLOAT;

IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
BEGIN 
	PRINT('Updating NULL Scores to 0')
	UPDATE Sales.Customers
	SET Score = 0
	WHERE Score IS NULL AND Country = @Country
END

ELSE
BEGIN
	PRINT('No Null Scores Found')
END;

-- Generating Reports

	SELECT 
		@TotalCustomers = COUNT(*),
		@AvgScore = AVG(Score)
	FROM Sales.Customers
	WHERE Country = @Country;

PRINT 'Total Customers from' + @Country + ':' + CAST(@TotalCustomers AS	NVARCHAR);
PRINT 'Average Score from' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

	SELECT
		COUNT(OrderID) TotalOrders,
		SUM(Sales) TotalSales,
		1/0
	FROM Sales.Orders o
	JOIN Sales.Customers c
	ON o.CustomerID = c.CustomerID
	WHERE c.Country = @Country
END TRY

BEGIN CATCH
	PRINT('An error occured.');
	PRINT('Error Message: ' + ERROR_MESSAGE());
	PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
	PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
	PRINT('Error Procedure: ' + ERROR_PROCEDURE());
END CATCH
END

EXEC GetCustomerSummary @Country = 'Germany'
EXEC GetCustomerSummary


/*
─────────────────────────────────────────── Styling ─────────────────────────────────────────────────               */	
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA'
AS
BEGIN
	BEGIN TRY
		-- Declare variables
		DECLARE @TotalCustomers INT, @AvgScore FLOAT;

		-- Prepare & Cleanup Data
		IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
			BEGIN 
				PRINT('Updating NULL Scores to 0')
				UPDATE Sales.Customers
				SET Score = 0
				WHERE Score IS NULL AND Country = @Country
			END
		ELSE
			BEGIN
				PRINT('No Null Scores Found')
			END;

		-- Generating Reports
			SELECT 
				@TotalCustomers = COUNT(*),
				@AvgScore = AVG(Score)
			FROM Sales.Customers
			WHERE Country = @Country;

		PRINT 'Total Customers from' + @Country + ':' + CAST(@TotalCustomers AS	NVARCHAR);
		PRINT 'Average Score from' + @Country + ':' + CAST(@AvgScore AS NVARCHAR);

			SELECT
				COUNT(OrderID) TotalOrders,
				SUM(Sales) TotalSales,
				1/0
			FROM Sales.Orders o
			JOIN Sales.Customers c
			ON o.CustomerID = c.CustomerID
			WHERE c.Country = @Country
	END TRY

	BEGIN CATCH
		PRINT('An error occured.');
		PRINT('Error Message: ' + ERROR_MESSAGE());
		PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
		PRINT('Error Procedure: ' + ERROR_PROCEDURE());
	END CATCH
END

EXEC GetCustomerSummary @Country = 'Germany'
EXEC GetCustomerSummary
/*

═══════════════════════════════════════════ Triggers ════════════════════════════════════════════════
	• Special stored procedure, that automatically runs in response to a specific event on table or view

	• Types:
		○ LOGGON
		○ DDL Triggers:
			■ AFTER			■ INSTEAD OF
		○ DML Triggers

	• Syntax: CREATE TRIGGER TriggerName ON TableName
			  AFTER INSERT/UPDATE/DELETE
			  BEGIN --SQL END

─────────────────────────────────── Use Case: Mantaining Logs ───────────────────────────────────────
	• Placeholders used to store values to be used later in the procedure                                           */	

CREATE TABLE Sales.EmployeeLogs (
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR(255),
	LogDate DATE
	)

-- Create the trigger
CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT AS
	BEGIN
		INSERT INTO Sales.EmployeeLogs(EmployeeID, LogMessage, LogDate)
		SELECT
			EmployeeID,
			'New Employee Added =' + CAST(EmployeeID AS VARCHAR),
			GETDATE()
			FROM INSERTED
	END

-- Trigger the trigger
INSERT INTO Sales.Employees VALUES
(6, 'Maria', 'Doe', 'HR', '1998-01-12','F',80000,3)

-- Check the logs
SELECT *
FROM Sales.EmployeeLogs











/* GENERAL SYNTAX
CREATE PROCEDURE Procedure_Name @Parameter DATATYPE(lenght) = 'Predetermined value'
AS
BEGIN
	BEGIN TRY
		-- DECLARE VARIABLES
		DECLARE @Variable1 INT, @Variable2 FLOAT;
		-- IF ELSE LOGIC
		IF EXISTS 'Condition'
			BEGIN 
				--Query
			END
		ELSE
			BEGIN
				--Query
			END;
		-- SELECT Statement
			SELECT FROM WHERE '' = @Parameter
			SELECT FROM WHERE
			JOIN ON
		-- PRINTING MESSAGES
		PRINT 'Hello' --Must be varchar
	END TRY
	-- ERROR MANAGEMENT
	BEGIN CATCH
		PRINT('An error occured.');
		PRINT('Error Message: ' + ERROR_MESSAGE());
		PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
		PRINT('Error Procedure: ' + ERROR_PROCEDURE());
	END CATCH
END
-- EXECUTE PROCEDURE
EXEC Procedure_Name @Parameter = ' '



