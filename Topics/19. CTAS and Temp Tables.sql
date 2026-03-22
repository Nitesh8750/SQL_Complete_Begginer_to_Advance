# CTAS and Temp Tables

# DB TABLE
# A table is a structured collection of data, similar to a spreadsheet or grid in excel

# table is stored in database files which is stored in memory disk

# Table Types
# 1. Permanent Table
#	 1.1 Create / Insert  -- traditional way
#    1.2 CTAS
# 2. Temporary Table

-- ***************************************************************************************************************************************

# 1. Permanent Table

# Create / Insert 
# Create -> define the struture of table
# Insert -> Insert data into the table



# CTAS
# create table as select
# create a new table based on the result of an SQL query

# It is used to create a table by using the result of the other table or Create/insert table\
# It is depend upon the other tables data


/*
# CTAS VS View
View 																	CTAS
The query of view has not been executed						|		The query of CTAS has been executed already
It is slower than CTAS because it will executing 			|		It is faster because it is already executed by original table and 
															|		now it will print same result
When we make changes in original table than it will update 	|		Bu it doesn't change in the CTAS becuase it is result of the previous
the views also and user get fresh data                      |	    table and user get old data

Example :-

views:- 
Lets assume we orders a pizza, everytime chef will make fresh pizza for us and based on our customization\

CTAS :- 
Leta assume we have a Pre cooked pizza, when we want to eat simply heat in oven and eat, but problem is that we doesn't get new pizza or 
fresh pizza this time, we have a old or forzen pizza, and we can't customize it according to our choice
*/

# CTAS Syntax
/*
Create table name as
(
select ....
from ....
where ...
)
*/

-- *****************************************************************************************************************
# USE CASE
# 1. Optimize Performance

/*
Orders---------------|									|----------->	Main Query 1
					 |									|	
					CTAS ---->>   Result Table    ----- |----------->	Main Query 2
					Central Logic						|
					 |									|
Customers------------|									|----------->	Main Query 3

*/

# some times View take very long time to execute and user can't understand the logic of views because of complexity thats why we use CTAS
# IT is faster than Views

create table monthly_sale as (
select month(OrderDate) Month, 
count(OrderID) as Totalorders
from orders_Sales
group by Month
);

describe monthly_sale;

select * from monthly_sale;

drop table monthly_sale;

# if the original data is changed after on year, this table is still same, it doesn't change automatically

# If we want to refresh the data in table then drop the table and create again


-- *****************************************************************************************************************
# USE CASE
# 2. Creating a Snapshot

# Lets assume we are working on the table to analyse the data,
# and suddenly the values are updated of the table and now we can't compare with the previous data and user got so much confusion
# thats why we use CTAS to save the current data into a table so if the tables is changing in future than 
# we can compare it with previous data 


-- *****************************************************************************************************************
# USE CASE
# 3. Physcial Data Marts in Data Warehouse

# Persising the Data Marts of a DWH, improves the speed of data retrieval compared to using views

# In Data Marts concept, views get updated based on the updation on DWH but it is time using and at a time or report generation we can't
# relay on the views
# thats why we use CTAS we it works on only previous data, it also take some times, but is less dealy than views and gives report
# based on last updated data

-- ***************************************************************************************************************************************

# 2. Temporary Table
# Stores intermediate results in temporary storage within the database during the session
# when we close or disconnect the MYSql the temporary table automatically deleted

/*
Syntax

CREATE TEMPORARY TABLE temp_sales_summary AS
(
SELECT 
FROM 
where
)
*/

create temporary table temp_sale as
(
select * from orders_sales
);

# this will give uss all temporary active tables names
SELECT * FROM INFORMATION_SCHEMA.INNODB_TEMP_TABLE_INFO;

# all the temporary table gets a unique ID, Name, No. of columns, Space is used
#	TABLE_ID		NAME			N_COLS		SPACE
#	1214		#sql1964_13_1e3		15			4243767290

# Temporary tables in MySQL are "session-specific," meaning they exist only in the RAM or temporary storage of your current connection. 
# Because of this, you won't find them listed in the standard navigation areas of your SQL editor.

DESCRIBE temp_sale;

select * from temp_sale;

delete from temp_sale
where OrderStatus = 'Delivered';

select * from temp_sale;

# If user want to save the temporary table result for future than create a CTAS table by using temporary table results
# STEP 1. Loan data into Temp File
# STEP 2. Transform Data in TEMP Table
# STEP 3. Load TEMP Table into Permananent Table


# USE CASE
# 1. Intermediate Results
# we are stored results temporary until we are done with the session



-- ***************************************************************************************************************************************

# Difference Between All Advance SQL Techniques
/*
			|	Subquery				|		CTE						|	Temp				| 	CTAS			|	View
Storage		|	Memory					|    Memory						|	DISk				|	DISK			|	No Storage
Life Time	|	Temporary				|	Temporary					|	Temporary			|	Permanent		|	Permanent
When Deleted|	End of query			|	End of query				|END Of Session			|	DDL-Drop		|	DDL-Drop
Scope		|	Single-query			|	Multi-queries				|	Multi-queries		|	Multi-queries	|	Multi-queries
Reusability	|Limited(1 place - 1 query)	|Limited(Multi places - 1 query)|Medium(Multi queries)	|High(Multi queries)| High(Multi queries)
Update		|	Yes						|	Yes							|	NO					|	NO				|	YES

*/
