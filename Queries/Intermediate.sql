use questions;

create table Intermediate(
product_id int primary key, 
product_name varchar(255) not null, 
category varchar(255) not null, 
price float(9,2) not null, 
stock int
);

show tables;

describe intermediate;

insert into Intermediate (product_id,product_name,category,price,stock) values
(101,'Laptop','Electronics',55000,15),
(102,'Mobile Phone','Electronics',30000,30),
(103,'Office Chair','Furniture',7000,10),
(104,'Coffee Maker','Appliances',4000,20),
(105,'Dining Table','Furniture',15000,5);

select * from intermediate;

# Question 1
# 1. Retrieve all products priced above the average price.
select * from intermediate where price > (select avg(price) from intermediate);

# Question 2
# 2. Display products in the Furniture category, ordered by price descending.
select * from intermediate where category = 'Furniture'  Order by price Desc;

# Question 3
# 3. Find the total stock available across all products.
select sum(stock) from intermediate;

# Question 4
# 4. Show products whose names contain the word "Table."
select * from intermediate where product_name like '% Table';
select * from intermediate where product_name like '%Table';
select * from intermediate where product_name like '%Table%';

# Question 5
# 5. Calculate the average price for each category of products.
select category, round(avg(price),2) from intermediate group by category;


# Question 6
# 6. List products with stock levels between 10 and 25.
select * from intermediate where stock between 10 and 25;


# Question 7
# 7. Retrieve products with a price above 10000 and stock greater than 10.
select * from intermediate where price > 10000 and stock > 10;


# Question 8
# 8. Show categories with more than one product.
select category from intermediate group by category having count(*) > 1;


# Question 9
# 9. Count the number of products in each category.
select category, count(*) from intermediate group by category;


# Question 10
# 10. Retrieve the highest-priced product in each category.
select category, max(price) from intermediate group by category;



# Question 11
# 11. Display the table with the lowest stock quantity.
-- select category, min(stock) from intermediate group by category;
select * from intermediate order by stock asc;
select * from intermediate order by stock asc limit 1;


# Question 12
# 12. List all unique categories and count the products in each.
select category,count(product_name) from intermediate group by category;


# Question 13
# 13. Find products whose names start with 'C'.
select product_name from intermediate where product_name like 'c%';


# Question 14
# 14. Show all products, replacing null values in stock with 0.
select product_id, product_name, category, price, coalesce(stock, 0) as stock from intermediate;

# coalesce() buit-in-fuction which is used to handle the null values, as parameter we can give the values which we want to replace with 
# the Null values.


# Question 15
# 15. Update the stock of "Mobile Phone" by reducing it by 5.
update intermediate set stock = 5 WHERE product_name = 'Mobile Phone' limit 1;
select product_name,stock from intermediate;


# Question 16
# 16. Find products priced as a multiple of 5000.
select * from intermediate where price % 5000 = 0;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary DECIMAL(10,2)
);


INSERT INTO employees (emp_id, emp_name, department, salary) VALUES
(1, 'Amit', 'IT', 60000),
(2, 'Neha', 'IT', 50000),
(3, 'Rahul', 'IT', 70000),
(4, 'Priya', 'HR', 40000),
(5, 'Karan', 'HR', 45000),
(6, 'Anjali', 'Finance', 80000),
(7, 'Rohan', 'Finance', 75000);


# Write a query to compare each employee’s salary with the department average salary.
with cte as(
select * ,round(avg(salary) over (partition by department order by department),2) as avg_dp from employees)

select * from cte
where salary > avg_dp;


