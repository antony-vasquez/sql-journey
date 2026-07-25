/*									WHERE operators: 
		- Comparison = <> > >=
		- Logical AND OR NOT
		- Range BETWEEN
		- Membership IN NOT IN
		- Search LIKE
--Condition: expression - operator - expression 
		-- expression being column, value, function, expression or even subquery
*/
		--Comparison operators--
SELECT *
FROM customers
WHERE country<>'Germany' --Being not equal to

SELECT *
FROM customers
WHERE score>=500

		--Logical operators--  OR [optative] | AND [restrictive] | NOT [Inverse]
SELECT *
FROM customers
WHERE country='USA' OR score>500

SELECT * 
FROM customers
WHERE NOT score<500

		--Range operators--     BETWEEN [must be used with AND] \ can be overlapped by just inversing the logical manually
SELECT *
FROM customers
WHERE score BETWEEN 100 AND 500

		--Membership operators--    checks existence \ efficient way when comparing to a extense list
SELECT *
FROM customers
WHERE country IN ('Germany', 'USA')  --also NOT IN for the opposite

		--SEARCH operators--    looks for a pattern
--For creating a pattern, we use % [Anything] or _ [Exact match]
SELECT * 
FROM customers
WHERE first_name LIKE 'M%' --'M' then anything

SELECT *
FROM customers
WHERE first_name LIKE '%r%' --'r' ANYWHERE

SELECT *
FROM customers
WHERE first_name LIKE '__r%' --'r' in second position


