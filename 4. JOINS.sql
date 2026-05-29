/*						JOINS				
TO combine COLUMNS between Table A (left) and Table B (right)
	- Requisite: KEY column
	- Types: inner join, full join, left join, right join
	- Case uses:
		1. Recombine data (Big picture)
		2. Data enrichment (Extra info)
		3. Check existence (Filtering)
*/
--======================BASICS======================--
		--NO JOIN--			return data from 2 tables without combining 
SELECT *
FROM customers;
SELECT *
FROM orders;

		--INNER JOIN-- | return matching rows from 2 tables | order doesn't matter | combine, filter
SELECT 
	c.id,					-- Best practices include selecting only the needed columns
	c.first_name,			-- Also, specifying the origin table of each column
	o.order_id,
	o.sales
FROM customers AS c			-- Can also use an ALIAS for convinience
INNER JOIN orders AS o
ON c.id = o.customer_id			-- Common column (KEY column)

		--LEFT JOIN-- | return all rows from left, matching from right | order matter | combine, enrich
SELECT
	c.id,					
	c.first_name,				
	o.order_id,
	o.sales
FROM customers AS c			
LEFT JOIN orders AS o
ON c.id = o.customer_id					--if no info, it adds NULL

		--RIGHT JOIN-- | return all rows from right, matching from left | order matter | combine, enrich
SELECT
	c.id,					
	c.first_name,			
	o.order_id,
	o.sales
FROM customers AS c			
RIGHT JOIN orders AS o				--inverse of LEFT JOIN, not used.
ON c.id = o.customer_id					

		--FULL JOIN-- | return EVERYTHING from both tables | order doesn't matter | combine
SELECT
	c.id,					
	c.first_name,			
	o.order_id,
	o.sales
FROM customers AS c			
FULL JOIN orders AS o				
ON c.id = o.customer_id	

--======================ADVANCED======================--
		--LEFT ANTI JOIN-- | return rows that are only part of left table | order matter | filter
SELECT *
FROM customers AS c			
LEFT JOIN orders AS o				
ON c.id = o.customer_id					--first check both tables
	WHERE o.customer_id IS NULL		--then check for exclusion 

		--RIGHT ANTI JOIN-- | return rows that are only part of right table | order matter | filter
SELECT *
FROM customers AS c			
RIGHT JOIN orders AS o				
ON c.id = o.customer_id					--not really used, always preffer left
	WHERE c.id IS NULL			

			--FULL ANTI JOIN-- | return unmatched rows, inner opposite | order doesn't matter | filter
SELECT *
FROM customers AS c			
FULL JOIN orders AS o				
ON c.id = o.customer_id					
	WHERE 
		c.id IS NULL OR o.customer_id IS NULL		--both keys must be NULL, use OR

			--CROSS JOIN-- | return every possible combination of rows | simulation, testing
SELECT *
FROM customers
CROSS JOIN orders					--order is not important


