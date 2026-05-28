	--SELECT--
SELECT *         --all
FROM customers   --table

SELECT 
	id,
	country,
	score            --column name
FROM customers;

	--WHERE-- filter BEFORE aggregation
SELECT * 
FROM customers
WHERE score !=0  --Filtering by column condition

SELECT *
FROM customers
WHERE country='Germany' --Filtering by string

	--ORDER BY--
SELECT *
FROM customers
ORDER BY score ASC      --or DESC

SELECT*
FROM customers
ORDER BY
	country ASC, score DESC  --Nested sorting

	--GROUP BY & HAVING-- aggregation and filter AFTER aggregation
SELECT						 --Only SELECT columns that are part of the group by 
	country,
	SUM(score) AS total_score --AGGREGATION function
FROM customers
GROUP BY country

SELECT
	country,
	SUM(score) AS total_score,
	COUNT(first_name) AS number_customers
FROM customers
GROUP BY country

SELECT
	country,
	AVG(score) as avg_score
FROM customers
WHERE score!=0
GROUP BY country
HAVING AVG(score)>430

	--DISTINCT-- remove duplicates
SELECT DISTINCT
	country
FROM customers
	--TOP-- head rows
SELECT TOP 3 *
FROM customers
ORDER BY score DESC