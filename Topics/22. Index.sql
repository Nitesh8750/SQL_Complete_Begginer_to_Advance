# Index
# Data Structure provides quick access to data, optimizing the speed of your queries
# An Index in MySQL is a powerful tool used to speed up the retrieval of rows from a table. 
# Without an index, MySQL must perform a Full Table Scan (reading every single row) to find the data you want.

/*
Index Type
1. Structure
	1.1 Clustered Index
    1.2 Non-Clustered Index
2. Storage
	2.1 RowStore Index
    2.2 ColumnStore Index
3. Functions
	3.1 Unique Index
    3.2 Filtered Index

*/

# Note :- 
# Table is stored in database in Data files where values(data) are stored as Pages
# A Data File contains multiple Pages which store data in rows


# Page :- The smallest unit of data storage in a database (8kb)
# It can stores anything(Data, Metadata, Index, etc)
# type of Page
# 1. Data Page
# 2. Index Page
/*
		 _________________________________________________	0				-- Here 1 Is Data File ID
	|---|	Header 			1 : 150						  |  				-- 150 is Page Number which is unique
	|	|_________________________________________________|	96 bytes		-- Header has fixed size of 96 bytes		
	|	| Row 1		|	1, Bob, USA						  | 118 bytes		-- Row 1 from 96-118 bytes
	|	| Row 2		|	2, Ana, Germany					  | 140 bytes		-- Row 2 from 118-140
	|	| Row 3		|	3, Lisa, Italy					  |
	8	|							.					  |
	kb	|							.					  |
	|	|							.					  |
	|	|_______________________________3_______2_____1___|
	|	|	Offset 					|  140	|  118	| 96  |  -- this is like a quick index of the rows, it tells where the specific rows begins
	|---|___________________________|_______|_______|_____|

# The whole page size is 8 kb

Heap Storage 
When tables are store wihout clusteres index 
when rows are stoed randomly not in a partcular order
in this type of table, we can easily insert new data , but we try to search any particular row than it will take extra time and some time
give error

In this case when user try to find any data, than sql will search every data page to find that row and searching all data pages till
it get that row this type of searching is called Table full scan

Full table Scan :- Scans the entire table page by page and row by row, search for data

Index page :- It stores key value(Pointers) to another index page or data page. It doesn't store the actual rows

		_________________________________________________				
		|				 1 : 150						 |  				
		|________________________________________________|		
		|			1---->	(1 is key)	: 150			 | 
		|	1 : 150 is value (Points to data page		 | 

This Index page is Intermediate Nodes
*/

-- **************************************************************************************************************************************

# 1. Structure

# 1.1 Clustered Index
# in this type of index the data are stored in a orders from low value to high value in a data page like 1-20
# The data are stored like stored in decision tree 
# Firtly their is a root node then their are multiple Intermediate nodes to root node and 
# down their are many Leaf nodes to each intermediate nodes

# the acutal data pages are stored at Leaf level that means all data are stored at last level
# the Index pages are stored Intermediate Node that index data pages
# the root will be a index page that indexes all intermediate nodes



# 1.2 Non Clustered Inedex
# A non-clustered index won't reorganize or change anything on the data page

/*		_________________________________________________				
		|				 1 : 200						 |  				
		|________________________________________________|		
*/
# in this type of index user has to more specified to extract the data 

# here 
# (1 --------->   1        :   102          		:  96) : 200  ---- this is called Row indentifier (RID)
# Customer ID	   File ID    data Page number		Row offset(means from where the row 1 starts)


# in this type index, the actual data page is located at the base level, which is not the part of B-Tree.
# At the leaf level the index pages are pointing towrads the data page, every index points towards the some data pages and 
# At the intermediate level , another index pages are pointing towards the the leaf index pages
# At the root node, the index page   are pointing towards the intermediate pages.

