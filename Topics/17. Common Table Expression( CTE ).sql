# Common Table Expression (CTE) 
# Temporary, named result set(Virtual table) that can be used multiple times within any query to simplify and organize complex query

use data_with_baraa;
# firstly CTE query will execute than Main query will execute beacuse 
# CTE query create a result table which is temporary table, and the main query will perform in that result table
# CTE result table is only used by the main query, we can't apply joins to add any other with that result table

# Difference with Subquery
# in Subquery 
# Firstly Subquery will perform and based on the based on the subquery result table, Main query will perform
# It is bottom to top operation
# In subquery, The intermediate table (Result table by Subquery) can be used only one time within a query by main query

# IN CTE
# Firstly CTE query will  perform and create a result table, and with the result table er perform Main query
# It is TOP to Bottom operation
# IN CTE, The intermediate table can be used multiple times within any query 
# IN CTE, we can divide a complex query into different table table us to easily understand the code and Easy to Read.

/*
____________________________________________________________________________________________________
CTE_Top_customer																					|
select 																								|	
from custoemrs			---------------------------------------	|									|		Readability
where															|									|		
																|									|		
CTE_Top_products												|									|		
select from products	----------------------------------------|------------>>>>> CTE Query 		|		Modulariry
join															|									|
																|									|
CTE_Daily_Revenue												|									|		Reusability
select															|									|
from orders				----------------------------------------|									|
Join																								|
																									|
Select																								|
from																								| 
join					----------------------------------------|	--->>>>>>  Main Query 			|
where 																								|
____________________________________________________________________________________________________|

*/

-- *************************************************************************************************************************************

# CTE TYPES
# 1. Non - Recursive CTE 
#	 1.1 Standalone CTE
#		 1.1.1 Single Standalone CTE
#        1.1.2 Mutiple Standalone CTE
#    1.2 Nested CTE

# 2. Recursive CTE

-- *************************************************************************************************************************************

# 1.1 Standalone(Independent) CTE
# Defined and Used Independently
# Runs independently as its self-contained and does not rely on other CTE's or queries
# in this query main query is depend upon the cte query
# Is is executed only once wihtout any repetition

# 1.1.1: Single Standalone CTE

/*
Syntax

With CTE-NAME as 
(
	Select ....
    from ....
    where ....
)

select ....
from CTE_NAME
where ....
*/


-- Find the total Sales per customer
# CTE
WITH cte_total_sales as
(
select CustomerId, sum(Sales) as total_sales
from orders_Sales
group by CustomerID
order by CustomerID
)

# Main Query
select c.ID, c.First_Name, c.Country,cts.total_sales
from customers as c
left join cte_total_sales as cts on 
c.ID = cts.CustomerID;


# 1.1.2 : Multiple Standalone CTE
# In multiple CTE all the CTE are independent to each other, self contained.

/*
Syntax

With CTE-NAME1 as 
(
	Select ....
    from ....
    where ....
),
CTE-NAME2 as 
(
	Select ....
    from ....
    where ....
),
CTE-NAME3 as
(
	Select ....
    from ....
    where ....
)

select ....
from CTE_NAME1,
from CTE_NAME2,
from CTE_NAME3,
where ....
*/

-- Find the total Sales per customer
-- Find the last order date per customer

with cte_total_sale as
(
select CustomerID, sum(sales) as totalsale
from orders_sales
group by customerID
order by CustomerID
),

cte_last_order as 
(
select customerID, Max(OrderDate) as last_order_date
from orders_sales
group by customerID
order by customerID
)

select c.ID, c.First_Name, c.Country, cts.totalsale, cto.last_order_date
from customers as c
left join cte_total_sale as cts on 
c.ID = cts.CustomerID
left join cte_last_order as cto on
c.ID = cto.CustomerID;

-- *************************************************************************************************************************************

# 1.2 Nested CTE
# CTE inside another CTE
# A nested CTE used the result of another CTE, so it can't run independent

/*
Syntax

With CTE-NAME1 as 
(
	Select ....
    from ....
    where ....
),
With CTE-NAME2 as 
(
	Select ....
    from CTE_NAME1   ---->>>>> Nested CTE
    where ....
)

select ....
from CTE_NAME2 or from CTE_NAME1
where ....
*/


-- Find the total Sales per customer
-- Find the last order date per customer
-- Rank customers based on total Sales per customer
-- Segemt customers based on their sales

-- Step 1. Find the total Sales per customer
with cte_total_sale as
(
select CustomerID, sum(coalesce(Sales,0)) as totalsale
from orders_sales
group by customerID
order by CustomerID
),

-- Step 2. Find the last order date per customer
cte_last_order as 
(
select customerID, Max(OrderDate) as last_order_date
from orders_sales
group by customerID
order by customerID
),

-- Step 3. Rank customers based on total Sales per customer
cte_rank as 
(
select *,
rank() over(order by totalsale desc) as sale_rank
from cte_total_sale
),

-- Segemt customers based on their sales
cte_customer_segement as 
(
select customerID, totalsale,
Case 
	when totalsale > 120 then 'High'
    when totalsale > 100 then 'Medium'
    ELSE 'LOW'
END as sale_segement
from cte_total_sale
)

select c.ID, c.First_Name, c.Country, cts.totalsale, cto.last_order_date, ctr.sale_rank, ctseg.sale_segement
from customers as c
left join cte_total_sale as cts on 
c.ID = cts.CustomerID
left join cte_last_order as cto on
c.ID = cto.CustomerID
left join cte_rank as ctr on
c.ID = ctr.CustomerID
left join cte_customer_segement as ctseg on
c.ID = ctseg.CustomerID;


-- *************************************************************************************************************************************

# 2. Recursive CTE
# Self-referencing query that repeatedly processess data until a specific condition is met
# Keep looping until all the condition in CTE is matched
# No interation and NO looping in Main query
# the default recursive number is 1001

/*
with recursive CTE_NAME as
(
select ....
from ....				Anchor Query, this is execute only once
where ....

Union ALL

select ....				the second select query will check all condition in same CTE as we using From as same CTE name
from CTE-NAME           Recusive Query, this is execute until all condition will met
where ....				--------->>>>>> Break condition
)

*/


# In MySQL, you don't put the limit at the end of the SELECT statement. 
# Instead, you set a session variable before you run your query.
# this will allow us to put a limit till the interation can execute
# default is 1001

-- Set the limit to 10 loops
SET SESSION cte_max_recursion_depth = 5000;

-- Generated a sequence of mnumbers from 1 to 20

-- Anchor query
with recursive cte_series as 
(
select 
1 as mynumber

Union all

-- Recursive query
select  
mynumber + 1
from cte_series
where mynumber < 2000
)

-- Main query
select * from cte_series;



-- Show the employee hierarchy by displaying each employee's level within the organization

-- Anchor query
with recursive cte_hierarchy as
(
select EmployeeID, FirstName, ManagerID,
1 as Level
from employees
where ManagerID is NULL

Union all

select e.EmployeeID, e.FirstName, e.ManagerID,
Level + 1
from employees as e
inner join cte_hierarchy ceh on
e.ManagerID = ceh.EmployeeID
)

-- Main query
select * from cte_hierarchy;