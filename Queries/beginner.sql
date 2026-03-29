Create Database begineer;
drop database begineer;

Create database questions;

use questions;

create table begineer (
emp_id int primary key, 
emp_name varchar(255) not null, 
emp_department varchar(255) not null, 
emp_salary float(9,2) not null, 
emp_address varchar(255)
);

describe begineer;

show tables;
show table status;

insert into begineer values
(01, "Nitesh", "Data Analytics",25000.00,"Faridabad"),
(02, "Vinay","Data Analytics",30000.00, "Janakpuri"),
(03, "Ashish","Legal Advisor",35000.00,"Rewari"),
(04, "Ausaf Rehman", "Data Analytics",28000.00,default),
(05, "Satyam Chauhan", "Legal Advisor", 37000.50,"Noida");



# Question 1
# 1. Retrieve all columns from the Employees table.
select * from begineer;

# Question 2
# 2. Select only the Name and Salary of each employee.
select emp_name, emp_salary from begineer;


# Question 3
#3. Find employees who work in the DATA department.
select * from begineer where emp_department = 'Data Analytics';


# Question 4
# 4. Retrieve employees with a Salary greater than 25000.
select * from begineer where emp_salary > 25000;


# Question 5
# 5. Display employee names in alphabetical order.
select emp_name from begineer order by emp_name ASC;

# Question 6
# 6. Count the total number of employees in the Employees table.
select count(*) as Count_of_Employees from begineer;


# How to Alter Table 

alter table begineer add column joining_date varchar(255); 

update begineer set joining_date = '2020-01-10' where emp_id = 01;

update begineer 
set joining_date = case emp_id
when 02 then '2019-04-12'
when 03 then '2021-08-23'
when 04 then '2018-06-15'
when 05 then '2022-09-19'
END
where emp_id in (02,03,04,05);


# Question 7
# 7 Find employees who joined before 2021.
select * from begineer where joining_date < '2021-01-01';

# Question 8
# 8. Show distinct departments in the Employees table.
select distinct(emp_department) from begineer;
select distinct emp_department from begineer;


# Question 9
# 9. Retrieve the top 3 highest-paid employees.
select * from begineer order by emp_salary desc limit 3;


# Question 10
# 10. Calculate the average salary of employees.
select round(avg(emp_salary),2) from begineer;


# Question 11
# 11. List employees in the Legal department.
select * from begineer where emp_department = 'Legal Advisor';


# Question 12
# 12. Show employees whose names start with 'S'.
select emp_name from begineer where emp_name like 's%';


# Question 13
# 13. Find employees with a Salary between 30000 and 40000.
select * from begineer where emp_salary between 30000 and 40000;


# Question 14
# 14. Display employees who do not belong to the Legal department.
select * from begineer where emp_department != 'Legal Advisor';
select * from begineer where emp_department <> 'Legal Advisor';


# Question 15
# 15. Count employees in each department.
select emp_department, count(emp_department) from begineer group by emp_department;


# Question 16
# 16. Retrieve the minimum salary in the table.
select min(emp_salary) from begineer;


# Question 17
# 17. Show employees who joined in 2020 or later.
select * from begineer where joining_date >= '2020-01-01';


# Question 18
# 18. List employees ordered by Joining_Date in descending order.
select * from begineer order by joining_date desc;


# Question 19
# 19. Retrieve employees whose salary is not equal to 30000.
select * from begineer where emp_salary != 30000;
select * from begineer where emp_salary <> 30000;


# Question 20
# 20. Calculate the sum of all employees' salaries.
select sum(emp_salary) from begineer;


# Question 21
# 21. Find employees in the Data department earning more than 25000.
select * from begineer where emp_department = 'Data Analytics' and emp_salary > 25000;


# Question 22
# 22. Show the maximum salary in the Legal department.
select max(emp_salary) from begineer where emp_department = 'Legal Advisor';


# Question 23
# 23. List employees who joined in the month of September.
select * from begineer where joining_Date like '%09%';
select * from begineer where joining_Date like '____-09-%';


# Question 24
# 24. Display employee details by grouping them by department.
select emp_department, count(*) from begineer group by emp_department;
select emp_address, count(*) from begineer group by emp_address;


# Question 25
# 25. Retrieve the last 2 entries in the Employees table.
select * from begineer order by emp_id desc limit 2;


# Question 26
# 26. Select employees with names ending in 'h'.
select * from begineer where emp_name like '%h';


# Question 27
# 27. List employees with a salary that is a multiple of 5000.
select * from begineer where emp_salary % 5000 = 0;


# Question 28
# 28. Show the employee with the earliest Joining_Date.
select * from begineer order by joining_date Asc;


# Question 29
# 29. Update the salary of emp = 01 to 55000.
update begineer set  emp_salary = 55000 where emp_id = 01;
select * from begineer;


# Question 30
# 30. Delete an entry where the Department is 'HR'.
delete from begineer where emp_id = 05;
select * from begineer;