/*
Diference
Clustered Index: This is the table. The data rows are stored in the exact same order as the index. 
				Because the data is sorted by this index, you can only have one per table.
                it is like Table of content at the first page of book and it gives the sorted and organized order of data
                We can create only 1 clustered index in a table, because physically can be sorted only in one way

Non-Clustered Index: This is a separate list that points back to the data. 
					It contains the indexed columns and a "pointer" to the actual row. You can have many of these on a single table.
                    It is like Index at the last page of book, which gives you the details list of topics, terms, keywords where it 
                    points exactly where it locates in the book, and the topic of the book is not sorted
                    The Leaf level at the Non clustered Index can points towards the data pages of clustered index in a table,
                    we can create multiple non clustered index in a table
  
  
Feature					Clustered Index										|				Non-Clustered Index
Data Storage			Stores the actual data rows in the leaf nodes.		|		Stores pointers (addresses) to the data rows.
Quantity					Only one per table.								|				Multiple (up to 64 in MySQL).
Search Speed			Extremely fast (it goes directly to the data).		|	Slightly slower (must find the pointer, then fetch the data).
Primary Key			In MySQL the Primary Key is always the Clustered Index.	|	Used for non-primary columns (e.g., Email, LastName).
File Size				Does not take extra space (it is the table).		|	Takes additional disk space for the separate index file.
Use Cases					Unique Column									|	Column frequently used in search conditions and joins			
							Not frequently modified Column					|	Exact match queries
							Improve range query performance					|


								Clustered 	B-Tree												Non Clustered B-Tree

Root Node 							Index Page														Index Page
										|																|
							____________|___________										____________|___________
Intermediate			Index Page				Index Page								Index Page				Index Page
Nodes						|							|									|							|
							|							|									|							|
							|							|									|							|
				____________|____________		  ______|________					________|____________		  ______|________
Leaf Level		Data Page			Date Page	Data Page		Data Page		Index Page		Index Page		Index Page		Index Page
																					|		\		|			/	|			/	|
																					|			\	|		/		|		/		|
Base Level																		Data Page		 Data Page      Data Page        Data Page
                                        
                   
  1. The Leaf level at the Non clustered Index can points towards the data pages of clustered index in a table,     
  2. We can create only 1 clustered index in a table, because physically can be sorted only in one way, But we can create 
		multiple non clustered index in a table
*/


/*
Syntax:-

# In MySQL (specifically using the InnoDB storage engine), the syntax is a bit unique because 
# the database handles the "Clustered" part automatically. You don't usually type the word CLUSTERED like you would in SQL Server.

# 1. Clustered Index Syntax
# In MySQL, the Primary Key is automatically the Clustered Index. You cannot define a Clustered Index separately from the Primary Key.

-- Option A: Defining it during table creation
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY, -- This is your Clustered Index
    FirstName VARCHAR(50),
    LastName VARCHAR(50)
);

-- Option B: Adding it to an existing table
ALTER TABLE Employees ADD PRIMARY KEY (EmployeeID);

Note: If you don't define a Primary Key, MySQL will pick the first UNIQUE index with non-null columns. 
If that doesn't exist, it creates a hidden internal Clustered Index (RowID) for you.


2. Non-Clustered Index Syntax
These are treated as "Secondary Indexes." You can create as many as you need (within reason) on any column.
-- Option A: Using CREATE INDEX (Most common)
CREATE INDEX idx_lastname ON Employees(LastName);

-- Option B: Using ALTER TABLE
ALTER TABLE Employees ADD INDEX idx_firstname (FirstName);

-- Option C: Unique Non-Clustered Index
CREATE UNIQUE INDEX idx_email ON Employees(Email);


3. Composite Index (Non-Clustered)
A non-clustered index can also cover multiple columns to speed up complex WHERE clauses.

CREATE INDEX idx_full_name ON Employees(LastName, FirstName);


-- TO Check index in a table
SHOW INDEX FROM Employees;

*/

Use data_with_baraa;

SHOW INDEX FROM Orders_sales;  -- it gives clustered index

