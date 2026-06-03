/*
Function: given an input, provides an output.
	Single-row: 1 input --> 1 output | String, numeric, date & time, null
	Multi-row: n input --> 1 output | Aggregate, Window
*/
---------String functions---------
------Manipulation: concat, upper, lower, trim, replace
---CONCAT--- combine multiple string values into one value
SELECT 
	first_name, 
	country,
CONCAT(first_name,' ', country) AS name_country
FROM customers

---UPPER/LOWER--- stitch string values between upper/lower-case
SELECT 
	first_name, 
	country,
UPPER(first_name) AS name_uc,
LOWER(country) AS country_lc
FROM customers

---TRIM--- removes leading and trailing spaces
SELECT 
	first_name, 
	country
FROM customers
WHERE first_name <> TRIM(first_name) --PROMPT to check for spaces

---REPLACE--- replaces specific character with a new character (also can used to remove)
SELECT 
'123-456-789' AS phone,
REPLACE('123-456-789','-',' ') AS clean_phone

SELECT
'report.txt' AS old_filename,
REPLACE('report.txt','.txt','.csv') as new_filename

------Calculation: LEN | returns string lenght
SELECT 
	first_name,
	country,
LEN(first_name) AS len_name
FROM customers

------String extraction: left, right, substring

---LEFT/RIGHT--- extracts specific amount of characters from the start/end
SELECT 
	first_name, 
	country,
LEFT(TRIM(first_name),2) AS name_2firsts,
RIGHT(country,3) AS country_3lasts
FROM customers

---SUBSTRING--- extracts a part of a string at a specified position
SELECT 
	first_name, 
	country,
SUBSTRING(TRIM(first_name), 2,LEN(first_name)) AS sub_name  --Use LEN instead of static value to give dynamic lenght
FROM customers

---------Number functions---------
---ROUND--- rounds to a given decimal places
SELECT 
	3.516,
	ROUND(3.516,2) AS round_2,
	ROUND(3.516,1) AS round_1,
	ROUND(3.516,0) AS round_0
FROM customers

---ABS--- calculates the absolute value
SELECT 
	-10 as v,
	ABS(-10) as abs_v
FROM customers