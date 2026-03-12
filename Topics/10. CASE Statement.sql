# Case Statement
# Evaluate a list of condition and returns a vlaue when the first condition is met

/*
case 								-- start of the logic
	when condition1 then result1  -- if its true than it give result1
    when condition2 then result2  -- this will execute if condition1 is not true
    when condition2 then result3  -- this will execute if condition2 is not true
    ....
    ELSE result -- If none of condition is true than it will execute, it is optional(default value)
END									-- End of the logic

*/

select ID,Score,
CASE
	when score >= 500 then 'High'
	when score >= 300 then 'Medium'
    else 'Low'
END as case_st

from customers;


# USE CASES
# Main Purpose of Case Statement is Data Transformation
	# we can generate new data based on existing data
    
# Rule :- 
# data type of results must be matching in CASE condition

# 1. Categorizing Data
# Group the data into different categories based on certain conditions becuase it will help us to classify the data and also aggregate the
# data

# Generate the Report showing the total sales for each categories :
# High (sales over 50), Medium(Sales 21-50) and Low(sales 20 or less)
# Sort the Categories from highest sales to lowest

select category, sum(Sales) as total_sales
from(
	select OrderID, Sales,
	CASE
		when Sales > 50 then 'High'
		when Sales > 21 then 'Medium'    -- here data type of all type results are same
		else 'Low'
	END   As category
	from orders_sales
)tata
group by category order by total_sales desc;


# 2. Mapping
# Transform the data from one form to another

# Retrive employee details with gender displayed as full text

select EmployeeID, FirstName, LastName, Gender,
CASE
	when Gender  = 'M' then 'Male'
	when Gender  = 'F' then 'Female'
    else 'unknown'
END as full_text
from employees;


# Retrive customers details with abbreviated country code

select * ,
Case
	When Country = 'USA' then 'US'
	When Country = 'Germany' then 'Ge'
	When Country = 'France' then 'Fr'
    else 'N/A'
END as abbrevated_country
from customers;


# Quick Form
# If we are mapping and if we have a same column for all when conditions than we can write this syntax
/*
Case Country
	When 'USA' then 'US'
	When 'Germany' then 'Ge'
	When 'France' then 'Fr'
    else 'N/A'
END
*/

# 3. Handling NULL
# Replacing NULLS with a specific value

# Find the average score of customers and treat Nulls as 0
# Additionally provide the details such as CustomerID and Name 

select * ,
avg(score) over () avg_score,
Case
	when score is NULL then 0
    else score
END as clean,
avg(
Case
	when score is NULL then 0
    else score
END 
) 
over () avgcustomerclean -- when i using aggregate without groupby i have to use Over() for alias 
from customers;


# 4. Conditional Aggregation
# Apply aggregate functions only on subsets of data that fulfill certain conditions

# count how many times each customers has made an order with sales greater than 30

select OrderID, CustomerID, Sales,
CASE
	when sales > 30 then 1
    else 0
END salesflag
from orders_Sales;

select CustomerID, 
sum(CASE
	when sales > 30 then 1
    else 0
END
) as totalorders
from orders_Sales
group by customerID
order by CustomerID asc;


# FLAG 
# Binay indicator(1,0) to be summarized to show how many time the condition is true

