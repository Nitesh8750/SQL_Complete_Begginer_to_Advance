# NULL Function

# NULL means Nothing, Unknown
# NULL is not equal to anything ( like 0, empty string, blank sapce)

# To remove the Null values and put new values
# IFNULL
# coalesce()

# when we have a value, we want to make it NULL
# NULLIF()

# To check where the data has null value
# IS NULL
# IS NOT NULL

-- **********************************************************************************************************************************--
# 1. IFNULL()
# Replace "NULL" with a specific value
# IFNULL(column, replacement_value)

use data_with_baraa;
select * from orders_sales;

select ifnull(BillAddress, ShipAddress) as address from orders_sales;
select OrderID, BillAddress,ifnull(BillAddress, 0) as address from orders_sales;


# 2. COALESCE()
# Return the first non-null value from the list
# COALESCE(value1, value2, value3, ..., valueN)

select OrderID, ShipAddress, coalesce(ShipAddress, 'unknown') from orders_sales;
select OrderID, BillAddress, ShipAddress, coalesce(ShipAddress, BillAddress) from orders_sales;
select OrderID, BillAddress, ShipAddress, coalesce(ShipAddress, BillAddress, 'unknown') from orders_sales;


/*
# Difference
ISNULL 										COALESCE
Limited to two values						Unlimited values
Fast 										Slow
*/

# Aggregation with ISNULL and COALESCE

# all aggregate functions will ignore the NULL values But,
# Count(*) , * will count it because * applies row wise, that why this work on NULL
# So before the Aggregation, replace the NULL values with 0 or something else

select * from customers;

# Question 1. Find the average score of the customers
select ID, Score, 
avg(score) over() as simpleavg, -- divide by 4
avg(coalesce(score,0)) over() as correctavg -- divide by 5
from customers;


# Handle the Null values Before doing Mathematical Operations
# Null + 5 --> NULL
# NULL + 'b' ---> NULL

# Question Display the full name of customers in a single field by merging their first and last names, and add 10 bonus points to each 
# customers score
select * from employees;
select EmployeeID, concat(FirstName," ",LastName),
coalesce(ManagerID,0) + 10 as sum
from employees;


# Handling NULL BY JOINS
# Handling Null before joining the table

/*
suppose we have a table1 and table2 in which we have 

Table1											        Table2
Year 	Type 	Orders							Year 	Type 	Orders
2024	a  		30								2024	a 		100
2024	NULL	40								2024	NULL	200
2025	b   	50							    2025	b 		300
2025	NULL 	60								2025	NULL	200

Now if we apply join than SQL will Ignore the NULL values rows, thats we have to replace all the NULL values with '', than it will 
work correctly

select a.year, a.type, a.orders, b.sales
from table1 a
join table2 b on
a.year = b.year
and ISNULL(a.type,'') = ISNULL(b.type,'')

*/

select * from orders;
select * from customers;


# Handles The NULL Values Before Sorting Data
# In sorting SQL think NULL value doesn't have value, it will consider NULL as lowest values

# sort the customers fromlowest to highest scores
# will null appearing last

select ID, score from customers order by score asc; -- wrong according to question

select ID, score,
case when score is null then 1 else 0 end case_state
from customers order by case when score is null then 1 else 0 end, score asc;

# firstly it will sort the data by case_state than it will sort based on the score becuase case_sate have same as 0

-- ************************************************************************************************************************************--

# NULLIF()
# NULLIF() is a control flow function in MySQL that compares two arguments and returns NULL if they are equal. 
# Otherwise, it returns the first argument.
# NULLIF(expression1, expression2)

Select ShipAddress, BillAddress,
nullif(ShipAddress, BillAddress),
nullif(OrderDate,ShipDate)
from orders_sales;


# NULLIF -  Preventing the error of dividing by zero

# Find the sales price for each order by dividing the sales by quantity
select OrderID,
Sales,
Quantity,
Sales/Quantity as Price,
sales/NullIf(Quantity,0) as corect_Way
from orders_sales;

#sometimes when we divie the any valye by 0 than it will give error so we make it NUll, If any any value divide by NUll than result is NULL

-- ************************************************************************************************************************************--

# ISNULL
# Return True when value is NULL else FALSE

# IS NOT NULL
# Return TRUE when value is NOT NULL else FALSE

# Filtering Case

# Identify the ddata who have no score
select * from customers where score is NULL;

# Identify the ddata who have score
select * from customers where score is NOT NULL;


# FOR ANTI JOINS

# List all details for customers who have not placed any orders
# we are using Left Anti JOIn (Left Join + isNUll) 
select * from customers
left join orders on 
customers.ID = orders.customer_id
where orders.customer_id is NULL;


# NULL VS EMPLT String VS BLANK spaces

# NULL - means nothing, unknown
# Empty string - string value has zero character
# Blank Space - it is string value but has one or more space characters, because blank space is countable

with orders as (
select 1 ID, 'A' Category union
select 2, NULL Union   -- NULL
select 3, '' Union		-- Empty
select 4, ' '			-- Space
)
select * , length(Category) as Lenth,
length(trim(Category)) as trim_to_avoid_blank_spaces,
nullif(trim(Category),'') as NUllif_to_avoid_empty_string,
coalesce(category, 'unknown') as avoid_null_values, -- this will workd on only category
coalesce(nullif(trim(Category),''),'unknown') as avoid_null_values_all_rows
from Orders;

# Data Policies :- 
/*
Policy 1 :- Trim the empty space from the data
Policy 2 :- Replacing empty string and blanks with NULL during data preparation before inserting into a database to optimize
storage and performance
Policy 3 :- Replacing NULL values with any specific values or default value like 'unknown'

Policy 2 is best , policy 3 is better than policy 1
*/

/*
USE CASES

1. Handle NULLs Before Data Aggregation
2. Handle NULLs Before Mathematical Operations
3. Handle NULLs Before Joining Tables
4. Handle NULLs Before Sorting Data
5. Finding Unmatched Data - Left Anti Join
6. Data Policies
*/