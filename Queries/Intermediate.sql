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
select * from intermediate where category = 'Furniture' order by price desc;

# Question 3
# 3. Find the total stock available across all products.
select sum(stock) from intermediate;

# Question 4
# 4. Show products whose names contain the word "Table."
select * from intermediate where product_name like '%Table%';
select * from intermediate where product_name like '% Table';
select * from intermediate where product_name like '%Table';

# Question 5
# 5. Calculate the average price for each category of products.
select category, avg(price) from intermediate group by category;


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
select category, count(*) as numberofproducts from intermediate group by category;


# Question 10
# 10. Retrieve the highest-priced product in each category.
select category, max(price) highest_price from intermediate group by category;


# Question 11
# 11. Display the table with the lowest stock quantity.
select * from intermediate order by stock asc limit 1;
select category, min(stock) from intermediate group by category limit 1;


# Question 12
# 12. List all unique categories and count the products in each.
select distinct category, count(*) from intermediate group by category;


# Question 13
# 13. Find products whose names start with 'C'.
select * from intermediate where product_name like 'c%';


# Question 14
# 14. Show all products, replacing null values in stock with 0.
select product_id, product_name, category, price, coalesce(stock, 0) as stock from intermediate;

# coalesce() buit-in-fuction which is used to handle the null values, as parameter we can give the values which we want to replace with 
# the Null values.


# Question 15
# 15. Update the stock of "Mobile Phone" by reducing it by 5.
update intermediate set stock = 30 where product_name = 'Mobile Phone';
update intermediate 
set stock = stock - 5 
where product_name = 'Mobile Phone';

select * from intermediate;


# Question 16
# 16. List the top 2 most expensive products in each category.
with cte_expensive as (
select *, row_number() over(partition by category order by price desc ) as pricerank from intermediate
)

select * from cte_expensive
where pricerank < 3;


# Question 17
# 17. Find products priced as a multiple of 5000.
select * from intermediate where price % 5000 = 0;


# Question 18
# 18. List products grouped by category and sorted by price.
select * from intermediate order by category and price;


# Question 19.
# 19. Retrieve the total number of Electronics items in stock.
select sum(stock) from intermediate where category = 'Electronics';


# Question 20
# 20. Show products with prices within 20% of the maximum price.
select * from
(select *, max(price) over() as max from intermediate) as max_price
where price <= max * 0.20;


# Question 21
# 21. Display products where the category starts with 'F' or 'A'.
select * from intermediate where category like 'f%' or 'a%';


# Question 22
# 22. Find categories with an average product price above 10000.
select category from intermediate group by category having avg(price) > 10000;


# Question 23
# 23. Update the price of all products by adding 10% as a seasonal discount.
update intermediate set price = price * 1.1;


# Question 24
# 24. Show products added to the table most recently.
select * from intermediate order by product_id desc limit 1;


# Question 25
# 25. Retrieve products with prices not divisible by 1000.
select * from intermediate where price % 1000 != 0;


# Question 26
# 26. Find the difference between the highest and lowest prices in each category.
select category, max(price) - min(price) as diff from intermediate group by category;



# Question 27
# 27. 27. List all products showing only the first 3 characters of each name.
select product_id, substr(product_name, 1, 3) from intermediate;


# Question 28
# 28. Retrieve products ordered by stock quantity, with Electronics first.
select * from intermediate where category = 'Electronics' order by stock;


# Question 29
# 29. Find the product with the second-lowest price.
select * from intermediate order by price  desc limit 1 offset 1;


# Question 30
# 30. Delete products with a stock count below 10.
select * from intermediate where stock < 10;


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

with cte_dep as (
	select *,
    round(avg(salary) over(partition by department), 2) as avg_sales from employees)

select * from cte_dep where salary > avg_sales;


select * , round(avg(salary) over(partition by department),2) avg_salary from employees;


select * from (select * , round(avg(salary) over(partition by department),2) avg_salary from employees) t
where salary > avg_salary;