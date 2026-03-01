show databases;

# 1. Show all Databases of MYSQL
use mysql;
show tables;
describe user;
select user from user;
select * from user;

-- ***********************************************************************************************************************************-- 
# 2. Create databse
create database if not exists mysir;
use mysir;
drop database mysir;
drop database if exists mysir;
 
-- ***********************************************************************************************************************************-- 

# 3. Create database mysir
create database mysir;
use mysir;
create table mysir1(
	empid	int,
    emp_name varchar(255),
    age 	int,
    department varchar(255),
    slary	float(9,2)
);

show tables;
describe mysir1;

-- ***********************************************************************************************************************************-- 

# 4. Some Manipulations in mysir1 table
alter table mysir1 modify column empid int not null;
describe mysir1;

insert into mysir1(empid,emp_name,department) values (01,'Nitesh','data');
select * from mysir1;

delete from mysir1 where empid = 1 limit 1;
select * from mysir1;

-- ***********************************************************************************************************************************-- 


# 5. Not Null Constraint
alter table mysir1 add constraint c1 check(department is not null);
insert into mysir1(empid,emp_name,slary) values (01,'Nitesh',36000);
insert into mysir1(empid,emp_name,department) values (01,'Nitesh','Data');
delete from mysir1 where empid = 1 limit 1;

alter table mysir1 add constraint c2 check(slary is not null);
insert into mysir1(empid,emp_name) values (01,'Nitesh');
insert into mysir1(empid,emp_name,department) values (01,'Nitesh','Data');
insert into mysir1(empid,emp_name,department,slary) values (01,'Nitesh','Data',36000);
select * from mysir1;
delete from mysir1 where empid = 1 limit 1;

#to drop the constaints in mysql 
alter table mysir1 drop constraint c2;
insert into mysir1(empid,emp_name,department) values (01,'Nitesh','Data');
select * from mysir1;
delete from mysir1 where empid = 1 limit 1;

-- ***********************************************************************************************************************************-- 

# 6. Unique Constraint
alter table mysir1 add unique(empid);
alter table mysir1 add constraint c3 unique(emp_name);

-- ***********************************************************************************************************************************-- 

# 7. Note important Stuff
# if we doesnot add constraints at the time of column creation, than we can add constraints late but
-- if we already put values in the column and those values are not according to constraints than it will give error --

insert into mysir1(empid, emp_name, age, department, slary) values (01, 'Nitesh',45,'data',44587);
select * from mysir1;
describe mysir1;
insert into mysir1(empid, emp_name, age, department, slary) values (01, 'Nitesh',45,'data',44587);
insert into mysir1(empid, emp_name, age, department, slary) values (02, 'kumar',45,'data',44587);
insert into mysir1(empid, age, department, slary) values (03,45,'data',44587);
insert into mysir1(empid, age, department, slary) values (04,45,'data',44587);

select * from mysir1;
# here we can see that emp_name is unique constraint but we can put NULL value or default values in this column, becuase null means nothing.

# to delete the values from table
delete from mysir1 where empid = 02;
delete from mysir1 where empid = 03;
delete from mysir1 where empid = 04;

# to insert the values in table
insert into mysir1 (empid, emp_name, age, department, slary)
values
(02,'Vinay',23,'data',38775),
(03,'Ashish',34,'Legal',30657),
(04,'Madhur',40,'Legal',40000),
(05,'Kamal',30,'data',50000);
select * from mysir1;

#to drop the constaints in mysql 
alter table mysir1 drop index c3;
describe mysir1;

# when we wants to delete NULL value from table 
-- delete from table_name where emp_id = NULL;
-- This will give error because NULL is not a value, it means nothing emptyness
# so we write
-- delete from table_name where emp_id is NULL;-- 

use mysir;
show tables;
describe mysir1;

-- ***********************************************************************************************************************************-- 


# 8. Primary Key and Foreign Key Constraint
create table mysir2(
project_id int,
project_name varchar(255) not null,
start_date date,
incharge int,
primary key(project_id),
constraint fk_mysir1_2 foreign key(incharge) references mysir1(empid)
);

