# Window Functions Basics

# Window Function
# Perform calculations(eg. aggregation) on a specific subset of data, without losing the level of details of rows

/*
Difference Between Group BY and Window Function
Group BY
If we are using a group by, it will aggregate the data and group by based on categories that why we have less rows than the base tables.
Example : Total sales for each product 
1	Caps	10				sum - Caps 40
2	Caps	30
3 	Gloves	5				Sum - Gloves 25	
4	Gloves	20
Return a single row for each group
we are smashing squezing the results from 4 orders into two rows
Changes the Granulity :-  means we give input based on the OrderID and it will return the results based on product categories

Window Function
It will execute each row individually form each other.
Example : Total sales for each product 
1	Caps	10				sum - Caps - 40
2	Caps	30				sum - caps - 40
3 	Gloves	5				Sum - Gloves 25	
4	Gloves	20				Sum - Gloves 25

This is called Row level Calculations
The Granulity stays the same : - the no of rows will be same and input and output both depends upon the OrderID

Group BY 														Window
Simple aggregations												Aggregation + Keep details
GROUP BY has only aggregate FUnctions							Window Functions has Aggregate, Rank, Value functions


Aggregate Functions  	Expression datatype	|	RANK Functions	Expression datatype	|	VALUE(Analytical) Functions		Expression datatype
	COUNT(expr)			ALL Data Type		|	ROW_NUMBER()		EMPTY			|	LEAD(expr,offset,default)			ALL Data Type
	SUM(expr)			Numeric				|	RANK()				EMPTY			|	LAG(expr,offset,default)			ALL Data Type
	AVG(expr)			Numeric				|	DENSE_RANK()		EMPTY			|	FIRST_VALUE(exp)					ALL Data Type
	MIN(expr)			Numeric				|	CUME_DIST()			EMPTY			|				
	MAX(expr)			Numeric				|	PERCENT_RANK()		EMPTY			|
											|	NTILE(n)			Numeric			|

*/

-- **************************************************************************************************************************************

-- Question : Find the total sales across all orders
use data_with_baraa;
select 
sum(Sales)
from orders_sales;

-- Question : Find the total sales for each product
select ProductID, sum(sales)
from orders_sales 
group by ProductID;

# Result Granularity :- The number of rows in the output is defind by the dimension

-- Question : Find the total sales for each product
-- additionally provide the details such order id & order date
select OrderID, OrderDate, ProductID, sum(sales)
from orders_sales 
group by ProductID;

# this will error becuase select columns are not in group by 

select OrderID, OrderDate, ProductID, sum(sales)
from orders_sales 
group by 
OrderID, OrderDate, ProductID;

# here we can see the group by according to the columns but it is not aggregated, becuase Group by can;t do both task together aggregation
# and provide details

# Now by window function
select OrderID, ProductID,
sum(Sales) over(partition by ProductID) as Totalsales
from orders_sales
order by OrderID asc; 
# Result Granularity : Window function returns a result for each row

-- **************************************************************************************************************************************

/*
# Syntax:
# Window function + Over clause( Partition Clause + order clause + Fram clause)
# avg(sales) over(Partition by category order by OrderDate Rows Unbounded precending)

First window function  - Perform calculations within a window
Sales - Function expression (argument you pass to a function)
OVER() - this clause define the Window function
Partition BY Category - Divides the result set into partitions(windows/ Groups) based on Category
Order by - Sort the data within a window (asc/desc)
Window Frame - Defines a subset of rows within each window

window Expressions:-
Empty : 				RANK() over(order by OrderDate)
Column : 				Avg(Sales) over(order by OrderDate)
Number : 				NTELL(2) over(order by OrderDate)
Multiple Arguments : 	LEAD(Sales, 2, 10) over(order by OrderDate)
Conditional Arguments : Sum(Case when Sales > 100 then 1 else 0 END) over(order by OrderDate)

Total sales across all rows(entire result set)
Sum(sales) over()  : - here the result is not divided, it has only one window for whole table 
						Here the calculations is done on entire dataset

Total sales for each product
Sum(sales) over(Partition BY product) - it will divide the result window into multiple windows based on products
										Calculations is done individually on each window

Total sales for each combinations of product and order status
Sum(sales) over(Partition BY product, OrderStatus)

*/
-- **************************************************************************************************************************************

# 1. 
# Partition BY
# This is optional for all types of Window functions(aggregate, rank , value)

