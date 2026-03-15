# Window Rank Functions
/*
RANK Functions		Expression datatype
	ROW_NUMBER()		EMPTY
	RANK()				EMPTY			
    DENSE_RANK()		EMPTY			
    CUME_DIST()			EMPTY			
    PERCENT_RANK()		EMPTY
    NTILE(n)			Numeric	


# Their are two types of Ranking:-
# 1. Integer Based Ranking :- 1,2,3,4,5
# It shows discrete values
# this method help in finding top 3 products
# this type of analysis is called Top/Bottom N Analysis
# functions are :- Row_Number(), Rank(), Dense_Rank(), NTILE()


# 2. Percentage Based Ranking :- Assign a percentage to each row (0, 0.25, 0.5, 0.75, 1)
# It shows continuous values
# this method helps in % based questions , find top 20% products
# this type of analysis is called distrinution analysis
# Functions are :- CUME_DIST(), PERCENT_RANK()

Syntax:-

Rank() over(partition by ProductId order by Sales desc)

here rank is mustly empty
Partition by is optional
order by is must parameter
Frame function is not allowed 

1. Row_Number() 	|	Assign a unique number to each in a window			|	ROW_NUMBER() OVER (ORDER BY Sales)
2. Rank()		  	|	Assign a rank to rach row in a window, with gaps	|	RANK() OVER (ORDER BY Sales)
3. Dense_Rank()		|	Assign a rank to rach row in a window, without gaps	|	DENSE_RANK() OVER(ORDER BY Sales)
4. CUME_DIST()		|	Calculates the cumulative distribution of a value 	|	CUME_DIST OVER(ORDER BY Sales)
					|	within a set of values								|
5. PERCENT_RANK()	|	Returns the percentile ranking number of row		|	PERCENT_RANK() OVER(ORDER BY Sales)
6. NTILE(n)			|	Divides the rows into a specified number of 		|	NTILE(2) OVER(ORDER BY Sales)
					|	approximately equal groups							|
*/



-- Rank the products based on their sales
select OrderID, ProductID, Sales,
Rank() over(partition by ProductId order by Sales desc)
from orders_Sales;

-- **********************************************************************************************************************************
# Integer Based Ranking

# 1. ROW_NUMNBER()
# Assign a unique number to each in a window	
# It doesn't handle ties. means even the window row have same value but it will give unique rank to every row
# Unique Ranking Without Gaps/ skipping

select OrderID, ProductID, Sales,
Row_Number() over(partition by ProductId order by Sales desc)
from orders_Sales;

-- Rank the orders based on their sales from highest to lowest
select OrderID, ProductID, Sales,
row_number() over(order by Sales desc) as ordersales
from orders_Sales;

# Top-N analysis
-- Find the top highest sales for each product
select * from
(	
    select OrderID, ProductID, Sales,
	row_number() over(partition by ProductId order by Sales desc) orderbysale
	from orders_Sales
)t 
where orderbysale = 1;

# Bottom-N analysis
-- Find the lowest 2 customers based on their sales
select * from
(
	select CustomerID,
	sum(Sales) totalsales,
	row_number() over(order by sum(Sales)) rankcustomers
	from orders_sales
	group by CustomerID
)t 
where rankcustomers between 1 and 2;


# Generate Unique IDS
# when we does not have any Unique ID or Primary Key in the table 
# than we use Row_number() to generate the unique id


# Indentufy Duplicates
select * from(	
    select *,
	row_number() over(partition by OrderID order by CreationTime) uniqueid
	from orders_sales
)t
where uniqueid = 1 ; -- it gives only unique rows

# where uniqueid > 2 -- to print only the duplicates data


# when we does not have any Unique ID or Primary Key in the table , but we have any datetime column which is unique
# here we are finding dupicated OrderId, we are Creation time as order by , so that it give us no of duplicates like 2 and 3 
# but it gives us 1 because orderid is unique here
# it use to find the occurance of the OrdeID in a table


-- **********************************************************************************************************************************

# 2. RANK()
# Assign a rank to rach row in a window, with gaps
# It handle ties - shared ranking
# It leaves gaps in ranking.