-- to assign a key or constraint to the the columm 
-- constraint constraint_name then according to chnages

describe mysir2;

insert into mysir2 values
(101,'HDFC','2025-02-17',3),
(102,'Jana','2024-06-24',1),
(103,'Homecredit','2023-07-22',1);

#here incharge is a foreign key im mysir2 table, which is the primary key in mysir1 table

# we can put same foreign key value to muliple ids of different table 
# like here we put same foreign key in multiple project id bacause same employess can work on different projects 

select * from mysir2;
select * from mysir1;

insert into mysir1 (empid, emp_name, department, slary)
values(06,'Anubhav', 'Data',458698);

insert into mysir1 (empid, emp_name,age, department, slary)
values(07,'kunal', 20,'Data',458698);

select * from mysir1;

-- ***********************************************************************************************************************************-- 

# 9. Check Constraint
-- create table mysir_3(
-- emp_id int primary key,
-- emp_name varchar(255),
-- emp_age int,
-- emp_salary float(9,2),
-- constraint c4 check (age>=18),
-- check (age<60)
-- ); 

alter table mysir1 modify column age int check(age>=18);
#OR
#alter table mysir1 add constraint c5 check (age between 18 and 60);

describe mysir1;
# after put the check constraint into the table it doesnot show when i try to describe the table
# and check allow the null values that means if i fill Null value than it is not give error
# but when user put the wrong values according to conditions than it will give errors.

insert into mysir1 (empid, emp_name,age, department, slary)
values (08, 'Milan',15,'Legal',45476);
select * from mysir1;

# Note :- 
# TO find the constraint name when we does not put any name, 
# But system automatically generate a specific name for constraints if we dosn't givee name to constraint at the time of creation
SELECT CONSTRAINT_NAME
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'mysir1'
  AND CONSTRAINT_TYPE = 'CHECK';


#To drop the check constraint
alter table mysir1
drop check c1;

-- OR 
-- alter table mysir1
-- drop constraint c1;

-- ***********************************************************************************************************************************-- 


# 10. Default Constraint
# AT the time of inserting values in the table, if we doesn't insert any columns value than by default system will fill NULL value to that column, 
# But if we want to fill a default value(anything) that will automatically filled, if we not give value of any column than we use default constraint.

-- create table mysir4(
-- emp_id int primary key,
-- emp_name varchar(255) not null,
-- emp_age int,
-- emp_salary float(9,2)
-- Default 10000
-- );

alter table mysir1
alter slary set Default 10000;

insert into mysir1(empid, emp_name,age, department)
values (09,"Ausaf",40,"Data");
insert into mysir1(empid, emp_name,age, department)
values (10,"Ritik",25,"Data");

select * from mysir1;

# To drop the Default Constraint
alter table mysir1
alter slary drop default;

# Now if we drop default constraint from table and it will drop default constraint which we assign and 
# It also drop the by default NULL value 
# because it will drop all default value of that column

insert into mysir1(empid, emp_name,age, department)
values (11,"Numan",26,"Legal");
# it will give error becuase its defualts value is drop already
# IF we want NULL vale as default than we have to assign it again

alter table mysir1
alter slary set Default NULL;
# Now if the column is blank than NULL value will filled by default
insert into mysir1(empid, emp_name,age, department)
values (11,"Numan",26,"Legal");

-- ***********************************************************************************************************************************-- 

# 11. Alter table Command
alter table mysir1
modify column department enum("Legal","Data","HR","Finance");

describe mysir1;

alter table mysir1
rename column slary to salary;
describe mysir1;

# when we want to make changes in the structure of the table than we use DROP command
# when we want to make changes in the data or values of the table than we use DELETE command

-- ***********************************************************************************************************************************-- 

# 12. Select Constraint Commnad
select * from mysir1 where age>21 and age<60;

select * from mysir1 where age>30 or age<65;

select * from mysir1 where age != 30;
select * from mysir1 where age <> 30;

select * from mysir1 where salary between 20000 and 40000;

