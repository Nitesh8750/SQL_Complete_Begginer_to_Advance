# Partitioning

# It is a technique to divide a Big table into smaller Pieces, those pieces are called as Partitions

# Imagine you have a giant filing cabinet (your table) with 10 million receipts. 
# Finding one receipt from yesterday takes forever because the drawer is too heavy to open. 
# Partitioning is the act of splitting that giant drawer into smaller drawers labeled "2024", "2025", and "2026".

/*
Why do we Partition? (The "Pro Moves")
Partition Pruning (Massive Speed): If you run SELECT * FROM Sales WHERE SaleDate = '2025-05-01', 
									MySQL is smart enough to completely ignore the 2024 and 2026 partitions. 
                                    It only scans the 2025 chunk, making the query lightning fast.

Instant Deletion (Maintenance): Deleting 5 million rows of old data from 2020 using DELETE will lock your table and take hours. 
								If the data is partitioned, you can simply "drop the drawer" (ALTER TABLE Sales DROP PARTITION p2020), 
                                and the data is gone in 1 second.
*/

-- **************************************************************************************************************************************

# 4 Types of Partitioning
# MySQL supports four main ways to slice your data:

# 1. RANGE Partitioning (The most popular)
# Groups data based on a continuous range of values, usually dates or numbers.
# Best for: Time-series data, historical logs, financial records.

# In MySQL, RANGE Partitioning is the most common and practical way to slice a table. 
# It maps rows to partitions based on whether the value in a specific column falls within a given continuous range.

select * from orders_sales;

/*
Syntax

CREATE TABLE Orders (
    OrderID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2),
    PRIMARY KEY (OrderID, OrderDate)
)
PARTITION BY RANGE (YEAR(OrderDate)) (
    PARTITION p_old VALUES LESS THAN (2023),   -- Everything before 2023
    PARTITION p_2023 VALUES LESS THAN (2024),  -- Jan 1, 2023 to Dec 31, 2023
    PARTITION p_2024 VALUES LESS THAN (2025),  -- Jan 1, 2024 to Dec 31, 2024
    PARTITION p_future VALUES LESS THAN MAXVALUE -- Everything from 2025 onwards
);

*/

# When you define a Range partition, you use the VALUES LESS THAN operator. Each range must be defined in ascending order.
/*
Why "LESS THAN" Matters
The boundary value is exclusive.
VALUES LESS THAN (2024) includes every date up to 2023-12-31 23:59:59.
The very first second of 2024-01-01 will fall into the next partition.

The "MAXVALUE" Safety Net
If you don't include a MAXVALUE partition and you try to insert a record that falls outside your defined ranges (e.g., an order from 2026), 
MySQL will throw an error and the insert will fail.
Pro Tip: Always include a p_future partition with MAXVALUE to act as a "catch-all" bucket for data you haven't planned for yet.

When to use RANGE Partitioning?
This is the "Gold Standard" for three specific scenarios:
Time-Series Data: You have logs, sales, or sensor data and you frequently query by date (e.g., "Show me last month's totals").
Data Retention Policies: You only need to keep data for 3 years. Instead of running a heavy DELETE query, you just DROP PARTITION p_2021.
Large Scale Scans: You have 100 million rows, but your reports only ever look at the current quarter.

Performance Check: Partition Pruning
The biggest benefit of Range partitioning is Pruning. When you run a query, 
the MySQL Optimizer looks at your WHERE clause and "prunes" (ignores) the partitions that couldn't possibly contain your data.

EXPLAIN SELECT * FROM Orders WHERE OrderDate = '2024-05-15';

In the results, look at the partitions column. It should list only p_2024. 
This means MySQL didn't even "look" at the other years on the disk.


Limitations to Remember
The Primary Key Trap: Every column used in the partition expression must be part of every Unique Key and Primary Key on the table.
NULLs: In Range partitioning, NULL values are treated as if they are less than any other value. 
They will always fall into the lowest (first) partition.
*/


# I am creating an new table, while copying the orders_Sales table.