-- Rank the orders based on their sales from highest to lowest
select OrderID, ProductID, Sales,
rank() over(order by Sales desc) as ordersales
from orders_Sales;
# here we see that at we have same Sales amount, and the rank will give the same rank to both values but also 
# it will skip the next rank number
# E.g. it assign both Sales 60 as rank 2 but than it skip the rank 3 and continue with rank 4

-- **********************************************************************************************************************************

# 3. Dense_Rank()
# Assign a rank to rach row in a window, without gaps
# It handle ties - shared ranking
# It doesn't leaves gaps in ranking

-- Rank the orders based on their sales from highest to lowest
select OrderID, ProductID, Sales,
dense_rank() over(order by Sales desc) as ordersales
from orders_Sales;

# here we see that at we have same Sales amount, and the rank will give the same rank 2 to both values 
# and it will next sales amount as rank 3
# E.g. it assign both Sales 60 as rank 2 and continue with rank 3 in next sales


-- **********************************************************************************************************************************

# 4. NTILE(n)
# Divides the rows into a specified number of approximately equal groups(buckets)
# NTILE(2) OVER(ORDER BY Sales)
# bucket size = No of rows / No of buckets you want

select OrderID, ProductID, Sales,
ntile(1) over(order by Sales desc) bucket1,
ntile(2) over(order by Sales desc) bucket2,
ntile(3) over(order by Sales desc) bucket3,
ntile(4) over(order by Sales desc) bucket4
from orders_Sales;

-- Larger Group comes first

# Data Segmentation
# Divides the dataset into distinct subsets based on certain criteria

-- Segment all orders into 3 categories :  high, Medium, Low sales
Select *,
case 
	when bucket3 = 1 then 'High'
    when bucket3 = 2 then 'Medium'
    when bucket3 = 3 then 'Low'
END salessegmentations
from
(
	select OrderID, ProductID, Sales,
	ntile(3) over(order by Sales desc) bucket3
	from orders_Sales
)t;


# Equalizing Load
# lets assume we have 2 databases, we want to move a big table from database1 to database2,
# if we move directly than it can take lots or time or may be it failed
# so that why we firstly we firstly divide the big table into smaller table like buckets by using NTILE(n)
# and then move the all buckets and in database we apply apply union all to combine the buckets

-- In order to export the data, divide the orders into 2 groups.
select *,
Ntile(2) over (order by OrderID) bucket2 -- primary key if we doesnot have any column to sort the table
from orders_sales;

-- **********************************************************************************************************************************

# Percentage Based Ranking

# CUME_DIST = Position Nr / No of rows

# PERCENT_RANK = Position Nr - 1 / No of rows - 1 
# Postion Nr - Position No of current row


# 1. CUME_DIST()
# cumulative distribution Calculates the distribution of data points within a window
#  CUME_DIST OVER(ORDER BY Sales)
# CUME_DIST = Position Nr / No of rows
# Postion Nr - Position No of current row

# Tie Rule:- The position of the last occurrence of the same value
# When we have sales value in 2 continuos rows than Position Nr will be last occurance of the value
# e.g. second row and third row has same sales value then Position Nr will be 3 for both 2nd and 3rd row


# 2. PERCENT_RANK()
# Returns the percentile ranking number of row
# Calculates the relative position of each row
# PERCENT_RANK() OVER(ORDER BY Sales)
# PERCENT_RANK = Position Nr - 1 / No of rows - 1 
# Postion Nr - Position No of current row

# Tie Rule:- The position of the first occurrence of the same value
# When we have sales value in 2 continuos rows than Position Nr will be first occurance of the value
# e.g. second row and third row has same sales value then Position Nr will be 2 for both 2nd and 3rd row


-- Find the products that falls within the highest 40% of the prices

select *,
concat(distrankcume * 100, '%') distrankper ,
concat(distrankpercent * 100, '%') distrankper
from
(
	select Product, Price,
	cume_dist() over (order by Price desc) distrankcume,
    percent_rank() over (order by Price desc) distrankpercent
	from products
)t
where distrankcume <= 0.4 or distrankpercent <= 0.4;


-- Find the sales percentage of each proudct by customers
select OrderID, ProductID, CustomerID, Sales,
cume_dist() over(order by Sales desc) cumeper,
percent_rank() over (order by Sales desc) percentper
from orders_sales;