-- heap
CREATE TABLE DBCustomers AS 
SELECT * FROM employees;

-- this table has structure of Heap structure, the data in the table are randomly inserted and are not sorted
-- it has heap clustered 

select * from DBCustomers;

# 1. Create Clustered Index

-- Currently this table doesn't have any clustered index 
show index from DBCustomers;

-- In MySQL, the Clustered Index is the Primary Key. You cannot create a clustered index using the CREATE INDEX statement. 
-- To make a column the clustered index, you must define it as the PRIMARY KEY.]

-- To turn CustomerID into the clustered index for your DBCustomers table, use the ALTER TABLE command:
alter table DBCustomers add Primary key(EmployeeID);

# 2. Create Non Clustered Column

select * from DBcustomers;

select * from DBcustomers
where LastName = 'Baker';

Create index idx_DBCustomers_Lastname on DBcustomers (LastName);


select * from DBcustomers
where FirstName = 'John';

create index idx_DBcutomers_Firstname on DBcustomers (FirstName);

show index from DBCustomers;


# 3. Create Composite non Clustered Column

select * from DBcustomers where
Department = 'Sales' and Salary > 50000;

create index idx_DBcustomers_Department_Salary on DBcustomers (Department, Salary);

-- Rule :- The coulmns of index order must match the order in your query
-- Leftmost Prefix Rule :- Index works only if your query filters start from the first column in the index and follow its orders 

select * from DBcustomers where
Department = 'Sales';

select * from DBcustomers where
Salary > 50000;

/*
Example:-

Suppose we have 4 column in composite non clustered column than (A,B,C,D)

-- for index will be used
A
A,B
A,B,C
	
-- for index will no used
B
A,C
A,B,D

*/

-- **************************************************************************************************************************************

# 2. Storage

# 1. Rowstore Index (The "Standard" Move)
# Rowstore is the traditional way MySQL and most relational databases store data. Data is stored row by row. 
# If you have an Employees table, all information for "John Doe" (ID, Name, Salary, Dept) is kept together in one block.
# Best for: OLTP (Online Transactional Processing). used in Commerce, banking, Fiancial Systems, Order processing, etc
# Strengths: Fast at finding, inserting, or updating a single record.
# Weakness: Slow for massive "Big Data" math. If you want to sum the salaries of 10 million rows, 
# 			the database still has to read the Names, IDs, and Birthdays just to get to the Salary column.
            

# 2. Columnstore Index (The "Analytics" Move)
# Columnstore flips the table on its side. It stores all values for a single column together in one block. 
# All "Salaries" are in one spot, all "Departments" are in another.
# Best for: OLAP (Online Analytical Processing) and Data Warehousing. Used in Data Warehousing, Business Intelligence, Reporting, Analytics, etc
# Strengths: Incredible at aggregations (SUM, AVG, COUNT). Because the data is similar (all numbers or all dates), 
#			it can be compressed much more tightly than rowstore data.
# Weakness: Very slow at updating or deleting a single specific row, 
#			as the database has to jump to multiple different locations to find all the pieces of that person's data.
            

/*
Feature							Rowstore Index														Columnstore Index
Physical Layout					Row 1, Row 2, Row 3...												Col A, Col B, Col C...
Primary Use						Daily CRUD (Insert/Update/Delete)								Heavy Reporting / Analytics(Aggregation)
I/O Efficiency					Reads the whole row												Only reads the columns in the SELECT
Compression						Low																		High (often 10x better)
Analogy							A Spreadsheet printed row by row								A Spreadsheet cut into vertical strips

*/

# This is a "peer-to-peer" correction: Standard MySQL (InnoDB) does not natively support Columnstore indexes. 
# If you are using standard MySQL, you are using Rowstore. 

