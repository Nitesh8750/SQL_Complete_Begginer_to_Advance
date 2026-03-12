# Aggregate Functions

use data_with_baraa;

# find the total no of orders
select count(*) from orders_Sales;

# find the total sales of all orders
select sum(Sales) from orders_sales;

# find the avg sales of all orders 
select avg(Sales) from orders_sales;

# find the Highest sales amount
select max(Sales) from orders_sales;

# find the lowest sales amount
select min(Sales) from orders_sales;

select CustomerID,
count(*) as total_orders,
sum(Sales) as total_sales,
avg(Sales) as avg_sales,
max(Sales) as Max_sales,
min(Sales) as min_sales
from orders_sales
group by customerID
order by CustomerID asc;