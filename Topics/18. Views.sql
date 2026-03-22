# Views 
# It is a virtual table based on the result set of a query without storing the data in database.
# Views are persisted SQL queries in the database
# It doesn't stored data physically like other queries

/*
Difference Between Views and Tables

	Views																	Tables
	No Persistance															Persisted Data
	Easy to Maintain														Hard to Maintain
	Slow Response 															Fast Response
	Read																	Read / Write
*/

-- *************************************************************************************************************************************

# Use Cases

# 1. Central Complex Query Logic
# We are using views because to store central, complex query logic in the database for access by multiple queries,
# and to reducing project complexity 

/*
Lets assume their are 3 employees which creating difference different project, but their CTE Query is same for everyone, 
so instesd of creating same CTE for every employees, we created a Views which is same for eaveryone and all 3 eemployees can access this
for their different different projects

CTE Query
							Intermediate Result
Orders---------------|------->	CTE Query 1	--------->	|----------->	Main Query 1
					 |									|	
					 |------->	CTE Query 2	--------->	|----------->	Main Query 2
					 |									|
Customers------------|------->	CTE Query 3	--------->	|----------->	Main Query 3

ALL CTE Queries are same


Views
Orders---------------|									|----------->	Main Query 1
					 |									|	
					Views ---->> Intermediate Result--- |----------->	Main Query 2
					Central Logic						|
					 |									|
Customers------------|									|----------->	Main Query 3



Views VS  CTE

Views																			CTE
1. Reduce Redundancy in Muti-Queries											Reduce Redundancy in 1 Query
2. Improve Reusabilitu in Muti-Queries											Improve Reusabilitu in 1 Query
3. Persisted Logic																Temporary Logic
4. Need to Maintain																No Maintainance
5. Create / Drop to views														Auto Cleanup

*/

-- **************************************************************************************************************************

/*
Views Syntax
Create View Views-name as
(
Create
From
Where
)
*/
-- **************************************************************************************************************************


-- Find the running total of sales for each month

# By CTE

-- CTE query
with cte_sales as 
(
select month(OrderDate) as months, sum(Sales) as totalsales,
count(OrderID) as totalorders, sum(Quantity) as total_quantity
from orders_sales
group by month(OrderDate)
)  # Lets assume with CTE Query is common for multiple projects, so to create same cte for every project, instead of this we create a view

-- Main query
select months, totalsales,
sum(totalsales) over(order by months) as Runningtotal
from cte_sales;


# View

-- TO create view
create view view_sales as
(
select month(OrderDate) as months, sum(Sales) as totalsales,
count(OrderID) as totalorders, sum(Quantity) as total_quantity
from orders_sales
group by month(OrderDate)
);

-- To Find structure of the views
describe view_Sales;

-- TO print the views
select * from view_sales;
# after execution view query it does not print anything, it simply run, if you want to see views go to the views section in database
# Once created view, it can used for multiple quesries and multiple times

-- Main query to find result using view
select months, totalsales,
sum(totalsales) over(order by months) as Runningtotal
from view_sales;


# To DROP VIEWS
Drop view view_sales;

-- **************************************************************************************************************************

-- TO find the views are stored in which database
SELECT * FROM INFORMATION_SCHEMA.VIEWS;

/*
In MySQL, the "Current Schema" and the "Default Schema" are the exact same thing!
When you run USE my_database;, 
you are setting your "Default Schema." From that moment until you change it or close your connection, 
any table or view you create without a specific prefix will be placed inside that database.

In MYSQL when we creating any view, firstly we have to chosse a database, wihtout database it gives error and 
the current database is our default views.
we can also create the views like this

CREATE VIEW database_B.view_sales AS
SELECT ...
FROM database_A.orders_sales;
*/

-- **************************************************************************************************************************


# TO UPDATE THE VIEWS

# 1. Updation in the Definiton or Structure or logic of the view
# If you want to change the logic—for example, 
# adding a new column or changing a calculation—the best way is to use the CREATE OR REPLACE command.

Create or replace view view_sales as 
(
select month(OrderDate) as months, 
sum(Sales) as totalsales,
count(OrderID) as totalorders, 
sum(Quantity) as total_quantity,
round(avg(Sales),2) as avg_sales
from orders_sales
group by month(OrderDate)
);

describe view_Sales;

select * from view_sales;

drop view view_sales;


