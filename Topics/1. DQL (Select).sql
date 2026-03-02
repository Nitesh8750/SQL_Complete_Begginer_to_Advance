show databases;

-- This is comment
/* 
This is comment
*/

/*

DQL - Data Query Language
1. Select
2. From
3. Where
4. order by
5. Group by
6. Having
7. Distinct
8. limit
9. Execution order
*/


/* Impotant
Note :- 
1. where and having difference
- If we want to filter the data before aggregation than we use Where clause 
- If we want to filter the data after aggregation than we use Having clause

*/



create database Data_with_Baraa;

CREATE TABLE Customers (
    ID INT PRIMARY KEY,
    First_name VARCHAR(100) NOT NULL,
    Country VARCHAR(100),
    Score INT
);

INSERT INTO Customers (ID, First_name, Country, Score) VALUES
(1, 'Maria', 'Germany', 350),
(2, 'John', 'USA', 900),
(3, 'Georg', 'USA', 750),
(4, 'Martin', 'Germany', 500),
(5, 'Peter', 'USA', NULL);

-- 1. Retrive all rows and columns
select * from customers;

/* From this query firstly 
1. From command will run and drive the data from database
2. select command will run and print the data
*/

-- ************************************************************************************************************************************--

-- 2. Use Where condition with Select
select * from customers where score>500;
select * from customers where score != 0;
select * from customers where country = 'Germany';

/* From this query Firstly
1. From command will run and drive the data from database
2. Where Condition will run to check the condition 
3. select command will run to print the data
*/

-- ************************************************************************************************************************************--

-- 3. Use Order by with Select
-- to sort the data Asc and desc, default asc
select * from customers order by score desc;
select * from customers where score > 500 order by first_name asc;
-- Nested Sorting
select * from customers order by country,score asc;
select * from customers order by country asc, score desc;

/*
1. From command will run and drive the data from database
2. Where Condition will run to check the condition 
3. Order by run to sort the table according to column and sorting types
4. select command will run to print the data
*/

-- ************************************************************************************************************************************--

-- 4. Use Group by
-- Group by comes in between where and order by conditons

-- syntax :- 
-- select "group by column" , aggregation column from table group by column name
-- group by column = thats means firstly we write the column on which we want to apply group by function and
-- aggregation column = thats means secondly we write the column name on which we want to apply aggregate functions

select country, sum(score) as total_score from customers group by country;

-- we will write only those columns name which are either using for grouping or aggregation
select country, first_name , sum(score) as total_score from customers group by country;
select country, first_name , sum(score) as total_score from customers group by country, first_name;

# Find the total score and total numnber of customers for each country
select country, sum(score) total_score, count(id) as No_of_customers from customers group by country;

/* 
1. From command will run and drive the data from database
2. Group by command will run to group the same categories
3. aggregation function will run
4. select command will run to print the data
*/

-- ************************************************************************************************************************************--

-- 5. Having Query
-- Fiters data after aggregation
-- we cant use aggregate functions with where command so we use having command
-- Having command will only used with Group by

-- 1. Syntax:-
--  select "group by column" , aggregation column from table group by column name having condion

/* 
1. From command will run and drive the data from database
2. Group by command will run to group the same categories
3. aggregation function will run
4. having command will run according to the condition 
5. select command will run to print the data
*/

select country, sum(score) from customers group by country having sum(score)>800;

-- 2. Syntax :-
-- select "group by column" , aggregation column from table where clause group by column name having condion

/*
1. From command will run and drive the data from database
2. Where command will run according to the condition and before the aggregation
2. Group by command will run to group the same categories
3. aggregation function will run
4. having command will run according to the condition and after the aggregation
5. select command will run to print the data
*/

select country, sum(score) from customers where score > 400 group by country having sum(score) > 800;

# Find the average score for each country considering only customers with a score not equal to 0 and return only those countries 
# with an average score greater than 430
select 
country, avg(score) 
from customers 
where score != 0 
group by country 
having avg(score)> 430;

  
-- ************************************************************************************************************************************--

-- 6. Distinct Command
-- remove duplicates
select distinct country from customers;

/*
1. From command will run and drive the data from database
2. select command will run to print the data
3. distinct will run and remove all duplicates than print the data
*/

-- ************************************************************************************************************************************--

-- 7. Top Command
-- when we want to print only top 3 rows or 2 rows, it will limit the or restrict the no of rows retured
-- Top(limit) present in SQL Server / MS Access
-- MYSQL doesn't support Top so we use limit clause at the end of query
select * from customers limit 3;

/*
1. From command will run and drive the data from database
2. select command will run to print the data
3. limit will run and only first 3 rows will print
*/

-- with offset
-- select * from customers limit offset, count
-- offset: The number of rows to skip (starting at 0).
-- count: The number of rows to return.

select * from customers order by score desc limit 1, 1;
select * from customers order by score desc limit 0, 3;

-- we can also use this method to find the second maximum salary of the employees

-- ************************************************************************************************************************************--

-- Execution Order
/*
select distinct column1, sum(column 2)
from table
where column = 10
group by column1
having sum(column2) > 30
order by column 1 desc
limit 1, 3;
*/

-- 1. From
-- 2. where 
-- 3. Group By
-- 4. Having
-- 5. Select
-- 6. order by
-- 7. limit

-- ************************************************************************************************************************************--

-- Static Data
-- when we want to give data from user not from database than we use static Data
-- static data will not save in database
select 123 as number;
select 'Hello' as regards;

select id, score, 'Very Good' as Grades from customers;
-- when we wann to give same static value to all the rows than we can use this with databse.

