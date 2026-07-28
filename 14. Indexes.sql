/*										 | • | ○ | ■ | □ |

☲☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰ Index ☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☰☲

	• Data structure that provides quick access to data, optimizing speed of queries.

	• No index default: ROWSTORE HEAP TABLE

	• Types of indexes
		○ By structure
			■ Clustered		■ Not clustered
		○ By storage
			■ Rowstore		■ Columnstore
		○ By functions
			■ Unique		■ Filtered

═══════════════════════════════════════════ Choose INDEX ════════════════════════════════════════════

	• HEAP: Fast inserts (for staging tables)
	• CLUSTERED INDEX: For primary keys (if not, date columns)
	• CLUSTERED INDEX: For non-primary keys (Foreign keys, joins, filters)
	• COLUMNSTORE INDEX: For big analytical queries, reduce the size of large tables
	• FILTER INDEX: Target subset of data. Reduce size of index
	• FILTER INDEX: Enforce Uniqueness. Improve query speed

══════════════════════════════════════════ Heap Structure ═══════════════════════════════════════════
	
	• Page: smallest unit of data storage in a database (8kb), stores data, metadata, indexes, etc.

		○ Index page: Stores key values (pointers) to another page. Doesn't store actual rows.

		○ Data page: Header, rows, offset

	• Heap: table WITHOUT Clustered Index | Fast to write, slow to read [Full table scan]

═══════════════════════════════════════════ By Structure ════════════════════════════════════════════

	• Clustered index: Table of contents | Stores data | Only one and faster to read | Slower to write | Reorders
		○ Case uses: Unique column, not frecuently modified column, improve range query performance

	• Non clustered index: Final index   | Pointers to data | Multiple and slower to read | Faster to write | Aditional
		○ Case uses: Columns frequently used in search conditions and joins, exact match in queries

────────────────────────────────────────── Clustered Index ────────────────────────────────────────── 
	• Physically arrange each row based on the column specified. From lowest to highest.

	• Balance tree: hierarchical structure storing data at leaves, to help quickly locate data
		○ Parts:
			■ Leaf level: data pages
			■ Intermediate nodes: index pages
			■ Root node: main index page

──────────────────────────────────────── Not Clustered Index ────────────────────────────────────────
	• Won't reorganize or change anything on the data page. Assign for each id, a map a pointer (RID)
		○ RID: Header:offset

	• Balance tree: hierarchical structure storing data at leaves, to help quickly locate data
		○ Parts:
			■ Base data pages: data pages (not part of the tree)
			■ Leaf nodes: index pages
			■ Intermediate nodes: index pages
			■ Root node: main index page
	
	• Syntax: CREATE CLUSTURED/NONCLUSTURED INDEX index_name ON table_name (column1, column2, ...)
		○ Examples:
			■ CREATE CLUSTURED INDEX IX_Customers_ID ON Customers (ID)
			■ CREATE NONCLUSTERED INDEX IX_Customers_City ON Customers (City)
			■ CREATE INDEX IX_Customer_Name ON Customers (LastName ASC, FirstName DESC)           -- Default: NONCLUSTERED		
	
		○ To delete an index use DROP INDEX [] ON Schema.TableName																						*/	

-- CREATE NEW TABLE -------------------------------------------
SELECT *
INTO Sales.DBCustomers
FROM Sales.Customers

-- HEAP STRUCTURE ---------------------------------------------
SELECT *
FROM Sales.DBCustomers
WHERE CustomerID = 1

-- CREATE CLUSTURED INDEX -------------------------------------
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers(CustomerID)

-- CREATE NON CLUSTURED INDEX ---------------------------------
CREATE INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers(LastName)

CREATE INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers(FirstName)

-- CREATE COMPOSITE INDEX ------------------------------------
SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500

CREATE INDEX idx_DBCustomers_CountryScore		-- To improve performance
ON Sales.DBCustomers(Country,Score)				-- Order of columns must be the same

	-- Leftmost prefix rule: Index works if the query filters start from the first column and follow its order

