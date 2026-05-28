	             --DDL
	--CREATE--
CREATE TABLE persons(
	id INT NOT NULL, --name, datatype, constraint--
	person_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	phone VARCHAR(15) NOT NULL,
	CONSTRAINT pk_persons PRIMARY KEY(id)
)

	--ALTER--
ALTER TABLE persons 
ADD email VARCHAR(50) NOT NULL  --ADD--

ALTER TABLE persons
DROP COLUMN phone				--DROP--


	--DROP--
DROP TABLE persons              --CAREFUL--


	             --DML
	--INSERT--

INSERT INTO customers (id, first_name, country, score) --specify only if needed, can only skip NULL-allowed columns
VALUES 
	(6, 'Epstein', 'USA', 670),
	(7, 'Kris', 'Bolivia', NULL)
										--columns and values must match in order and qty

INSERT INTO persons(id, person_name, birth_date, phone) --INSERT w/ SELECT
SELECT 
	id,
	first_name,
	NULL,
	'Unknown'
FROM customers

	--UPDATE--
UPDATE customers
SET 
	score = 67,
	country = 'Peru'
WHERE id=7				--always use WHERE to prevent from UPDATING all rows at once

	--DELETE--
DELETE FROM customers
WHERE id>5              --always use WHERE to prevent from DELETING all rows at once

DELETE FROM persons		--functional but unoptimal

TRUNCATE persons		--most efficient way