select * from mysir1 where emp_name like 'a%';
select * from mysir1 where emp_name like '%a';

select * from mysir1 where emp_name in ('Vinay','Kamal','Aditya');
#if any name from table is availble in the IN() function than print that name

select distinct emp_name from mysir1;
# this will print all unique names from the table

select distinct emp_name, age from mysir1;
# this will print all unique name and age combination from the table

select * from mysir1;

-- ***********************************************************************************************************************************-- 

# 13. Upate Command
# it is use to change the value of table
update mysir1 set age = 32, salary = 3685689 where empid = 11;
select * from mysir1;

# update query without where clause will make changes in all records of the table

update mysir1 set age = 30 where age = NULL;
# This query will run but doesnot make changes becuase condition is not correct

update mysir1 set age = 30 where age is NULL;
# This query will run and make changes according to the condition
# To Check NULL value as condition use "is" not "="

-- ***********************************************************************************************************************************-- 

# 14. Delete Command
# this command is use to remove or delete the records of the table without deleting the table



-- ***********************************************************************************************************************************-- 

# 15. order by Command
# This command is use when we want to see the table in a specific order
# The order by is used to sort the result set in ascending or descending order
# Ascending Order 
# Descending Order
# The order by is used to sort the result set in ascending or descending order
# By default ascending order

select * from mysir1 order by salary;
select * from mysir1 order by empid desc;
select * from mysir1 order by salary, age; 
# here order by apply on salary and age but priority is age, 
# if salary is same in 2 0r 3 records than order depends upon the age.

select * from mysir1 order by empid asc;

# select * from mysir1 order by salary asc where age>30;
# We have to write firstly Where clause than Order by clause

select * from mysir1 where age>30 order by salary asc;

-- ***********************************************************************************************************************************-- 

# 16. Aggregate Function
-- MIN()
-- MAX()
-- COUNT()
-- SUM()
-- AVG()


insert into mysir1(empid, emp_name, department, salary)
values(12, "Shweta","Legal",25000);
-- delete from mysir1 where empid = 12; 
select * from mysir1;

# aggregate function ignore NULL except COUNT()
select max(salary) as Mininmum_salary from mysir1;

select min(salary) as Maximum_Salary from mysir1;

select avg(age) as Average_age_of_employees from mysir1;

select sum(salary) as Sum_salary from mysir1;

select sum(salary) as last_name from mysir1 where emp_name like '%sh';	

select count(*) as No_of_employees from mysir1;

select count(age) as no_of_employees_without_null from mysir1;

# When we count the whole table than it will count null vlaues also.
# when we apply count() function on a specific column than it will ignore null values.

select count(*) as employees from mysir1 where age>30;

select count(*) as employees from mysir1 where salary>10000;
select count(age) as employees from mysir1 where salary>10000;

# To count the unique counts
select count(distinct emp_name) as unique_names from mysir1;


-- ***********************************************************************************************************************************-- 

# 17. Wild Cards
# %
# __
# Like is an operator used in where clause
# % some time, it means 0 or 1 charater

select * from mysir1 where emp_name like "S%d%";
# it means first letter is S and d can be second or middle letter and after d there are some letters.

select * from mysir1 where emp_name like "S__d%";
# here i write 2 "_" that means, it has must be 2 letters between S and d, and than d comes and after d there are some letterss

select * from mysir1 where emp_name like "Ad%";

select * from mysir1 where emp_name like "%hi%";
# there are some characters before hi and after hi

select * from mysir1 where emp_name like "_%a";

select * from mysir1 where emp_name like "_a%";

-- ***********************************************************************************************************************************-- 

# 18. Nested Query
# Nested queries are often used to perform complex queries by embeding one query within another query.
# The outer query can apply some conditions on the result of the inner query.

Create database mysir_nested_query;
use mysir_nested_query;

# Table 1
create table student_table(
rollno int primary key,
s_name varchar(255),
email varchar(255),
mobile varchar(15)
);

describe student_table;