# 2. Updation in Data (Updating Rows)
# You can actually run an UPDATE statement directly on a View, and MySQL will pass that change down to the original table. 
# However, your current view_sales is NOT updatable because it uses GROUP BY and SUM().
# The "Golden Rules" for Updatable Views:
# A View is only updatable if it has a 1-to-1 relationship with the table rows. It will fail if it contains:
# Aggregate Functions (SUM, AVG, COUNT, etc.)
# GROUP BY or HAVING
# DISTINCT
# UNION or UNION ALL
# Joins (In some specific cases, MySQL allows updates on join views, but only if you update one table at a time).

/*
Example
-- If you have a simple View that just filters data, you can update it easily:
-- 1. Create a simple view
CREATE VIEW v_active_customers AS
SELECT ID, First_Name, Status FROM customers WHERE Status = 'Active';

-- 2. Update the data THROUGH the view
UPDATE v_active_customers 
SET First_Name = 'Baraa' 
WHERE ID = 501;
*/

# The change happens in the customers table instantly.
# It means that, this updation will done directly into the original table based on the table, views are also updated


# 3. Using the WITH CHECK OPTION
# This is a "safety move." If you create a view with this option, 
# MySQL will prevent you from updating a row in a way that makes it disappear from the view.

/*
Example:

CREATE VIEW v_high_sales AS
SELECT * FROM orders_sales WHERE Sales > 100
WITH CHECK OPTION;
*/

# If you try to update a row to Sales = 50, MySQL will block the update because 50 does not meet the "Sales > 100" condition of the view. 
# It protects the integrity of your "view logic."


-- *************************************************************************************************************************************

# USE CASE
# 2. Hide Complexity
# Views can be used to hide complexity of database tabes and offers users more friendly and easy to consume objects.

-- provide a view that combines details from orders_sales, products, customers, and employees.

Create view view_order_details as 
(
select 
o.OrderID,
o.OrderDate,
p.Product,
p.Category,
c.First_name as CustomerName,
c.Country,
concat_ws(' ', e.FirstName, e.LastName) as EmployeeName,
e.Department,
-- e.Gender,
o.Sales, 
o.Quantity
from orders_Sales as o
left join products as p on
p.productID = o.ProductId
left join customers as c on
c.ID = o.CustomerID
left join employees as e on
e.EmployeeID = o.SalesPersonID
);

drop view view_order_details;
select * from view_order_details;


-- *************************************************************************************************************************************

# USE CASE
# 3. Data Security
# Use views to enforce security and protect sensitive data, by hiding columns and/or rows from tables

-- Provide a view for EU sales team
-- that combines details from all tables
-- And excludes data related to the USA

-- that combines details from all tables
 Create view view_eu_sales as 				-- Provide a view for EU sales team
(
select 
o.OrderID,
o.OrderDate,
p.Product,
p.Category,
c.First_name as CustomerName,
c.Country,
concat_ws(' ', e.FirstName, e.LastName) as EmployeeName,
e.Department,
-- e.Gender,
o.Sales, 
o.Quantity
from orders_Sales as o
left join products as p on
p.productID = o.ProductId
left join customers as c on
c.ID = o.CustomerID
left join employees as e on
e.EmployeeID = o.SalesPersonID
where country != 'USA'  -- And excludes data related to the USA
);     

drop view view_eu_sales;

select * from view_eu_sales;


-- *************************************************************************************************************************************

# USE CASE
# 4. Flexibility and Dynamic

# Lets assume multiple users are using same Table, Now i want to make changes in table like changing the column name and updating the data
# so all users get errors because they directly using that table

# In that scenario We Use Views, we create view of our table and give all the table to the view and tell uers to use this view,
# meanwhile we can do changes in our original table and users doesn't erros and also our works run smoothly


-- *************************************************************************************************************************************

# USE CASE
# 5. Multiple Languages

# Lets assume multiple users from whole world are using same Table, if some different language user can't underdatnd the original data so 
# I have to change the original tabale into their language, but if i changes the original table it is trouble for the rest of the different
# language users, 

# Thats why we are created a view of the original table in a different language for that user with the same data.


-- *************************************************************************************************************************************

# USE CASE
# 6. Virtual Data Marts in DWH

# Views can be used as Data Marts in Data Warehouse System becuase they provide a flexible and efficient way to present data

# Data warehouse is collection of data from multiple databases

# Data mart means a specific type of data store like sales, finance, etc