/*						SET				
TO combine COLUMNS between Table A (left) and Table B (right)
	- Requisite: Same COLUMNS
	- Types: union, union all, except, intersect
	- Syntax: 1st SELECT statement / SET / 2nd SELECT statement
----Rules
	#1 SET operator can be used with almost all clauses, except ORDER BY (only once at the end of the query)
	#2 Number of columns must be the same
	#3 Datatypes must be compatible between columns
	#4 Order in columns in each query must be the same
	#5 Column names in the result are determined by the column names of the first query
	#6 Always check outputs, since context matters even when no error is displayed by SQL
				BEST PRACTICES NEVER USE * ALWAYS SPECIFY THE COLUMNS                               */	
--------UNION-------- return ALL distinct rows from both queries | removes duplicates

SELECT FirstName, LastName
FROM Sales.Customers
UNION
SELECT FirstName, LastName
FROM Sales.Employees

--------UNION ALL-------- return ALL rows from both queries | includes duplicates | efficient process

SELECT FirstName, LastName
FROM Sales.Customers
UNION ALL							--USE all when sure about don't having duplicates, or to check for them 
SELECT FirstName, LastName
FROM Sales.Employees

--------EXCEPT-------- return distinct rows from first query | order does matter 

SELECT FirstName, LastName
FROM Sales.Customers
EXCEPT							
SELECT FirstName, LastName
FROM Sales.Employees

--------INTERSECT-------- return common rows | shows duplicates

SELECT FirstName, LastName
FROM Sales.Customers
INTERSECT					
SELECT FirstName, LastName
FROM Sales.Employees