/*

As default the heap storage system is row-wise-row store index ( heap storegae = RowStore). Data page is same for both

How to store by Columnstore index

Suppose we have a 2 Million table data (ID, Name, Status)
as default the table is stored as heap sturcture where the row are stored row - wise - row inside data pages
 
# 1. Row Grops 
Now firstly the table is divided into two 1 Million rows each, it is used for better performance and parallel processing

# 2. Column Segement
in this step the table is splitted by the nuber of columns, like ( ID, Name, Status)

ID			Name 				Status

# 3. Data Compression
data compression can be done by many ways, but for most famous step
it creates a dictionary for all reapeated value
like here we have a Status column, in this column we have two string values (Active , Inactive) for all rows for 2 Million times,
and it takes lot of Space, thats why we assign 1 as Active and 2 as Inactive,
now it will compressed all repeated values into just 2 values and size is also reduced

this proces will happen for every column which has repeated columns


# 4. Store
the sql will use special data page to store these results called as LOB Page (Large Object Page)

Lob page	Lob page		Lob page
ID			Name			Status
1			a				 1
2			b				 2
3			c
4			d
5			|	
6			|
7
8
|
|


Difference between storing system

RowStore				Data Page
		___________________________________________________	0				-- Here 1 Is Data File ID
	|---|	Header 			1 : 150						  |  				-- 150 is Page Number which is unique
	|	|_________________________________________________|__ 96 bytes		-- Header has fixed size of 96 bytes		
	|	| Row 1		|	1, Bob, USA						  |__ 118 bytes		-- Row 1 from 96-118 bytes
	|	| Row 2		|	2, Ana, Germany					  |__ 140 bytes		-- Row 2 from 118-140
	|	| Row 3		|	3, Lisa, Italy					  |
	8	|							.					  |
	kb	|							.					  |
	|	|							.					  |
	|	|_______________________________3_______2_____1___|
	|	|	Offset 					|  140	|  118	| 96  |  -- this is like a quick index of the rows, it tells where the specific rows begins
	|---|___________________________|_______|_______|_____|



ColumnStore				LOB Page
		_________________________________________________	0				
	|---|	Header 			1 : 200						  |  			Dictionary Page	
	|	|_________________________________________________|			____________________
	|	| Segement Header								  | 		|	1 : 050			|
	|	| 	1. Segment ID = 1							  | 		|___________________|
	|	| 	2. Rowgroup ID = 20							  |			|	'A' --> 1		|
	8	|	3. Dictionay Id = 1 : 050					  |---------|	'B' --> 2		|
	kb	|												  |			|___________________|
	|	|_________________________________________________|												  
	|	|	Data Stream									  |
	|	|	[1,1,2,2,1,2,1,1,1,--------2,1,1]			  |	
	|---|_________________________________________________|
    
    
It will create a LOG page for every Column that means for Status column, we data stream is [1,2,1,2,1,1,2,1] beacuse we have only two values

types of ColumnStore Index:-

1. Clustered Columnstore Index
A Clustered Columnstore Index (CCI) isn't just an index on the table; it is the table. 
When you create one, the row-based storage is deleted, and the data is compressed and stored in a column-based format.
    
Structure: Data is divided into "Row Groups" (usually 1 million rows each). Inside each group, data is sliced into "Column Segments."
Purpose: This is the default for Fact Tables (huge tables with millions/billions of rows).
The Move: It provides massive compression (often 10x) because similar data is stored together.
Limitation: You can only have one per table because it represents the physical storage of the data.


2. Non-Clustered ColumnStore Index
A Non-Clustered ColumnStore Index (NCCI) is a functional "buddy" to a standard Rowstore table. 
You keep your table in its normal row-by-row format for fast updates, 
but you build a Columnstore index on top of specific columns for fast reporting.

Structure: A separate, compressed copy of the selected columns.
Purpose: Best for Real-Time Analytics. It allows you to run "Heavy Math" (SUM/AVG) on a table that is still being used for regular "Inserts/Updates."
The Move: The database engine is smart enough to use the Rowstore for looking up a single person and the Columnstore for calculating total revenue.
Update Cost: When you update a row in the main table, the database must also update the NCCI, which can slow down write performance.

Feature							Clustered ColumnStore (CCI)								Non-Clustered ColumnStore (NCCI)
Physical Storage				The table is stored as columns.							The table stays as rows; index is a copy.
Main Benefit					Maximum compression & scan speed.						High-speed analytics on a live transactional table.
Quantity						Only one per table.										Can exist alongside Rowstore indexes.
Updates/Inserts					Optimized for bulk loads.								Slower due to maintaining two storage formats.

*/