-- Step1 : Creating a table
CREATE TABLE partition_order (
    OrderID int NOT NULL,
    ProductID int,
    CustomerID int,
    SalesPersonID int,
    OrderDate date NOT NULL,
    ShipDate date,
    OrderStatus varchar(50),
    ShipAddress varchar(255),
    BillAddress varchar(255),
    Quantity int,
    Sales decimal(10,2),
    CreationTime datetime,
    PRIMARY KEY (OrderID, OrderDate)
) 
-- Step 2: Define the Partitions immediately
PARTITION BY RANGE (MONTH(OrderDate)) (
    PARTITION p_jan VALUES LESS THAN (2),   				-- Jan (Month 1)
    PARTITION p_feb VALUES LESS THAN (3),   				-- Feb (Month 2)
    PARTITION p_mar VALUES LESS THAN (4),   				-- Mar (Month 3)
    PARTITION p_future VALUES LESS THAN MAXVALUE			-- Rest value after Mar
);

-- Step 3. Inserting the date from orders_sales to partition_order

INSERT INTO partition_order 
SELECT * FROM orders_sales;

-- Step 4. Verify the Migration
# you can confirm that your existing 10 rows were successfully moved into their new homes

SELECT 
    PARTITION_NAME, 
    TABLE_ROWS 
FROM information_schema.PARTITIONS 
WHERE TABLE_NAME = 'partition_order' 
  AND TABLE_SCHEMA = DATABASE();
 
 
-- Step 5. Testing the "Pruning" Speed
# Now, when you query for February sales, MySQL will skip January and March entirely. You can see this by checking the execution plan

EXPLAIN Analyze SELECT * FROM partition_order 
WHERE OrderDate BETWEEN '2025-02-01' AND '2025-02-28';

# Look for: The partitions column in the output. It should say p_feb. If it does, your partitioning is working perfectly!

-- step 6. To add a new partition (e.g., 5) before it hits the p_future bucket

ALTER TABLE partition_order 
REORGANIZE PARTITION pFuture INTO (
    PARTITION p_apr VALUES LESS THAN (5),
    PARTITION pFuture VALUES LESS THAN MAXVALUE
);

-- **************************************************************************************************************************************

# 2. LIST Partitioning
# Groups data based on a specific, predefined list of values.
# Best for: Categorical data (e.g., Partition 1 = 'USA', 'Canada'; Partition 2 = 'UK', 'France')

# While Range Partitioning is for continuous data (like dates or numbers), LIST Partitioning is for discrete, categorical data.
# Think of it like sorting mail into bins based on Country or Department. 
# There is no "between" USA and Canada; a row either matches the value in the list or it doesn't. 

-- Step 1. Creating table
# In List Partitioning, you explicitly define which values belong to which partition using the IN operator.

CREATE TABLE orders_sales_list_partition (
    OrderID int NOT NULL,
    ProductID int,
    CustomerID int,
    SalesPersonID int,
    OrderDate date NOT NULL,
    ShipDate date,
    OrderStatus varchar(50),
    ShipAddress varchar(255),
    BillAddress varchar(255),
    Quantity int,
    Sales decimal(10,2),
    CreationTime datetime,
    PRIMARY KEY (OrderID, OrderStatus) -- Partition column must be in PK
)
-- Step 2: Define the Partitions immediately
PARTITION BY LIST COLUMNS(OrderStatus) (
    PARTITION p_active   VALUES IN ('Ordered', 'Processed', 'Shipped'),
    PARTITION p_finished VALUES IN ('Delivered'),
    PARTITION p_cancelled VALUES IN ('Cancelled', 'Returned')
);

-- Step 3. Inserting the date from orders_sales to partition_order

INSERT INTO orders_sales_list_partition 
SELECT * FROM orders_sales;


-- Step 4. Verify the Migration
# you can confirm that your existing 10 rows were successfully moved into their new homes

SELECT 
    PARTITION_NAME, 
    TABLE_ROWS 
