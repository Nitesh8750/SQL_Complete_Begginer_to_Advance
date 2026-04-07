# 30X Performace Tips

-- Golden Rule
# Always check the execution plan to confirm performance improvements when optimizing your query

# If there's no improvements then just focus on readability

-- Best Practices

-- 1. Fetching Data

# Tip 1 : Select only what you need
select * from customers;  -- bad way

select CustomerID, First_Name from customers; -- good way

# Tip 2 : Avoid unnecessary Distinct & ORDER BY
select Distinct First_Name from customers
order by First_Name;  -- not always we have to choose this method

select First_Name from custoemrs; -- correct method


# Tip 3 : For explore Purpose, limit Rows

select OrderID, Sales from Orders_sales;  -- bad practice

select OrderId, Sales from orders_sales limit 10;   -- choose only top rows for just exploration


-- ***************************************************************************************************************************************

-- 2. Filtering Data

# Tip 4 : Create non clustered index on frequently used columns in where clause

select * from orders_sales where OrderStatus = 'Delivered';

create index idx_status on orders_sales(OrderStatus);   -- good way


# Tip 5 : Avoid applying functions to columns in where clauses 

select * from orders_sales 
where lower(OrderStatus) = 'delivered';  -- bad ways

-- we shoild not functions in where clause, because if we does than we can't index on this query.

select * from orders_sales
where OrderStatus = 'Delivered';  -- good ways


select * from employees
where substring(FirstName, 1, 1) = 'A';   -- bad way

select * from employees
where FirstName like 'a%';   -- good ways

-- try to avoid functions in where clause as much as you can
-- because we can't use index with that query in future than


select * from orders_sales
where year(OrderDate) = 2025;       -- bad way


select * from orders_sales
where OrderDate between '2025-01-01' and '2025-12-31';  -- good ways


# Tip 6 : Avoid leading wildcards as they prevent index usage

select * from employees
where LastName like '%s%';   -- don't try to use both side %

select * from employees
where LastName like 's%';  -- good way


# Tip 7 : Use IN operator instead of Multiples OR operators

select * from employees
where EmployeeID = 1 OR EmployeeID = 2 OR EmployeeID = 3;  -- bad way

select * from employees
where EmployeeID in (1,2,3);  -- good way

-- ***************************************************************************************************************************************

-- 3. Joins 

# Tip 8 : Understand The speed of Joins and Use Inner join when possible

-- Best Performance
select c.First_name, o.OrderID from customers as c inner join orders_sales as o on c.ID = o.CustomerID;

-- Slightly SLower Performance
select c.First_name, o.OrderID from customers as c right join orders_sales as o on c.ID = o.CustomerID;
select c.First_name, o.OrderID from customers as c left join orders_sales as o on c.ID = o.CustomerID;

-- Worst Performance
select c.First_name, o.OrderID from customers as c join orders_sales as o on c.ID = o.CustomerID;


# Tip 9 : use explicit join (ANSI Join) instead of Implicit Join (NON-ANSI Join)

select c.First_name, o.OrderID from customers as c , orders_sales as o where c.ID = o.CustomerID;   -- bad way

select c.First_name, o.OrderID from customers as c inner join orders_sales as o on c.ID = o.CustomerID;  -- good way


# Tip 10 : Make sure to index the columns used in the ON clause

select c.First_name, o.OrderID from customers as c inner join orders_sales as o on c.ID = o.CustomerID -- good way

create index idx_orders_customerID on orders_sales(CustomerID);


# Tip 11 : Filter Before joining the big tables

-- Filter After Join (Where)
select c.First_name, o.OrderID from customers as c inner join orders_sales as o on c.ID = o.CustomerID where o.OrderStatus = 'Delivered';

-- Filter During Join (ON)
select c.First_name, o.OrderID from customers as c inner join orders_sales as o on c.ID = o.CustomerID and o.OrderStatus = 'Delivered';

-- Filter Before Join (Sub query)
select c.First_name, o.OrderID from customers as c inner join 
(select OrderId, CustomerID from orders_sales where o.OrderStatus = 'Delivered') o
on c.ID = o.CustomerID;


# Tip 12 : Aggregate Before Joining the tables (big tables)

-- Grouping and Joining
select c.ID, c.First_name, count(o.OrderID) as order_count from customers as c inner join orders_sales as o 
on c.ID = o.CustomerID  group by c.ID, c.First_name;     

-- Pre-aggregated subquery
select c.ID, c.First_name, o.order_count from customers as c inner join 
(select customerID, count(OrderID) as order_count from orders_sales group by CustomerID) as o 
on c.ID = o.CustomerID;

-- Corelated Subquery
select c.ID, c.First_name,
(select count(OrderID) from orders_sales as o
where c.ID = o.CustomerID) as order_count
from customers as c;


# Tip 13 : use Union instead of OR in Joins

-- Bad
select c.First_name, o.OrderID from customers as c inner join orders_sales as o 
on c.ID = o.CustomerID or c.Id = o.SalesPersonID;     -- very bad

-- best way
select c.First_name, o.OrderID from customers as c inner join orders_sales as o 
on c.ID = o.CustomerID
union
select c.First_name, o.OrderID from customers as c inner join orders_sales as o 
on c.ID = o.SalesPersonID;


# Tip 14 : Check for Nested Loops and Use SQL Hints