# With Over()
-- Question : FInd the total sales across all orders 
-- Additionally provide details such as order Id, Order date
select OrderID, OrderDate,ProductID,
sum(Sales) over() as totalsales
from orders_sales;
# here the result data is in single window

# With Over(Partition by category)
-- Question : Find the total sales for each product
-- Additionally provide details such as order Id, Order date
select OrderID, OrderDate,ProductID,
sum(sales) over(Partition by ProductID) as totalsales
from orders_sales;
# here the result data is divided into 4 window based on ProductID

# with multiple over()
-- Question : Find the total sales across all orders 
-- Find the total sales for each product
-- Additionally provide details such as order Id, Order date
select OrderID, OrderDate,ProductID,Sales,
sum(Sales) over() as totalsales,
sum(sales) over(Partition by ProductID) as totalsalesByproducts
from orders_sales;
# we can use multiple time over() in a single query in window functions

# With Over(Partition by Multiple Categories)
-- Question : Find the total sales across all orders 
-- Find the total sales for each product
-- Find the total Sales for each combination of product and order status
-- Additionally provide details such as order Id, Order date

select OrderID, OrderDate,ProductID,Sales,OrderStatus,
sum(Sales) over() as totalsales,
sum(sales) over(Partition by ProductID) as totalsalesByproducts,
sum(sales) over (partition by ProductID, OrderStatus) as totalsalesbyproctsandstatus
from orders_sales;

-- **************************************************************************************************************************************

# 2.
# ORDER BY
# It will Sort the data within a window (asc/desc)
# This is optional for Aggregate Function
# But this is must required for Rank and Value functions

-- Question: Rank each order based on their sales form highest to lowerest
-- Additionally provide details such as order Id, Order date
select OrderID, ProductID, OrderDate, Sales,
RANK() over (order by Sales desc)
from orders_sales;

select OrderID, ProductID, OrderDate, Sales,
RANK() over (partition by ProducID order by Sales desc)
from orders_sales;

-- **************************************************************************************************************************************


# 3. 
# Window Frame
# ROWS UNCOUNDED PRECEDING
# define a subset of rows within each window
# step1 : firstly our result set divided into multiple windows
# step2 : Now if i want to apply calculations on specific rows form each windows as a subset of each windows (window inside a window)