FROM information_schema.PARTITIONS 
WHERE TABLE_NAME = 'orders_sales_list_partition' 
  AND TABLE_SCHEMA = DATABASE();
  
  
-- Step 5. Testing the "Pruning" Speed
# Execution Plan: The partitions column will show p_cancelled only. MySQL won't even touch the files for active or finished orders

EXPLAIN Analyze SELECT * FROM orders_sales_list_partition 
WHERE OrderStatus = 'Delivered';


-- step 6. Adding a New Category ('On Hold')
# you cannot just insert it. You must update your partition definition.

# 6.1 If the status belongs in an existing partition:
ALTER TABLE orders_sales_list_partition
REORGANIZE PARTITION p_active INTO (
    PARTITION p_active VALUES IN ('Ordered', 'Processed', 'Shipped', 'On Hold')
);

# 6.2 If you want a brand new partition for it:
ALTER TABLE orders_sales ADD PARTITION (
    PARTITION p_delayed VALUES IN ('On Hold', 'Backordered')
);

# 6.3 Moving a Value between Partitions
# Imagine you decide that 'Shipped' should no longer be in the "Active" partition and should instead be in the "Finished" partition. 
# You have to reorganize both:

ALTER TABLE orders_sales REORGANIZE PARTITION p_active, p_finished INTO (
    PARTITION p_active VALUES IN ('Ordered', 'Processed', 'On Hold'),
    PARTITION p_finished VALUES IN ('Delivered', 'Shipped')
);

# What happens internally: MySQL physically moves the "Shipped" rows from the p_active file to the p_finished file.

# 6.4 Deleting a Category
# If you decide to stop supporting 'Returned' items and want to wipe them all out to save space:

-- This deletes the PARTITION and ALL DATA inside it
ALTER TABLE orders_sales DROP PARTITION p_cancelled;


/*

Key Differences from Range
No "Less Than": You use VALUES IN (...).
No "MAXVALUE": There is no catch-all "everything else" bucket. 
			  If you try to insert a value that isn't in your lists (e.g., OrderStatus = 'On Hold'), the insert will fail with an error.
In Range partitioning, we used MAXVALUE. List partitioning does not have a "Default" or "Other" bucket.
If you insert a value that isn't in your list, the query fails.
The Pro Strategy: Many DBAs create a partition called p_misc with a value like 0 or 'Unknown' and 
then use an application-level trigger to catch unexpected values.
LIST COLUMNS: In modern MySQL, using LIST COLUMNS (as shown above) allows you to partition by strings directly. 
				Older versions required you to use integers.


When to use LIST Partitioning?
This is the best choice when your data naturally falls into clear groups:
Geography: Partition by Region or CountryCode.
Business Logic: Partition by DepartmentID or StoreCategory.
Status Tracking: Like the example above, separating "Live" orders from "History" orders.


Why use the "Shadow Table" Copy Method here?
Since you asked earlier about copying to a new table, here is why it's especially helpful for LIST Partitioning:
Validation: When you run INSERT INTO ... SELECT, 
		 the copy process will fail if your original data contains a value you forgot to include in your list (like a typo in OrderStatus).
         This helps you clean your data.
Organization: It physically groups all "Delivered" items together on the disk, making reports on completed sales much faster.

*/


-- **************************************************************************************************************************************

# 3. HASH Partitioning

# While Range and List partitioning rely on you defining specific boundaries or categories, 
# HASH Partitioning is used when you want to distribute data evenly across a fixed number of partitions without needing a complex logic.

# It uses a mathematical formula (a hashing algorithm) to decide where each row goes. 
# If you tell MySQL to create 4 partitions, it takes your column value (like OrderID), divides it by 4, and 
# looks at the remainder to pick the partition.

