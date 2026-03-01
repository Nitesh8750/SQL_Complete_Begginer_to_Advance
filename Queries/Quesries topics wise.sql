use mysir;
show tables;

-- create table mysir1(
-- empid int primary key,
-- name varchar(255),
-- age varchar(255),
-- salary float(255)
-- );
select * from mysir1;

# Topic 1. Select

# Query 1
# select all rows and all columns of the employee tables
select * from mysir1;

# Query 2
# select all records of the employee table where age us less than 30

# Query 3
# select all records of the employeee table where salary rages between 18000 to 25000
select * from mysir1 where salary between 18000 and 25000;

# Query 4
# select all records of the employee table where name end with character 'h'
select * from mysir1 where emp_name like '%h';

# Query 5
# select all records of the employee table where name of the employee can be 'Vinay' or 'Ruchi' or 'Nitesh'

select * from mysir1 where emp_name in ('Vinay','Ruchi','Nitesh');

-- ***********************************************************************************************************************************-- 


# Topic 2. Update and Delete

# query 1
# update employee salary by 10% where employee age is above 38
update mysir1 set salary = (salary *10)/100 where age>38;
select * from mysir1;

# query 2
# update all the employee ages to 25 if it has a NULL value.
update mysir1 set age = 25 where age is NULL;

# query 3
# Delete all the records of employee table where age is below 18
delete from mysir1 where age < 18;

# query 4
# delete all employee records where salary ranges from 50000 to 60000.
delete from mysir1 where salary between 50000 and 60000;

# query 5
# update all the employees salary by 20% where name begins with letter 'S'
update mysir1 set salary = (salary * 20)/100 where emp_name like 's%';


-- ***********************************************************************************************************************************-- 

# Topic 3. Order by

# query 1
# Select all the employees from Employee table where age is in 20s and populate the records in ascending order of salaries
select * from mysir1 where age between 20 and 29 order by salary asc;

# query 2
# select all records of Employee table arranged in descending order of employee names.
select * from mysir1 order by emp_name desc;

# query 3
# select all employees from Employee table where age is above 25 years arranged in ascending order of names and if name collide
# (two same emp_name) then arrange in descending order of salaries.
select * from mysir1 where age > 25 order by emp_name,salary desc;

# query 4
# select only employee names and salaries arranged in ascending order of their ages
select emp_name,salary,age from mysir1 order by age;

# query 5
# select employee from employee table where second letter of employee names is 'a' and result arrnaged in descending order of the salaries
select * from mysir1 where emp_name like '_a%' order by salary desc;


-- ***********************************************************************************************************************************-- 

# Topic 4. Aggreagte Function

# query 1
# select min salary from the employee table
select min(salary) from mysir1;

# query 2
# select max age from the employee table
select max(age) from mysir1;

# query 3
# count the number of records in employee table
select count(*) from mysir1;

# query 4
# calculate the sum of salaries of all the employees
select sum(salary) from mysir1;

# query 5
# Calculate the average of salaries of all the employees whose age is not NULL and name contains 'ni'
select avg(salary),emp_name from mysir1 where age is not NULL and emp_name like '%ni%' group by emp_name;
select avg(salary) from mysir1 where age is not NULL and emp_name like '%ni%';


-- ***********************************************************************************************************************************-- 


# Topic 5.Wild Cards

# query 1
# select all employees records from the table where name contained 'sh'.
select * from mysir1 where emp_name like '%sh%';

# query 2
# select all employees records from the table where name end at 'sh'.
select * from mysir1 where emp_name like '%sh';

# query 3
# select all employees records from the table where name has exactly two letters before 'n'.
select * from mysir1 where emp_name like '__n&';

# query 4
# select all employees records from the table where name has exactly 5 letters.
select * from mysir1 where emp_name like '_____';
# 5 time '_' is used

# query 5
# select all employees records from the table where names having first letter either A or N
select * from mysir1 where emp_name like 'a%' or emp_name like 'n%';


-- ************************************************************************************************************************************-- 


# Topic 6. Nested Query

# query 1
# select all employees records from employees table where salary is greater than the average salary

select * from mysir1
where salary >
(select avg(salary) from mysir1);

# query 2
# find selected oldest employees record from employee table
select * from mysir1
where age = 
(select max(age) from mysir1);

# query 3
# find second lowest salary from table
select min(salary) as second_lowest_salry from mysir1 
where salary >
(select min(salary) from mysir1);

select * from mysir1;

# query 4
# Find all the employee records whose age is above average age and salary is below average salary of employees.
select * from mysir1 
where age> (select avg(age) from mysir1) and 
salary < (select avg(salary) from mysir1);

# query 5
# Find third maximum salary from the table
select max(salary) as third_highest_salry from mysir1
where salary <
(select max(salary) from mysir1 
where salary <
(select max(salary) from mysir1
)
);

-- Innermost → Finds highest salary
-- Middle → Finds second highest salary
-- Outer → Finds highest salary less than second highest → Third maximum

# Alternate Method 
select distinct salary as third_highest_salry
from mysir1 
order by salary desc 
limit 1 offset 2;

-- Sort salaries descending
-- Skip top 2
-- Take next one

-- ************************************************************************************************************************************-- 

# Topic 7. Joins
show databases;

use mysir_nested_query;
show tables;

# query 1
# find all the batch id which belongs to the course with the course_name 'Data Science';
select batch_id from batch
inner join course on
batch.course_id = course.course_id
where course_name = 'Data Science';

select * from course;
select * from batch;
select * from student_table;
select * from student_batch;


# query 2
# select rollno of students who are enrolled in the batches of course belongs to 'Data Science'
select rollno from student_batch
inner join batch on
student_batch.batch_id = batch.batch_id
inner join course on 
batch.course_id = course.course_id
where course_name = 'Data science';

# query 3
# populate the joining date of all the students with their rollno in the batches of 'Data Science'
select joindate,rollno from student_batch
inner join batch on
student_batch.batch_id = batch.batch_id
inner join course on 
batch.course_id = course.course_id
where course_name = 'Data Science';

# Query 4
# select student rollno, name, and join date of all the students enrolled in the 'Data Science' batch
select student_table.rollno, s_name, joindate from student_table
inner join student_batch on
student_table.rollno = student_batch.rollno
inner join batch on
student_batch.batch_id = batch.batch_id
inner join course on
batch.course_id = course.course_id
where course_name = 'Data Science';

# here both student_batch and student_table have same rollno column query can't undersatnd that from which table it print the rollno 
# so we use alias method as student_table.rollno

# Query 5
# select all the student names, batchid and course_name who have all taken admission in any of the batch 
select s_name, student_batch.batch_id, course_name from student_table
inner join student_batch on
student_table.rollno = student_batch.rollno
inner join batch on
student_batch.batch_id = batch.batch_id
inner join course on
batch.course_id = course.course_id;