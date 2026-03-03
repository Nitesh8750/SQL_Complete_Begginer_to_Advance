# DML - Data Manipulation Language
# to manipuate or change the data of the table

use Data_with_Baraa;

# INSERT
INSERT INTO Customers (ID, First_name, Country, Score) VALUES
(6,'Anna','USA',NULL),
(7, 'Sam',NULL,100);

select * from customers;

-- ************************************************************************************************************************************--

# Question : Let assume we have two table 1st table has data and 2nd table is blank, now i want to move the data from one table to another ?
# Answer we write a query for 1st table and the result table of this query, we add to the 2nd table

# Copying data from 'customers' to 'persons'

describe customers;
describe persons;

insert into persons (id, name, birth_date,phone)
select id, first_name, NULL, 'Unknown' from customers;

select * from persons;

-- ************************************************************************************************************************************--

# Update Commnad
# where condition in which row you want to update, if we doesn't than it will change all rows

update customers set score = 0 where id = 6;

# update customer with score to 0 and country to UK where id = 7
update customers 
set score = 0, 
country = 'UK' 
where id = 7;

select * from customers;

# update all customers with a null score by setting their score to 0
update customers set score = 0  where score is NULL;


-- ************************************************************************************************************************************--

# Delete command
# to remove or delete the rows from table
# write where condition to delete a specific row

# delete all customers with an ID greater than 5
delete from customers where id > 5;

select * from customers;

# delete all data from table
truncate table customers; 

# truncate is use to delete all rows from the table at once
# truncate does not delete the structure of the table.