use data_with_baraa;

# Set Operators 
# Combine the rows of tables

/*
Syntax:- 

select * from customers;
Set Operator
select * from orders;

Rules :- 
1. For SQL Clauses 
Set operators can be used in almost all sql clauses (where, join, group by, having)
Order by is allowed only once at the end of the query

select * from customers;
join clause
where clause
group by clause
having clause

Set Operator

select * from orders;
join clause
where clause
group by clause
having clause

order by clause 


2. Numner of Columns
The number of columns in both query must be the same


select id , first_name from customers
union ALL
select id, name from persons; 

3. Data types
Data types of column in each query must be comnpatible

select id , first_name from customers
union ALL
select id, name from persons; 

here both query have same data type of their column



4. Order of Columns
The order of columns in each query must be same

select id , first_name from customers
union ALL
select id, name from persons; 

here the orderd od both tables are same

but if we write this 
select id , first_name from customers
union ALL
select name, id from persons; 

than it doesn;t give me error because 
SQL does not care about the Column Names.
MySQL (and many other SQL engines) is often "lenient" and will not give you a syntax error as long as the number of columns matches
MySQL tries to be helpful by automatically converting data types to a "common denominator."
IF we apply Union on a Int and Varchar data type than MYSQL will automatically convert the entire resulting column to the Varchar


5. Column Alias
The column name in the result set are determined by the column names specified in the first query

select id , first_name from customers
union ALL
select id, name from persons; 

SQL treats the first SELECT statement as the "Template" for the entire result set. It defines the headers and the data types.



6. Mapping Correct Columns
Even if all rules are met and SQL shows no errors, the result may be incorrect
Incorect column selection leads to inaccurate results

select id , first_name from customers
union ALL
select name, id from persons; 

here ordrs of column is wrongs, but it is not giving any error and giving results but that is wrong result

*/

-- *********************************************************************************************************************************--

# Types of Set Operators:-

# 1. Union
# Return all distinct rows from both tables
# REMOVES ALL duplicates rows from result set

# Combine the data from customers and persons into one table, excluding duplicates
select id , first_name from customers
union
select id, name from persons; 

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50),
    Department VARCHAR(50),
    BirthDate DATE,
    Gender varchar(10),
    Salary DECIMAL(10, 2),
    ManagerID INT 
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, BirthDate, Gender, Salary, ManagerID) VALUES
(1, 'Alice', 'Johnson', 'Sales', '1988-12-05','M', 55000, NULL),
(2, 'Bob', 'Smith', 'Sales', '1972-11-25','M', 48000, 1),
(3, 'Charlie', 'Davis', 'Marketing', '1986-01-05', 'F',60000, 1),
(4, 'Daniela', 'Fernandez', 'IT', '1977-02-10', 'M',72000, 2),
(5, 'Carol', 'Baker', 'Marketing', '1982-02-11', 'F', 55000, 3);

select * from employees;


# 2. Union ALL
# Return all rows from both queries, including duplicates 
# union all is faster than the union
# If you confident there are no duplicates, Use Union all
# Use Union all to find duplicates and quality issues

# Combine the data from customers and employees into one table, including duplicates
select id , first_name from customers
union ALL
select EmployeeID, FirstName from employees; 


# 3. Except 
# Return all distinct rows from the first query that are not found in second query
# Order of the query is important
# Remove all the common rows from the both tables

# find employees who are not customers at the same time
select id, first_name from customers
Except
select id, name from persons;

# Order id important
select id, name from persons
Except
select id, first_name from customers;

# MySQL 8.0.31 and greater version have Except and Intersect command

# If you want than use left join/ right join
select customers.id, first_name, persons.id, name from persons
left join customers on 
customers.id = persons.id
where customers.id is Null;


# 4. Intersect
# Return only the rows that are common in both queries

# Find the employees who are also customers
select id, name from persons
Intersect
select id, first_name from customers;

# MySQL 8.0.31 and greater version have Except and Intersect command
# If you want you can use Inner Join
select customers.id, first_name, persons.id, name from customers
inner join persons on 
customers.id = persons.id;


# Use Cases
# 1. Combine Inforamtion - Union & Union all
# 2. Delta detection - Except
# 3. Data completeness -  Except