# Combining the tables
# when we wants to combine the columns of table than we use Joins -  Wider table
# When we wants to combine the rows of table than we use Set Operatos -  Longer table

-- ************************************************************************************************************************************--
use data_with_baraa;
show tables;

create table orders (
order_id int primary key,
customer_id int,
order_date varchar(244),
sales float,
constraint fk foreign key(customer_id) references customers (ID)
);

Insert into orders (order_id, customer_id, order_date, sales)
values
(1001, 1, '2021-01-11', 35),
(1002, 2, '2021-04-05', 15),
(1003, 3, '2021-06-18', 20),
(1004, 5, '2021-08-31', 10);

select * from orders;
-- ************************************************************************************************************************************--


# Joins
-- combine the Data by using Joins
 
# When to use Joins
# 1. Recombine the data - Inner Join, Left Join, FUll Join
# 2. Data Enrichment (Getting Extra Data) - Left join
# 3. Check for Existence (Filtering the Data) - Inner Join, Left Join + where, Full Join + where

# Basic Joins 
# No join, Left Join, Right Join, Inner Join, Outer Join

-- ************************************************************************************************************************************--

# 1. No Join
# Return data from tables without conbining them
# All data from table 1 and all data from table 2

# Retrieve all the daat from customers and orders as separate results;
select * from customers;
select * from orders;

-- ************************************************************************************************************************************--

# 2. Inner Join
# Return only matching data from both tables

# Get all customers along with the their orders but only for customers who have placed an order
select * from customers 
inner join orders on
ID = customer_id;

select id, first_name, order_id, sales
from customers
inner join orders on
ID = customer_id;

# If both table has same name of ID column than we write like this
select customers.customer_id, first_name, order_id, orders.customer_id, sales
from customers
inner join orders on
customers.customer_id = orders.customer_id;

# Alias table  - which is use for the users to understand the column more easily
select
c.id, 
c.first_name, 
o.order_id, 
o.sales
from customers as c
inner join orders as o 
on
c.ID = o.customer_id;

# In inner join order of table doesn't matter we can do vice versa
select
c.id, 
c.first_name, 
o.order_id, 
o.sales
from orders as o
inner join customers as c 
on
c.ID = o.customer_id;


-- ************************************************************************************************************************************--

# 3. Left Join
# Returns all the data from left table and only matching from right

select * from customers
left join orders on
id = customer_id;

# Here order of table is important we have to check which table we take as left or right
# order 1
select
c.id, 
c.first_name, 
o.order_id, 
o.sales
from orders as o
left join customers as c 
on
c.ID = o.customer_id;

# order 2
select
c.id, 
c.first_name, 
o.order_id, 
o.sales
from customers as c
left join orders as o
on
c.ID = o.customer_id;


# Get all customers along with their orders, including orders without matching customers
select * from customers
left join orders on
ID = customer_id;

-- ************************************************************************************************************************************--

# 4. Right Join
# Return all the rows from the right table and matching from left table

select * from customers
right join orders on
ID = customer_id;

# Here order of table is important we have to check which table we take as left or right
# order 1
select
c.id, 
c.first_name, 
o.order_id, 
o.sales
from orders as o
right join customers as c 
on
c.ID = o.customer_id;

# order 2
select
c.id, 
c.first_name, 
o.order_id, 
o.sales
from customers as c
right join orders as o
on
c.ID = o.customer_id;


-- ************************************************************************************************************************************--

# 5. Full Join
# Return all the rows from both the table
# Mysql doesn't support the FUll JOIN, While databases like SQL Server, PostgreSQL, and Oracle have a built-in FULL JOIN command,
# In MySQL you must combine a LEFT JOIN and a RIGHT JOIN using the UNION operator to achieve the same result.

# Question: Get all customers and all orders even if there's no match

select * from customers
FULL JOIN orders on 
ID = customer_id;


# Here the order of table doesn't matter
(select 
c.id, 
c.first_name, 
o.order_id, 
o.sales
from orders as o 
left join customers as c 
on
c.ID = o.customer_id
)
union
(
select 
c.id, 
c.first_name, 
o.order_id, 
o.sales
from orders as o 
right join customers as c 
on
c.ID = o.customer_id
);

-- ************************************************************************************************************************************--


# Advance Joins
# Left Anti Join, Right Anti Join, Full Anti Join, Cross Join

# 1. Left Anti Join
# Returns Rows or data from the left table that has no match with right table 
# Only unmatched data from left table
# THe order of the table is important

# Get all customers who havn't placed any orders
select * from customers
left join orders on
customers.id = orders.customer_id
where orders.customer_id is NULL;


-- ************************************************************************************************************************************--

# 2. Right Anti Join
# Returns Rows or data from the right table that has no match with left table 
# Only unmatched data from right table
# THe order of the table is important

# Get all orders without matching customers
select * from customers
right join orders on
customers.id = orders.customer_id
where customers.id is NULL;

# Get all orders without matching customers ( BY Left Join)
select * from orders
left join customers on
customers.id = orders.customer_id
where customers.id is NULL;

-- ************************************************************************************************************************************--

# 3. Full Anti Join
# Return only rows or data that doesn't match in either table
# only the unmatched data from both tables
# Order of tables doesn't matter

# FInd customers without orders and orders without customers
(select * from orders as o 
left join customers as c 
on
c.ID = o.customer_id
where c.ID is Null
)
union
(
select * from orders as o 
right join customers as c 
on
c.ID = o.customer_id
where o.customer_id is Null);


-- ************************************************************************************************************************************--

# Get all customers along with their orders, but only for customers who have placed an order (without using inner join)

# Way 1.
select * from customers 
left join orders on
customers.id = orders.customer_id
where orders.customer_id is not null;
# where orders.customer_id is not null or orders.customer_id ; 

# Way 2.
(select * from orders as o 
left join customers as c 
on
c.ID = o.customer_id
where c.ID is Not Null
)
union
(
select * from orders as o 
right join customers as c 
on
c.ID = o.customer_id
where o.customer_id is not Null);

-- ************************************************************************************************************************************--

# 4. Cross Join
# Combines Every Row from Left with every row from right, all possible combination
# Order of table doesn't matter
# No conditions apply on this join

# Find all possible combination from customers and orders
select * from customers
cross join orders;

-- ************************************************************************************************************************************--

# How to choose Joins
/*
1. Only Matching - Inner Join

2. ALL Rows - 
			2.1 One Side - Master Table - Left Join / Right Join
            2.2 Both Side - Both Important - Full Join

3. Only Unmatched - 
			3.1 One Side - Master Table - Left Anti Join / Right Anti Join
            3.2 Both Side - Both Important - Full Anti Join
        
*/
-- ************************************************************************************************************************************--

# Multi-Table Joins

# Using SalesDB, Retrieve a list of all orders, along with the related customer, product, and employee details

select * from customers;
select * from orders;
select * from persons;

select o.customer_id, c.First_name, c.Country, o.order_id,o.order_date,o.sales from orders as o
left join customers as c on
o.customer_id = c.id
left join persons as p on 
c.id = p.id;

select * from orders as o
left join customers as c on
o.customer_id = c.id
left join persons as p on 
c.id = p.id;