# Syntax
# MySQL (InnoDB) is a Rowstore-only engine, it does not have a CREATE COLUMNSTORE INDEX command. 
# However, if you are using MariaDB (MySQL's popular sibling) or SQL Server, the syntax is specific.

# for by default at a time of creating index, we are creating rowstore index
# here we are creating a rowstore index
create index idx_DBcustomers_Department_Salary on DBcustomers (Department, Salary);


# Difference

-- heap index
CREATE TABLE DBCustomers AS 
SELECT * FROM employees;

-- rowstore index
CREATE TABLE DBCustomers AS 
SELECT * FROM employees;

alter table DBCustomers add Primary key(EmployeeID);

# because rowstore index is clustered index, so we just need to create a clustered index

show index from DBcustomers;


-- ***************************************************************************************************************************************

# 3. Functions

# 1. Unique Index 
# A Unique Index ensures that no two rows in a table have the same value in the indexed column(s). 
# It is both a performance tool and a data integrity constraint.
# The Move: It speeds up searches, but its primary job is to stop you from entering duplicate data (like two users with the same email address)
# NULLs: In MySQL, a Unique Index allows multiple NULL values because NULL is technically "unknown," 
# 			and one unknown cannot be equal to another unknown.
# Benefits :- Enforce Uniqueness and Slightly increase query performance
# Writing to an unique index is slower than non-unique
# Reading from an unique index is faster than non-unique

# syntax
CREATE UNIQUE INDEX idx_unique_email ON Employees(Email);


select * from products;

create unique index idx_unique_product on Products(ProductId);
# it has all unique count so it doesn't give error when i creating index

create unique index idx_unique_category on Products(Category); 
# it has does not have unique values so it gives error when i creating index

show index from products;

-- to drop index
drop index idx_unique_product_category on products;

# We can not even insert any duplicate value to the table after creating the unique index, it gives errors otherwise



# 2. Filtered Index
# A Filtered Index (also called a Partial Index) is a non-clustered index that has a WHERE clause applied to it. 
# Instead of indexing every single row in the table, it only indexes the rows that meet a certain condition.
# The Move: This makes the index much smaller and faster. It’s perfect for columns where you only care about a specific status 
#			(e.g., "Active" users or "Unpaid" invoices).
# Standard MySQL Note: Standard MySQL (InnoDB) does not natively support the WHERE clause in a CREATE INDEX statement. 
# 						This feature is common in SQL Server, PostgreSQL, and SQLite.
# Benefits :- Targeted Optimization and Reduce Storage : Less data in the index

# MYSQL does n't support this Function becasuse MySQL doesn't have a WHERE clause for indexes

# But we apply methods to use Filtered Index

# You can index a result of a function. 
# Question -- If you want to index only "Delivered" Orders on Orders_sales table:

CREATE INDEX idx_delivered_only 
ON orders_Sales
((
CASE 
	WHEN Orderstatus = 'Delivered' THEN OrderID
	ELSE NULL 
END));

show index from orders_sales;

EXPLAIN SELECT * FROM orders_Sales 
WHERE (CASE WHEN Orderstatus = 'Delivered' THEN OrderID ELSE NULL END) IS NOT NULL;

-- This query likely WON'T use your functional index!
EXPLAIN SELECT * FROM orders_Sales WHERE Orderstatus = 'Delivered';

select * from Orders_sales
where Orderstatus = 'Delivered';

