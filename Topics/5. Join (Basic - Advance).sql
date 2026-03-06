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
# 1. Recombine the data
# 2. Data Enrichment (Getting Extra Data)
# 3. Check for Existence (Filtering the Data)

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
select 
c.id, 
c.first_name, 
o.order_id, 
o.sales
from orders as o 
full join customers as c 
on
c.ID = o.customer_id;


-- ************************************************************************************************************************************--


# Advance Joins
# Left Anti Join, Right Anti Join, Full Anti Join, Cross Join