insert into student_table (rollno,s_name,email,mobile)
values
(101,'Ritik','ritik439@gmail.com','4589640756'),
(102,'Madhur','madhur345@gmail.com','9054587468'),
(103,"Kamal",'kamal23@gmail.com','485648450823'),
(104,'Nitesh','nitesh87@gmail.com','8750993046'),
(105,'Vinay','vinay45@gmail.com','7234568901'),
(106,'Ausaf','rehman56@gmail.com','9998956343'),
(107,'Shweta','shweta56@gmail.com','9456782301'),
(108,'Harshita','Harshita67@gmail.com','7982347856')
;

select * from student_table;

# Table 2
create table course(
course_id int primary key,
course_name varchar(255),
duration_in_months int
);

describe course;

insert into course(course_id,Course_name,duration_in_months)
values
(01,"Data Science",6),
(02,"Web Developer",8),
(03,"SAAS Developer",3),
(04,"Cyber Security",12),
(05,"Python",3),
(06,"JAVA",3),
(07,"DSA",5);

select * from course;

# Table 3
create table batch(
batch_id int primary key,
course_id int,
start_date date,
batch_time time,
days varchar(20),
size int,
constraint fk_course_batch foreign key (course_id) references course(course_id)
);

describe batch;

insert into batch(batch_id,course_id,start_date,batch_time,days,size)
values
(101,01,'2026-01-01','09:00:00','MWF',100),
(102,02,'2026-01-01','10:00:00','MWF',100),
(103,03,'2026-02-01','11:00:00','TTS',150),
(104,04,'2026-02-01','11:00:00','TTS',150),
(105,05,'2025-12-01','12:00:00','MWF',200),
(106,07,'2025-12-01','12:00:00','MWF',200),
(107,01,'2026-03-01','09:00:00','TTS',300),
(108,06,'2026-03-01','10:00:00','TTS',300);

select * from batch;

# table 4
create table student_batch(
ID int primary key,
rollno int,
batch_id int,
joindate date,
foreign key (rollno) references student_table (rollno),
foreign key (batch_id) references batch (batch_id)
); 

describe student_batch;

insert into student_batch(ID,rollno,batch_id,joindate)
values
(01,101,101,'2026-01-01'),
(02,102,102,'2026-01-02'),
(03,103,103,'2026-02-02'),
(04,104,104,'2026-02-01'),
(05,105,101,'2026-01-02'),
(06,106,102,'2026-01-02'),
(07,107,107,'2026-03-01'),
(08,108,108,'2026-03-02');

select * from student_batch;

# 1. Independent Nested Query
# first inner query will execute than outer query will execute, result of inner query used to excute the outer query.

# 2. Co-related Nested Query
# in the query, both inner and outer query will execute at the same time, row-wise-row, that means like, inner query execute the 
# first row than outer query will execute that row when both queries executed the first row than they move to second row.


# 1. Independent Nested Query

# Populate names and emails id from student table where the roll no of student exists in student_batch table where the batch_id = 1
select s_name, email from student_table
where rollno in 
(select rollno from student_batch where batch_id = 101);


# 2. Co-related Nested Query
# select all the employees from mysir1 table where salaries are above the average salary of employees in the same department in a same table
use mysir;
select * from mysir1 where department="Data" and salary >
(select avg(salary) from mysir1 where department = "Data");
# This will print values From data department, Whose salary is greater than the Data department average

select * from mysir1 e1 where department = "Data" and salary >
(select avg(salary) from mysir1 e2
where e1.department = e2.department); 
# This will print values From data department, Whose salary is greater than the Data department average

select * from mysir1 e1 where salary >
(select avg(salary) from mysir1 e2
where e1.department = e2.department); 
# This will print values From the department, Whose salary is greater than the average salary of their department average

use mysir_nested_query;


-- ***********************************************************************************************************************************-- 

# 19. SQL JOINS

use mysir_nested_query;
select * from course;
select * from batch;

-- 1. Inner Joins (Joins)
-- Return records that have matching values in both tables
select * from batch
Inner join course on
batch.course_id = course.course_id;
# This will give all the common values of both table related to course_id in batch table and course table
# like batch_id mai jo course id hai, uske according hi course id se values fetch hui h 