/*
syntax : 
avg(sales) over(partition by category order by OrderDate
Rows        Between   Current ROW                     and      Unbound Following
frame type		  	  Frame boundary(lower value)		       Frame boundary(highest value)

Frame Type :- Rows , Range
Frame boundary(lower value) :- 							Frame boundary(highest value):-
Current Row												Current Row						
N Preceding												N Following
Unbounded Preceding										unbounded Following

Rules :-
Frame clause can only be used together with order by clause
Lower value must be before the highest value
unbounded following - the last possible row within a window

Example 1.
Sum(sales)
over(order by Month
Rows Between Current Row and 2 following)

here we have 5 rows only
 
step 1: here frame start from the currect row means first row and select till 3rd row.
then it sum the sales from current row - 3rd row and the result will be wriiten in first row

step 2: Now current row is 2nd row and after following 2, now it will calculate the sum of sales from 2nd row - 4th row.
and the result will be wriiten in 2nd row

step 3: Now current row is 3rd row and after following 2, now it will calculate the sum of sales from 3rd row - 5th row
and the result will be written in 3rd row

step 4: Now current row is 4th row and after following 2, now it will calculate the sum of sales from 4th row - 5th row, because now we 
don't have more rows and the result will be written in 4th row

step 5 : Now current row is 5th row and after following 2, now it will calculate the sum of sales of 5th row only, because now we 
don't have more rows and the result will be written in 5th row

Month 			Sales 					Result
JAN				20						60
FEB 			10						45
MAR				30						105
APR				5						75
JUN				70						70


Example 2.
Sum(sales)
over(order by Month
Rows Between Current Row and unbounded following)

unbounded following - the last possible row within a window

# in this case only current row will change and unbounded row is fixed as the last row
here we have 5 rows only
 
step 1: here frame start from the currect row means first row and select till 5th row.
then it sum the sales from current row - 5th row and the result will be wriiten in first row

step 2: Now current row is 2nd row and select till 5th row, now it will calculate the sum of sales from 2nd row - 5th row.
and the result will be wriiten in 2nd row

step 3: Now current row is 3rd row and select till 5th row, now it will calculate the sum of sales from 3rd row - 5th row
and the result will be written in 3rd row

step 4: Now current row is 4th row and select till 5th row, now it will calculate the sum of sales from 4th row - 5th row, 
and result will be written in 4th row

step 5 : Now current row is 5th row, now it will calculate the sum of sales of 5th row only, and the result will be written in 5th row


Example 3.
Sum(sales)
over(order by Month
Rows Between 1 preceding and current row)

Preceding row - nth row before the current row
1 preceding means 1 row before the current row

# in this case we will calculate the sum of sales before the current row
# current row can be any row 
# but in this case we assume current row as last row
here we have 5 rows only
 
step 1: here frame start from the currect row means last row and select till 4rd row beacuse it goes from last row to first row.
then it sum the sales from current row - 4th row and the result will be wriiten in 5th row

step 2: Now current row is 4th row and after preceding 1, now it will calculate the sum of sales from 4th row - 3th row.
and the result will be wriiten in 4th row

step 3: Now current row is 3rd row and after preceding 1, now it will calculate the sum of sales from 3rd row - 2th row
and the result will be written in 3rd row

step 4: Now current row is 2nd row and after preceding 1, now it will calculate the sum of sales from 2nd row - 1st row 
and the result will be written in 2nd row

step 5 : Now current row is 1st row and after preceding 1, now it will calculate the sum of sales of 1st row only, because now we 
don't have more rows and the result will be written in 1st row


Example 4.
Sum(sales)
over(order by Month
Rows Between Unbounded preceding and current row)

Unbounded preceding :- The first possible row within a window
# in this case only current row will change and unbounded row is fixed as the last row

# this case is same as Example 2, but in this case the unbounded proceding is first row and 
current row will precede(move) from first row to last row

like first it will calculate the sum of sales of current row and unbounded row which is first row and 
than current row will precede to 2nd row and it will calculate the sum of sales of current row and 2nd row and soo as go on


Example 5.
Sum(sales)
over(order by Month
Rows Between 1 preceding and 1 following)

Step 1 : - the current row is 1st row than 1 preceding will be nUll row and 1 following will be 2nd row and it will calculate 
the sum of 1st - 2nd rows and written in 1st row

step 2: Current Row = Row 2
1 Preceding: Row 1
Current: Row 2
1 Following: Row 3
Action: It calculates (Row 1 + Row 2 + Row 3) and writes the result into Row 2.

step 3: Current Row = Row 3
1 Preceding: Row 2
Current: Row 3
1 Following: Row 4
Action: It calculates (Row 2 + Row 3 + Row 4) and writes the result into Row 3. 

step 4: Current Row = Row 4
1 Preceding: Row 3
Current: Row 4
1 Following: Row 5
Action: It calculates (Row 3 + Row 4 + Row 5) and writes the result into Row 4.

step 5: Current Row = Row 5
1 Preceding: Row 4
Current: Row 5
1 Following: nothing
Action: It calculates (Row 4 + Row 5) and writes the result into Row 5.


Example 6.
Sum(sales)
over(order by Month
Rows Between unbounded preceding and unbounded following)

in this case all the rows will be selected, and sum is same for all rows
current row can be anything but sum is same

*/

# default frame : ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
# default frame is working only with order BY

select OrderID, ProductID, OrderDate, OrderStatus, Sales,
sum(Sales) over(partition by OrderStatus order by OrderDate
Rows between current row and 1 following) as example1,

sum(Sales) over(partition by OrderStatus order by OrderDate
Rows between current row and 2 following) as example2,

sum(Sales) over(partition by OrderStatus order by OrderDate
Rows between 1 preceding and current row) as example3,

sum(Sales) over(partition by OrderStatus order by OrderDate
Rows between current row and unbounded following) as example4,

sum(Sales) over(partition by OrderStatus order by OrderDate
Rows between unbounded preceding and current row) as example5,  -- default frame

sum(Sales) over(partition by OrderStatus order by OrderDate
Rows between unbounded preceding and unbounded following) as example6,

sum(Sales) over(partition by OrderStatus order by OrderDate) as example7
from orders_sales;


# Window Function Rules:-

# 1. this can be allowd with select and order by clause
# 2. Nested window function is not allowed
# 3. SQL execute Window function after where clause
# 4. window function can be used together with Group BY in the same query, Only if the same columns are used

# Question -- Rank customers based on their total sales

select CustomerID, sum(Sales),
Rank() over(order by sum(sales) desc) rankcustomers
from orders_sales
group by CustomerID;

# here sum(sales) is same in both group by and windows function 

# when we working with Group by and Window Function than we shoild firstly write the group by query than window functions.