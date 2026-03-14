# Window Aggregate Function
/*
Aggregate Functions  	Expression datatype			Partition Clause		 Order Clause 			Frame Clause
COUNT(expr)				ALL Data Type					Optional				Optional				Optional
SUM(expr)				Numeric							Optional				Optional				Optional	
AVG(expr)				Numeric							Optional				Optional				Optional
MIN(expr)				Numeric							Optional				Optional				Optional
MAX(expr)				Numeric							Optional				Optional				Optional

*/
-- ***********************************************************************************************************************************

# 1. Count(expr)
# returns number of row within a window and it will count NULL value also when we use (*), 
# but when we use specific column then it doesnot count

-- find the total number of orders
select count(*)
from orders_sales;

-- find the total number of orders
-- Additionally provide details such as OrderID, OrderDate
select OrderID, ProductID, Sales,OrderDate,
count(*) over()
from orders_Sales;

-- find the total number of orders for each customers
-- Additionally provide details such as OrderID, OrderDate
select OrderID, ProductID, Sales,OrderDate,CustomerID,
count(*) over(partition by CustomerID) noofcustomers
from orders_Sales;

-- find the total number of customers
-- Additionally provide the cusotmers data
select *,
count(*) over() noofcustomers,
count(1) over() noofcustomersone
from customers;
# we can use either * or 1 for find the count of customers

-- find the total number of scores for the cutomers
-- Additionally provide the cusotmers data
select *,
count(score) over() totalscore
from customers;

-- Check whether the table 'Orders_Sales' contains any duplicate rows
select OrderID,
count(*) over(partition by OrderID) checkpk
from orders_sales;

select OrderID, ProductID, Sales,
count(Sales) over(partition by ProductID) noofsales
from orders_Sales;
# it doesnot count sales

-- ***********************************************************************************************************************************

# SUM()
# returns the sum of values within a window

-- Find total sales for each product
select OrderID, ProductID, Sales,
sum(Sales) over (partition by ProductID)
from orders_sales;

-- Find total sale across all orders
-- and the total sales for each product.
-- Additionally provide details such as OrderID, OrderDate
select OrderID, OrderDate, ProductID, Sales,
sum(Sales) over() totalsales,
sum(Sales) over(partition by ProductId) productwisesale
from orders_sales;

-- Find the percentage contribution of each product's sales to the total sales
select OrderID, ProductID, Sales,
sum(Sales) over () totalsales,
round(Cast(Sales as float)/sum(Sales) over () * 100, 2) percentage
from orders_sales;
# to compare current value to aggregated value

-- ***********************************************************************************************************************************

# AVERAGE()
# returns the avg of values within a window

-- FInd the avg sale for each product
select OrderID, ProductID,Sales,
avg(Sales) over(partition by ProductID)
from orders_sales;
# when Null values occurs in Sales, it will give wrong answer

select OrderID, ProductID,Sales,
avg(coalesce(Sales,0)) over(partition by ProductID)
from orders_sales;

-- Find avg sale across all orders
-- and the avg sales for each product.
-- Additionally provide details such as OrderID, OrderDate
select OrderID, ProductID,Sales,
avg (coalesce(sales,0)) over() as totalavg,
avg(coalesce(Sales,0)) over(partition by ProductID) avgproduct
from orders_sales;

-- Find the avg score of the customers 
-- Additionally provide details such CustomerID, and LastName
select *,
avg(Score) over() as avgscore,
avg(coalesce(Score,0)) over() as avgscorecoal
from customers;


-- Find all orders where sales are higher than the avg sales across all orders

select * from
(
	select OrderID, ProductID, Sales,
    avg(coalesce(sales,0)) over() avgsale
	from orders_sales
)t where Sales > avgsale;


-- ***********************************************************************************************************************************

# MIN() and MAX()
# MIN() - Returns the Minimum value within a window
# MAX() - Returns the Maximum value within a window

select OrderID, ProductID, Sales,
min(Sales) over(partition by ProductID) minsale, 
max(Sales) over(partition by ProductID) maxsale
from orders_sales;
# these function will not count NULL value, becuase null means nothing
# but if we change using coalesce() by 0 than it is lowest


-- Find the highest and lowest sales across all orders
-- and the highest and lowest sales sales for each product.
-- Additionally provide details such as OrderID, OrderDate
select OrderID, ProductID, Sales,
min(Sales) over() minsale, 
max(Sales) over() maxsale,
min(Sales) over(partition by ProductID) minsaleasproduct, 
max(Sales) over(partition by ProductID) maxsaleasproduct
from orders_sales;


-- Show the employees who have the highest salaries
select * from
(
	select *,
	max(Salary) over() as maxsalary
	from employees
)t 
where Salary = maxsalary;


-- Find the deviation of each sales from the minimum and maximum sales amounts
select OrderID, ProductID, Sales,
min(Sales) over() minsale, 
max(Sales) over() maxsale,
Sales - min(Sales) over() deviationfromMIN,
max(Sales) over() - Sales deviationfromMAX
from orders_sales;

-- ***********************************************************************************************************************************

# Running & Rolling Total
# They aggregated sequence of members and the aggregation is updated each time a new member is added
# thats why it is called Analysis Over Time

# Tracking Current Sales with Target Sales
# Providing insights into historical patterns

/*
Difference between 
Running Total :-
.Aggregate all values from the begining up to the current point without dropping off older data
.sum(sales) over (order by month)
Rows Between unbounded preceding and current row -- default Frame

Rolling Total:-
.Aggregate all value within a fixed time window (e.g. 30 days). As new data is added, the oldest data point will be dropped
.sum(sales) over (order by month
Rows between 2 preceding and current row)

in this case

lets assume current row is first row than thats means 2 preceding means 2 before the first row which is -1 
so the sum is calculation of first row only

after that 
step 2: Current Row = Row 2
2 Preceding: Row 0
sum  = 0 + 1st + 2nd row

step 3: Current Row = Row 3
2 Preceding: Row 1
sum  =  1st + 2nd row + 3rd row

step 4: Current Row = Row 4
2 Preceding: Row 2
sum  =  2nd row + 3rd row + 4th row

step 5: Current Row = Row 5
2 Preceding: Row 3
sum  = 3rd row + 4th row + 5th row

*/

# Question on Running and Rolling

-- Calculate the Moving AVG of sales for each product over time
# here moving avg means running avg

select OrderID, ProductID, OrderDate, Sales,
avg(Sales) over(partition by ProductID) as avgproduct,
avg(Sales) over(partition by ProductID order by OrderDate) as runningavg
from orders_Sales;
# to make it running avg or moving avh we have to use Order by because Frame must required Order by 
# here we are using default Frame functions


-- Calculate the Moving AVG of sales for each product over time, including only the next order
# here moving avg means rolling avg
select OrderID, ProductID, OrderDate, Sales,
avg(Sales) over(partition by ProductID) as avgproduct,
avg(Sales) over(partition by ProductID order by OrderDate 
Rows Between current Row and 1 following) as rollingavg
from orders_Sales;
