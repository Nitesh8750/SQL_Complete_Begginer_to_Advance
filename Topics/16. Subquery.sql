# SubQuery
# A query inside another query

# STEP1 JOIN TABLES  --> STEP2 FILTERING  -->  STEP3 TRANSFORMATION  -->  STEP4 AGGREGATION
# SUB QUERY     ------>  SUB QUERY       ------>  SUB QUERY		 ------>  MAIN QUERY 

# Subquery is categorised in different ways
/*

Subquery based on result type
1. Scalar Subquery ----> it returns only one single value
2. Row subquery   -----> it returns multiple rows and single column
3. table subquery -----> it returns multiple rows and multiple columns

Subquery based on Location / Clauses
Select ---> 
From   ---> 
Join   ---> before joining table
Where  ---> to filter the data
	   ---> Comparison operator -->>  >, <, =, !=, >=, <=
       ---> Logical operator   -->>  IN, ANY, ALL, EXISTS

Categories based on realtion :-
1. Non-Correlated Subquery ----- subquery is independent from the query
2. Corelated Subquery   ------ subquery is depend on the query

*/
-- ***************************************************************************************************************************************

# Subquery based on result type

# 1. Scalar Subquery 
# It will return only single value
use data_with_baraa;
select 
avg(sales) averagesale
from orders_Sales;

# 2. Row subquery 
# It will returns multiple rows and single column 
select Sales
from orders_Sales;

# 3. Table subquery 
# It returns multiple rows and multiple columns
select * from orders_sales;

-- ***************************************************************************************************************************************

# Subquery based on Location / Clauses

# 1. From clause
# Used as temporary table for the main query
# In Mysql we have to assign alias or (t) after subquery

select * from 
(select OrderID, ProductID, Sales
from orders_sales where Sales > 50) AS sales500;

# Question Find the products that have a sales higher than the average sales of all products

select * from
	(select ProductID, Sales, 
    avg(Sales) over() as avgsales from orders_sales)t
where Sales > avgsales;


# Question Rank customers based on their total amount of sales
Select *,
Rank() Over(order by totalsales desc) rankwise from
(
	select CustomerID,
	sum(Sales) totalsales
	from orders_Sales
	group by CustomerID
	order by CustomerID
)t;


# 2. Select Clause
# Used to aggregate the data side by side with the main query's data, allowing for direct comparison
/*
select column1 , 
(select colum from table1 where condition)
from table
*/

# The result of the subqueryt must be scalar or  (single value result of the subquery)

# question Show the OrderID, productIDs, Sales, and total number of orders

select OrderID, ProductID, Sales,
(select count(OrderID) from orders_Sales) number_of_orders
from orders_sales;

# 3. Join Clause
# Used to prepare the data (filtering or aggregation) before joining it with other tables

-- show all cumtomers details and find the total orders of each customer
select c.*,o.totalorders from customers c
left join(
	select CustomerID,
    count(OrderID) totalorders
    from orders_Sales
    group by CustomerID
    ) o
on 
c.ID = o.CustomerID;


# 4. Where Clause
# Used for complex filtering logic and makes query more flexible and dynamic
# Only a single or scalar resaults are allowed in subquery


# comparison operators
# Used to filter data by comapring two values
/*

>, <, =, !=, >=, <=

=					Equal								where Sales = (select avg(Sales) as avgsales from orders_sales);
!= or <> 			Not Equal							where Sales != (select avg(Sales) as avgsales from orders_sales);
>					Greater than						where Sales > (select avg(Sales) as avgsales from orders_sales);
<					Less than							where Sales < (select avg(Sales) as avgsales from orders_sales);
>=					Greater than or equal to 			where Sales >= (select avg(Sales) as avgsales from orders_sales);
<=					Less than or equal to				where Sales <= (select avg(Sales) as avgsales from orders_sales);

*/

# Question Find the products that have a sales higher than the average sales of all products
select * from orders_sales
where Sales > (select avg(Sales) as avgsales from orders_sales);



# Logical operator  
# IN, ANY, ALL, EXISTS

# IN Operator 
# Checks whether a value matches any value from a list

/*
select column1, coulumn2
from table1
where column IN (select column from table2 where condition)
*/

-- Question Show the details of orders made by customers in Germany
select * from orders_sales
where CustomerID IN
(
select CustomerID from customers
where Country = 'Germany'
);