/*
════════════════════════════════════════════ By Storage ═════════════════════════════════════════════

	• Columnstore Index: Organizes and stores the data column by column in each datapage
		○ Characteristics: Less storage needed | Fast to read % Slow to write | Higher efficiency
		○ Use Cases: OLAP (analytical): data warehouse, business intelligence, reporting, analytics
					 Big Data Analytics, scanning for large datasets, fast aggregation

	• Rowstore Index: Organizes and stores the data row by row in each page [Default]
		○ Characteristics: More storage needed | Fair speed to read & write | Lower efficiency	
		○ Use Cases: OLTP (transactional): commerce, banking, finances, order processing
					 High frecuency transaction, quick access to complete records

──────────────────────────────────────── Columnstore Index ────────────────────────────────────────── 
	• Stores the data in columns

	• Columnstore Process
		○ Parts:
			■ 1. Row groups: divide the rowstore heap table in manageable quantity of rows
			■ 2. Column segment: divide the rows in columns
			■ 3. Compression: compress using a dictionary (DictionaryID: stores the maping)
			■ 4. Store: stores in a LoB Page

				□ LoB Page: Header; segment header: SegmentID, RowGroupID, DictionaryID; Data stream
	
	• Syntax: CREATE CLUSTURED/NONCLUSTURED [COLUMNSTORE] INDEX index_name ON table_name (column1, column2, ...)
		○ Examples:
			■ CREATE CLUSTURED COLUMNSTORE INDEX IX_Customers_ID ON Customers			          -- Rule: Don't specify columns
			■ CREATE NONCLUSTERED COLUMNSTORE INDEX IX_Customers_City ON Customers (City)
			■ CREATE INDEX IX_Customer_Name ON Customers (LastName ASC, FirstName DESC)           -- Default: ROWSTORE		
	
		○ To delete an index use DROP																						*/	


-- DROP PREVIOUS CLUSTURED INDEX ---------------------------------
DROP INDEX [idx_DBCustomers_CustomerID] ON Sales.DBCustomers

-- CREATE NEW COLUMNSTORE CLUSTURED INDEX ------------------------
CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
ON Sales.DBCustomers

/*
═══════════════════════════════════════════ By Functions ════════════════════════════════════════════

	• Unique Index: Ensures no duplicates exist in specific column. 
		○ Characteristics: Fast to read % Slow to write | Helps uniqueness and improves performance
		○ Use Cases: 

	• Filter Index: Includes only rows meeting the specified conditions. 
		○ Characteristics: Uses less space | Helps with targeted optimization
		○ Use Cases: 

────────────────────────────────────────── Clustered Index ────────────────────────────────────────── 
	• Ensures no duplicates exist in specific column.

	• Syntax: CREATE [UNIQUE] [CLUSTURED/NONCLUSTURED] [COLUMNSTORE] INDEX index_name ON table_name (column1, column2, ...)	
		○ Default: NOT UNIQUE
*/

CREATE UNIQUE NONCLUSTERED INDEX idx_Product_Product
ON Sales.Products(Product)

INSERT INTO SALES.Products (ProductID, Product) VALUES (106, 'Caps')  -- This won't work as a unique index exists

/*
──────────────────────────────────────────── Filter Index ─────────────────────────────────────────── 
	• Includes only rows meeting the specified conditions.

	• Syntax: CREATE [UNIQUE] [NONCLUSTURED] INDEX index_name ON table_name (column1, column2, ...)	
			  WHERE [Condition]
		○ Default: NOT UNIQUE 
		○ Don't work with CLUSTEREDED or COLUMNSTORE

*/

CREATE NONCLUSTERED INDEX idx_Customers_Country
ON Sales.Customers(Country)
WHERE Country = 'USA'

INSERT INTO SALES.Products (ProductID, Product) VALUES (106, 'Caps')  -- This won't work as a unique index exists