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
