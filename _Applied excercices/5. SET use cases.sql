-- USE CASE: Combine info --
SELECT 'Order' as SourceTable
      ,[OrderID]
	  ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM SALES.Orders
UNION
SELECT 'OrderArchive' as SourceTable
      ,[OrderID]
	  ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
FROM SALES.OrdersArchive

-- USE CASE: Delta detection -- : Use EXCEPT to only add new columns to a Data Warehouse or Data lake

-- USE CASE: Data completeness check -- : use EXCEPT to check if there's data left to move (use both ways) 
                                         -- Output should be double empty