-- 2. Left Join (Outer Join)
-- Return all the values from the left table and the matched records from the right table
select * from course 
Left join batch on
batch.course_id = course.course_id;
-- course.course_id = batch.course_id;


-- 3. Right Join (Outer)
-- Return all the values from the right table and the matched records from the left table

select * from course
right join batch on
batch.course_id = course.course_id;

# 4. Full Join 
# Return all records from the both
select * from course
full join batch on 
batch.course_id = course.course_id;


# 5 Self Join
select * from course t1, course t2;

select * from course t1, course t2 where t1.course_id<t2.course_id;


-- ***********************************************************************************************************************************-- 

# 20. SQL Union

# union is used to combine the result of multiple select statements.

# both table must have same columns names and types and in must in same order also.

# When we apply union, than it will remove the duplicate records, and give only distinct reecords.
# If we want duplicats values also than we use Union All function.

create database mysir_union;
use mysir_union;

create table teacher(
Id int primary key,
name varchar(255),
email varchar(255),
City varchar(50),
course varchar(50)
);

describe teacher;

insert into teacher(ID, name, email, city, course)
values
(101,'Ritik','ritik439@gmail.com','Faridabad','Web Development'),
(102,'Madhur','madhur345@gmail.com','Ajmer','Python'),
(103,"Kamal",'kamal23@gmail.com','Surat','Data Science'),
(104,'Nitesh','nitesh87@gmail.com','Patna','SAAS Developer'),
(105,'Vinay','vinay45@gmail.com','Chandigarh','Web Development');

select * from teacher;

create table student(
Id int primary key,
name varchar(255),
email varchar(255),
city varchar(50),
course varchar(50)
);

describe student;

insert into student(ID, name, email, city, course)
values
(101,'Ausaf','rehman56@gmail.com','Sheikhpura','Cyber Security'),
(102,'Shweta','shweta56@gmail.com','Nawada','Data Science'),
(103,'Harshita','Harshita67@gmail.com','Lakhisarai','Python'),
(104,'Nitesh','nitesh87@gmail.com','Patna','SAAS Developer'),
(105,'Vinay','vinay45@gmail.com','Chandigarh','Web Development');

select * from student;


#Union 
select * from teacher 
union
select * from student;

select * from teacher where course = 'Python'
union
select * from student where course = 'Python';

select course from teacher where course = 'Python'
union
select course from student where course = 'Python';

# Union ALL
select * from teacher 
union ALL
select * from student;

select * from teacher where course = 'Python'
union ALL
select * from student where course = 'Python';

select * from teacher where course = 'web development'
union ALL
select * from student where course = 'Python';

-- ***********************************************************************************************************************************-- 

# 21. Group BY


# Group by statement is used to group the result set by one or more column

-- select * from table
-- where condition
-- group by columns
-- order by columns;

# Group by generally uses aggregate function (sum, avg, count, min, max)

use mysir;

select * from mysir1;

# department wise employees count
select count(empid), department from mysir1 group by department; 

# Department wise salary expenses
select department, sum(salary) as total_expense from mysir1 group by department;

select department, sum(salary) as total_expense from mysir1 group by department order by department desc;

select department, sum(salary) as total_expense from mysir1 group by department order by department asc;
# here ascending means, first larger expenses than lower expenses. 


-- ***********************************************************************************************************************************-- 

# Note : - We cant use aggregate function with where clause

# 22. Having Clause 
# where clause doesnot support for aggregate function so we use Having function 
# having condition use after the grop by clause

-- select column_name from table_name
-- where conditions
-- Group by column_name
-- having condition 
-- order by column_names;


select department from mysir1 group by department having sum(salary)>100000;

select department, sum(salary) from mysir1 group by department having sum(salary) > 2000000;

-- Rules:-
-- we can not write select * from mysir1 group by department having sum(salary) > 2000000;
-- because it give error,
-- so we have to write the columns like this ,
-- jis column ka group by kr rhe hai usko likhte hai 
-- jis column pr aggregate function lgana ho wo column likhte hai ham log