select * from Orders_sales
where Orderstatus = 'Shipped';



/*
Feature							Unique Index															Filtered Index
Main Goal					Prevent duplicate data.											Speed up specific, frequent queries.
Size						Large (Includes all rows).										Small (Includes only "filtered" rows).
Maintenance					Updates on every insert/change.								Only updates if the filtered condition is met.
MySQL Support				Full Support.													No native support (requires Workaround).
*/



/*
When To Use which indx type

Heap :- Fast Inserts ( for staging tables)
Clustered Index :- for Primary Key ( If not, then for date column)
Non Clustered Index :- For non-PK columns (Foreign Keys, Joins, and Filters)
Columnstore index :- For analytical queries, Reduce size of large table
Filtered Index :- Target Subset of Data, Reduce size of Index
Unique index :- Enforce Uniqueness and Improve Query speed
*/

-- **************************************************************************************************************************************


-- List all index on a specific table
SELECT 
    INDEX_NAME AS 'Index Name',
    COLUMN_NAME AS 'Column',
    INDEX_TYPE AS 'Structure',
    IF(NON_UNIQUE = 0, 'Unique', 'Non-Unique') AS 'Constraint',
    CARDINALITY AS 'Distinct Values',
    IS_VISIBLE AS 'Is Active',
    EXPRESSION AS 'Functional Logic'
FROM 
    information_schema.STATISTICS
WHERE 
    TABLE_NAME = 'DBCustomers' 
    AND TABLE_SCHEMA = DATABASE(); -- Limits to your current database

# this will give user the discription of index in a tables




# information_schema (system schema) : contains metadata about database tables, views, indexes, etc.

# In MySQL, the system information is stored in the information_schema. 
# If you want to see a list of every index in your current database (the "Master List"), you use the STATISTICS table.

SELECT  
    TABLE_NAME,  
    INDEX_NAME,  
    COLUMN_NAME,  
    INDEX_TYPE, 
    NON_UNIQUE 
FROM  
    information_schema.STATISTICS  
WHERE  
    TABLE_SCHEMA = 'data_with_baraa' 
LIMIT 0, 1000; -- 'DATABASE()' picks your current active DB

-- **************************************************************************************************************************************


# Index Management and Monitoring

# Index Management

# 1. Monitor Index Usage (Finding Dead Weight)
# Indexes speed up reads, but they slow down writes (INSERT, UPDATE, DELETE). 
# If an index is never used by your queries, it is just wasting disk space and slowing down your database.

-- Check for indexes that have been completely ignored since the server last restarted.
SELECT 
    object_schema AS 'Database', 
    object_name AS 'Table', 
    index_name AS 'Unused Index'
FROM 
    sys.schema_unused_indexes
WHERE 
    object_schema = 'data_with_baraa'; -- Replace with your DB name

# this will all unused index list


# 2. Monitor Missing Index (Finding Full Table Scans)
# Unlike SQL Server, MySQL does not explicitly say, "Hey, you are missing an index on Column X." 
# Instead, MySQL tells you which queries and tables are suffering because they are being forced to do Full Table Scans (reading every single row).

-- Find which tables are desperately crying out for an index.
SELECT 
    object_schema AS 'Database', 
    object_name AS 'Table', 
    rows_full_scanned AS 'Total Rows Scanned'
FROM 
    sys.schema_tables_with_full_table_scans
WHERE 
    object_schema = 'data_with_baraa'
ORDER BY 
    rows_full_scanned DESC;



# 3. Monitor Duplicates Indexes
# Sometimes developers accidentally create overlapping indexes (e.g., an index on (LastName) and another on (LastName, FirstName)). 
# The first one is entirely redundant because the second one covers it via the Leftmost Prefix Rule.

-- Ask MySQL to find these overlapping mistakes.
SELECT 
    table_schema AS 'Database', 
    table_name AS 'Table', 
    redundant_index_name AS 'Redundant Index', 
    dominant_index_name AS 'Covering Index (Keep this)'