-- step 1 creating table
# In Hash Partitioning, you only need to provide the column and the number of partitions you want.
CREATE TABLE orders_sales_hashed (
    OrderID int NOT NULL,
    ProductID int,
    CustomerID int,
    SalesPersonID int,
    OrderDate date NOT NULL,
    ShipDate date,
    OrderStatus varchar(50),
    ShipAddress varchar(255),
    BillAddress varchar(255),
    Quantity int,
    Sales decimal(10,2),
    CreationTime datetime,
    PRIMARY KEY (OrderID, OrderDate)
)
-- step2. This tells MySQL: "Spread the data across 4 files using OrderID"
PARTITION BY HASH(OrderID)
PARTITIONS 4;

-- Step 3. Inserting the date from orders_sales to partition_order
INSERT INTO orders_sales_hashed 
SELECT * FROM orders_sales;


-- Step 4. Verify the Migration
# you can confirm that your existing 10 rows were successfully moved into their new homes

SELECT 
    PARTITION_NAME, 
    TABLE_ROWS 
FROM information_schema.PARTITIONS 
WHERE TABLE_NAME = 'orders_sales_hashed' 
  AND TABLE_SCHEMA = DATABASE();
  
  
-- Step 5. Testing the "Pruning" Speed
# Execution Plan: To see if pruning is working, 
# you must use a WHERE clause that targets the specific column you used in your PARTITION BY HASH() definition.

-- Assuming OrderID is your Hash column
EXPLAIN SELECT * FROM orders_sales_hashed 
WHERE OrderID = 105;

# For the most accurate "Speed" test, use ANALYZE to see the actual execution time in milliseconds:
EXPLAIN ANALYZE 
SELECT * FROM orders_sales_hashed WHERE OrderID = 105;

/*
What to look for in the EXPLAIN output:
partitions column: It should show exactly one partition (e.g., p2).
If it shows all partitions (e.g., p0, p1, p2, p3), pruning failed.
*/

-- step 6. Maintenance: Adding/Reducing Partitions
# Unlike Range or List, you don't "Add" a partition to a Hash table; you redefine the count.

# 6.1 Reducing Partitions (COALESCE PARTITION)

# In HASH partitioning, you don't "drop" a partition (because you’d lose random data). 
# Instead, you coalesce them, which means merging them back together.

-- Reduces the TOTAL count by 4
ALTER TABLE orders_sales_hashed COALESCE PARTITION 4;

/*
What happens behind the scenes:
Merging: MySQL takes the data from the 4 partitions you are removing and re-hashes them into the remaining partitions.
Math Update: If you had 8 partitions and coalesce 4, the formula changes back to ID (mod 4).
File Deletion: Once the data is moved into the remaining 4 files, the 4 empty files are deleted from the disk.
*/

# 6.2 Increasing Partitions (ADD PARTITION)
# When you want to spread your data across more files (to improve speed or handle more data), you use ADD PARTITION.

-- Adds 4 NEW partitions to the existing ones
ALTER TABLE orders_sales_hashed ADD PARTITION PARTITIONS 4;

/*
What happens behind the scenes:
New Files: MySQL creates 4 new physical files on the disk.
The Great Migration: MySQL looks at every row in your table. If you previously had 4 partitions and now have 8, 
					the math changes from ID (mod 4) to ID (mod 8).
Moving Data: A row with OrderID = 5 used to be in Partition 1 (5 (mod 4) = 1). 
			Now, it might need to move to Partition 5 (5 (mod 8) = 5).
Cleanup: Once all rows are moved to their new correct "buckets," the process finishes.
*/

/*
Warning: This is a heavy operation. MySQL has to recalculate the hash for every single row and move them to their new homes.

Unlike Range partitioning (where DROP PARTITION is instant), these two commands are Heavy Operations.
Table Lock: Your table will likely be locked for both reads and writes while this is happening.
IO Intensive: MySQL is physically reading and rewriting your entire table.
Temp Space: You need enough disk space to temporarily hold a second copy of the table while MySQL rearranges the rows.


Command							Action						Goal											Risk
ADD PARTITION					Increase count				Better performance/more space				High CPU/Disk IO during move
COALESCE PARTITION				Decrease count				Simplify/Save file handles					High CPU/Disk IO during move

*/
