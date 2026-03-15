# Window Value Function

/*
VALUE(Analytical) Functions			Expression datatype		Partition clause	Order clause   			Frame 
	LEAD(expr,offset,default)			ALL Data Type			Optoinal		Must Required			Not allowed
	LAG(expr,offset,default)			ALL Data Type			Optoinal		Must Required			Not allowed
	FIRST_VALUE(exp)					ALL Data Type			Optoinal		Must Required			Optional	
    LAST_VALUE(exp)						ALL Data Type			Optoinal		Must Required			Should be used
	
*/

# Lead - gives the next row data, which helps me to compare current data and Next data
# Lag - gives the previous row data, which helps me to compare current data and previous data 
# First_value - gives the first row data, which helps me to compare current data and first row data
# Last_value - gives the last row data, which helps me to compare current data and last row data

/*

LEAD(expr,offset,default)	Returns the value from a previews row 			Lead(Sales, 2, 0) over (Order by OrderDate)
LAG(expr,offset,default)	Returns the value from a subsquent row			LAG(Sales, 2, 0) over (Order by OrderDate)
FIRST_VALUE(exp)			Returns the first value in a window				First_value(Sales) over (Order by OrderDate)
LAST_VALUE(exp)				Returns the last value in a window				Last_value(Sales) over (Order by OrderDate)

*/

-- ***********************************************************************************************************************************

# LEAD(expr,offset,default)
# Allow you to access a value from the next row within a window
# LEAD(Sales, 2, 10) Over(partition by ProductID order by OrderDate)
/*
Here 
Sales - Expression is required 
2 - Offset(optional) - Number of rows forward or backward from current row and default = 1
In Lead() offset are the number which we want to return, here 2 means 2 rows down from the current row
e.g. current row is 1 than it will give me the 3rd row value, as i use 2 as offset
If we do not specify anything than the default offset is 1
10 - This is default value, If we doesnot have new row value or current row is last row than the default value will return
and if we do not assign any number then default is NULL
*/

select OrderID, ProductId, Sales,
Lead(Sales,1,0) over(Partition  by ProductID order by Sales)
from orders_sales;

# in the last row of the all windows , this will return 0 and offset is 1 so it will jump by only 1

# LAG(expr,offset,default)
# Allow you to access a value from the previous row within a window
# LAG(Sales, 2, 10) Over(partition by ProductID order by OrderDate)
/*
Here 
Sales - Expression is required 
2 - Offset(optional) - Number of rows forward or backward from current row and default = 1
In LAG() offset are the number which we want to return, here 2 means 2 rows UP from the current row
e.g. current row is 3 than it will give me the 1st row value, as i use 2 as offset
If we do not specify anything than the default offset is 1
10 - This is default value, If we doesnot have previous row value or current row is first row than the default value will return
and if we do not assign any number then default is NULL
*/

select OrderID, ProductId, Sales,
LAG(Sales,1,0) over(Partition  by ProductID order by Sales)
from orders_sales;

# in the first row of the all windows , this will return 0 and offset is 1 so it will jump by only 1

-- ***********************************************************************************************************************************

# Use Cases

# 1. MIN / MAX Use Case

# 1.1 Time Series Analysis 
# The process of analyzing the data to understand patterns, trends and behaviors over time
# Year-over-Year(YOY) - Analyze the overall growth or decline of the businees's performace over time
# Month-over-Month(MOM) - Analyze short-term trends and discover patterns in seasonality

# Questions Analyze the month-over-Month(MOM) performace by finding the percentage changes in sales between the current and previous month
select *,
CurrentMonthsales - Previousmonthsales as MOM,
round((CurrentMonthsales - Previousmonthsales) / Previousmonthsales * 100, 2)  as PercentageMOM

from (
    select 
	month(OrderDate) ordermonth,
	sum(Sales) CurrentMonthsales,
	LAG(sum(Sales),1,0) over(order by month(OrderDate)) Previousmonthsales
	from orders_sales
	group by month(OrderDate)
)t;

# 1.2 Customer Retention Analysis
# Measure customer's behaviour and loyalty to help businesses build strong relationship with customers 

# In order to Analyze customer loyalty, rank customers based on the average days between their orders
select CustomerID,
avg(DaysUntilNextOrder) AVGDAYS,
RANK() over(Order by coalesce(avg(DaysUntilNextOrder),999999)) Rankavg
from (
	select OrderId, customerID, 
	OrderDate currentOrder,
	Lead(OrderDate) over (Partition by CustomerID order by OrderDate) NextOrder,
	abs(datediff(OrderDate, Lead(OrderDate) over (Partition by CustomerID order by OrderDate))) DaysUntilNextOrder
	from orders_sales
	order by CustomerID, OrderDate
)t
group by CustomerID;


-- ***********************************************************************************************************************************

# First_value()
# Allow you to access a value from the first row within a window
# here frame is optional 

select OrderID, ProductID, Sales,
first_value(Sales) over(Partition by ProductId order by Sales)
from orders_sales;

# here we are using the default frame condition which is 
# Range between Unbounded preceding and current row




# Last_value()
# Allow you to access a value from the last row within a window
# here frame is must

select OrderID, ProductID, Sales,
last_value(Sales) over(Partition by ProductId order by Sales)
from orders_sales;

# here we are using the default frame condition which is 
# Range between Unbounded preceding and current row
# thats why after partition by the productId we have frame from unbounded row to current row and in every case current row is last row
# so thats why in every row we have same value as it is in Sales column


select OrderID, ProductID, Sales,
Month(OrderDate),
last_value(Sales) over(order by Month(OrderDate)
Rows between Current row and unbounded Following) as lastvalue
from orders_sales;

# here the unbounded row is last row and current row can be any row, thats why in every row will show the last row value


-- Find the lowest and highest sales for each product
select OrderID, ProductID, Sales,
first_value(Sales) over(Partition by ProductID order by Sales) lowestsales,
last_value(Sales) over(Partition by ProductID order by Sales 
Range between current row and unbounded following) highestsales,

MIN(Sales) over(Partition by ProductID ) lowestsales2,
MAX(Sales) over(Partition by ProductID ) highestsales2
from orders_sales;



# Use Case
# Compare to Extreme

-- Find the lowest and highest sales for each product
-- Find the difference in sales between the current and the lowest sales
select OrderID, ProductID, Sales,
first_value(Sales) over(Partition by ProductID order by Sales) lowestsales,
last_value(Sales) over(Partition by ProductID order by Sales 
Range between current row and unbounded following) highestsales,
Sales - first_value(Sales) over(Partition by ProductID order by Sales) as saledifference
from orders_sales;