FROM 
    sys.schema_redundant_indexes
WHERE 
    table_schema = 'data_with_baraa';


# 4. Update Statistics
# MySQL uses "Statistics" (a rough map of your data distribution) to decide which index to use. 
# If you just loaded 5 million new rows into a table, the statistics are outdated, and MySQL might choose a bad execution plan.

-- Force MySQL to recalculate the table's statistics.
ANALYZE TABLE DBCustomers;



# 5. Monitor & Fix Fragmentation (The "Swiss Cheese" Problem)
# When you DELETE or UPDATE a lot of rows, it leaves empty "holes" in your data pages on the hard drive. This is called fragmentation. 
# It makes your table physically larger than it needs to be and slows down index scans.

-- Check the DATA_FREE column to see how much empty space (in bytes) is trapped inside your tables.
SELECT 
    TABLE_NAME, 
    ENGINE, 
    ROUND(DATA_LENGTH/1024/1024, 2) AS 'Actual Data (MB)', 
    ROUND(DATA_FREE/1024/1024, 2) AS 'Fragmented Space (MB)' 
FROM 
    information_schema.TABLES 
WHERE 
    TABLE_SCHEMA = 'data_with_baraa' 
    AND DATA_FREE > 0
ORDER BY 
    DATA_FREE DESC;
   
/*  
When to defragment
< 10% No action needed
10-30% Reorganize
> 30% Rebuild the whole index

-- to reorganize the index
alter index idx_name on table_name Reorganize;

-- to rebuild the index
alter index idx_name on table_name Rebuild;
*/

-- *************************************************************************************************************************************

# Execution Plan
# Roadmap generated by a database on how it will execute your query step by step
# The Execution Plan is the roadmap MySQL uses to find your data. When you send a query, the Optimizer looks at your indexes, 
# the size of your tables, and the distribution of your data to decide the "cheapest" (fastest) way to get the result.

# In MySQL, you see this roadmap using the EXPLAIN command

# 1. How to Run an Execution Plan
# Simply put EXPLAIN (or DESCRIBE) in front of any SELECT, INSERT, UPDATE, or DELETE statement.

use data_with_baraa;
EXPLAIN SELECT * FROM orders_sales
WHERE OrderDate = '2025-01-20' AND Sales > 100;

select * from orders_Sales;


EXPLAIN SELECT * FROM orders_sales WHERE OrderStatus = 'Delivered';

/*
2. Reading the "Big Three" Columns
When you run the command above, MySQL returns a table. These three columns are the most important for a DBA:

A. type (The Speedometer)
This tells you how MySQL is joining or searching the table.
system / const: The best. Found exactly 1 row (usually via Primary Key).
eq_ref / ref: Very good. Using an index to find a small range of rows.
range: Good. Scanning a specific part of an index (e.g., WHERE ID > 10).
index: Bad. It’s scanning the entire index tree.
ALL: The worst. A Full Table Scan. MySQL is reading every single row on the disk.

B. key (The Tool)
This tells you which index MySQL actually chose.
If this is NULL, MySQL is not using an index at all.
If it shows the wrong index, you might need to use FORCE INDEX or rewrite your query.

C. rows (The Cost)
This is an estimate of how many rows MySQL thinks it has to examine.
If your table has 1 million rows and rows says 1,000,000, your query is slow.
If it says 10, your query is optimized.

*/

# 3. The "New School" Way: EXPLAIN ANALYZE
# In MySQL 8.0.18+, the standard EXPLAIN only shows estimates. If you want to know what actually happened during execution, use EXPLAIN ANALYZE.

EXPLAIN ANALYZE SELECT * FROM orders_sales WHERE Sales > 100;

/*
This will actually run the query and provide:
Actual time to get the first row.
Actual time to get all rows.
Actual number of loops the engine performed.
*/

EXPLAIN ANALYZE SELECT * FROM orders_sales WHERE OrderStatus = 'Delivered';