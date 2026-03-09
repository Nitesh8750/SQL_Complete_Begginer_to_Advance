# Date and Time Function

use data_with_baraa;

CREATE TABLE orders_sales (
    OrderID INT PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    SalesPersonID INT,
    OrderDate DATE,
    ShipDate DATE,
    OrderStatus VARCHAR(50),
    ShipAddress VARCHAR(255),
    BillAddress VARCHAR(255),
    Quantity INT,
    Sales DECIMAL(10, 2),
    CreationTime datetime
);

INSERT INTO orders_sales (OrderID, ProductID, CustomerID, SalesPersonID, OrderDate, ShipDate, OrderStatus, ShipAddress, BillAddress, Quantity, Sales, CreationTime)
VALUES
(1, 101, 2, 3, '2025-01-01', '2025-01-05', 'Delivered', '9833 Mt. Dias Blv.', '1226 Shoe St.', 1, 10, '2025-01-01 12:34:56'),
(2, 102, 3, 3, '2025-01-05', '2025-01-10', 'Shipped', '250 Race Court', NULL, 1, 15, '2025-01-05 23:22:04'),
(3, 101, 1, 5, '2025-01-10', '2025-01-20', 'Delivered', '8157 W. Book', '8157 W. Book', 2, 20, '2025-01-10 18:24:08'),
(4, 105, 1, 3, '2025-01-20', '2025-01-25', 'Shipped', '5724 Victory Lane', NULL, 2, 60, '2025-01-20 05:50:33'),
(5, 104, 2, 5, '2025-02-01', '2025-02-05', 'Delivered', NULL, NULL, 1, 25, '2025-02-01 14:02:41'),
(6, 104, 3, 5, '2025-02-05', '2025-02-10', 'Delivered', '1792 Belmont Rd.', NULL, 2, 50, '2025-02-05 15:34:57'),
(7, 102, 1, 1, '2025-02-15', '2025-02-27', 'Delivered', '136 Balboa Court', NULL, 2, 30, '2025-02-15 06:22:01'),
(8, 101, 4, 3, '2025-02-18', '2025-02-27', 'Shipped', '2947 Vine Lane', '4311 Clay Rd', 3, 90, '2025-02-18 10:45:22'),
(9, 101, 2, 3, '2025-03-10', '2025-03-15', 'Shipped', '3768 Door Way', NULL, 2, 20, '2025-03-10 12:59:04'),
(10, 102, 3, 5, '2025-03-15', '2025-03-20', 'Shipped', NULL, NULL, 0, 60, '2025-03-15 23:25:15');

select * from orders_sales;

select OrderID, OrderDate, ShipDate, CreationTime from orders_sales;

# GETDATE()
# returns the current date and time at the moment when the query is executed.
select OrderID,
CreationTime,
'2025-10-26' hardcoded,
now() today,
sysdate(),
current_timestamp(),
current_date(),
curdate(),
current_time(),
curtime()
from orders_sales;

/*
now(), sysdate(), current_timestamp()
Returns the current date and time
sysdate, it returns the exact time at which it executes. In a long-running query, 
NOW() stays the same for every row, but SYSDATE() can change as the seconds tick by.

current_date(),curdate()
Returns the current date.

current_time(),curtime()
Returns the current time.

*/


# 1. Part Extraction
# DAY()
# return the day from a date

# MONTH()
# return the month from a date

# YEAR()
# return the year of the date

# Day
# Data type id INT
select OrderID,
CreationTime,
day(CreationTime),
dayname(CreationTime),
dayofmonth(CreationTime) ,
dayofweek(CreationTime),
dayofyear(CreationTime)
from orders_sales;


# Month
# Data type id INT
select OrderID,
CreationTime,
month(CreationTime),
monthname(CreationTime)
from orders_sales;


# YEAR
# Data type id INT
select OrderID,
CreationTime,
year(CreationTime),
yearweek(CreationTime) -- return both the year and the week number 202501 means 2025 year and 01 week
from orders_sales;


# Extract
# return a specific part of a date as a number
# Extract(part from column)
# Data type id INT

select OrderID,
CreationTime,
extract(year from creationtime) as Year,
extract(MONTH from creationtime)as Month,
extract(DAY from creationtime) as DAY,
extract(HOUR from creationtime)as HOUR,
extract(Minute from creationtime) as Minute,
extract(second from creationtime) as Second,
extract(week from creationtime) as Week,
quarter(creationtime),
WEEKDAY(creationtime),  -- 0 = MON and 1 = SUN
DAYOFWEEK(creationtime) 
from orders_sales;


# MONTHNAME() , DAYNAME()
# Data type is String

select OrderID,
CreationTime,
monthname(creationtime), -- returns the string name
dayname(creationtime)
from orders_sales;


# DATEFORMAT()
# Data type of DATETIME

# DATE_FORMAT(date, format_mask)
/*
Year
%Y: 4-digit year (e.g., 2025)
%y: 2-digit year (e.g., 25)

Month
%M: Full month name (January...December)
%b: Abbreviated month name (Jan...Dec)
%m: Month as a numeric value, padded with zeros (e.g., 01 ... 12)
%c: Month as a numeric value, NO padding (e.g., 1 ... 12)

Day Specifiers
%W: Full weekday name (Sunday...Saturday)
%a: Abbreviated weekday name (Sun...Sat)
%d: Day of the month as a numeric value, padded (e.g., 01 ... 31)
%e: Day of the month as a numeric value, NO padding (e.g., 1 ... 31)
%D: Day of the month with English suffix (e.g., 1st, 2nd, 3rd)

Time Specifiers
%H: Hour in 24-hour format, padded (00 ... 23)
%k: Hour in 24-hour format, NO padding (0 ... 23)
%h or %I: Hour in 12-hour format, padded (01 ... 12)
%l: Hour in 12-hour format, NO padding (1 ... 12)
%i: Minutes, padded (00 ... 59)
%s or %S: Seconds, padded (00 ... 59)
milisecond : ms
microsecond : msc
nanosecond : ns
%p: AM or PM (e.g., AM or PM)
%r: Full time in 12-hour format (e.g., 11:25:15 PM)
%T: Full time in 24-hour format (e.g., 23:25:15)
*/

select OrderID,
CreationTime,
DATE_FORMAT(CreationTime, '%Y') as Year,
DATE_FORMAT(CreationTime, '%M') as Month,
DATE_FORMAT(CreationTime, '%W') AS Weekday,
DATE_FORMAT(CreationTime, '%H') as Hour,
DATE_FORMAT(CreationTime, '%l') as hour,
DATE_FORMAT(CreationTime, '%i') as Minute,
DATE_FORMAT(CreationTime, '%s') as Second,
DATE_FORMAT(CreationTime, '%r') as Fulltime
from orders_sales;


# EOMONTH()
# "End of Month." It finds the last day of the month for a given date (very useful for leap years or months with 30 vs 31 days).
# this function is not available in MYSQL so we use 
# LAST_DAY(date)
# data type is Date
select OrderID,
CreationTime,
last_day(creationtime),
day(last_day(creationtime))
from orders_sales;

-- ***********************************************************************************************************************************

# Question : How many orders placed earch year
select * from orders_sales;
select sum(quantity) from orders_sales;
select count(quantity) from orders_sales;

select year(creationtime) as year, count(Quantity)
from orders_sales group by year;

# Question : How many orders placed earch year
select monthname(creationtime) as month, count(Quantity)
from orders_sales group by month;

# Question : Show all orders that were placed during the month of february

select * from 
orders_sales where monthname(creationtime) = 'february';

select * from 
orders_sales where month(creationtime) = 2;

-- ***********************************************************************************************************************************

# 2. Format & Casting


/* Important
2025 - 08 - 20  18 : 55 : 45
%Y   - %m - %d  %H : %i : %s  ------>>>> Format Specifier

this is called Data & Time Format
this is case sensitive

International Standard (ISO 8601) 
2025-03-15
%Y-%m-%d

USA Standard
03/15/2025
%m/%d/%Y

European Standard / India
15/03/2025
%d/%m/%Y
*/

# Formatting
# Changing the format if a value from ane to another
# changing how the data looks like
# fORMAT is use for adding commas (thousands separators) and rounding decimals.
# SELECT FORMAT(15000.789, 2); 
-- Result: '15,000.79'

# In SQL We use DATE_FORMAT for DATE manipulation

# DATE_FORMAT(date, format_mask)

/*

Rules : - 

Year
%Y: 4-digit year (e.g., 2025)
%y: 2-digit year (e.g., 25)

Month
%M: Full month name (January...December)
%b: Abbreviated month name (Jan...Dec)
%m: Month as a numeric value, padded with zeros (e.g., 01 ... 12)
%c: Month as a numeric value, NO padding (e.g., 1 ... 12)

Day Specifiers
%W: Full weekday name (Sunday...Saturday)
%a: Abbreviated weekday name (Sun...Sat)
%d: Day of the month as a numeric value, padded (e.g., 01 ... 31)
%e: Day of the month as a numeric value, NO padding (e.g., 1 ... 31)
%D: Day of the month with English suffix (e.g., 1st, 2nd, 3rd)

Time Specifiers
%H: Hour in 24-hour format, padded (00 ... 23)
%k: Hour in 24-hour format, NO padding (0 ... 23)
%h or %I: Hour in 12-hour format, padded (01 ... 12)
%l: Hour in 12-hour format, NO padding (1 ... 12)
%i: Minutes, padded (00 ... 59)
%s or %S: Seconds, padded (00 ... 59)
milisecond : ms
microsecond : msc
nanosecond : ns
%p: AM or PM (e.g., AM or PM)
%r: Full time in 12-hour format (e.g., 11:25:15 PM)
%T: Full time in 24-hour format (e.g., 23:25:15)
*/

select OrderID,
CreationTime,
DATE_FORMAT(CreationTime, '%Y') as Year,
DATE_FORMAT(CreationTime, '%M') as Month,
DATE_FORMAT(CreationTime, '%W') AS Weekday,
DATE_FORMAT(CreationTime, '%H') as Hour,
DATE_FORMAT(CreationTime, '%l') as hour,
DATE_FORMAT(CreationTime, '%i') as Minute,
DATE_FORMAT(CreationTime, '%s') as Second,
DATE_FORMAT(CreationTime, '%r') as Fulltime
from orders_sales;

Select OrderID,
CreationTime,
date_format(CreationTime, '%Y-%m-%d'),
date_format(CreationTime, '%d-%M-%y')
from orders_sales;

# Question : Show creationtime using the following format:-
# Day WED JAN Q1 2025 12:34:56 PM

Select OrderID,
CreationTime,
concat('Day ' , 
date_format(CreationTime, '%a ' '%b '),
'Q', quarter(CreationTIme)," ",
date_format(CreationTime, '%Y ' '%H:' '%i:' '%s ' '%p ')) as customformat
from orders_sales;




# Casting
# change data type
# '123' - 123
# date 2025-08-10 - '2025-08-10' str
# string '2025-08-10' - 2025-08-10
# CAST(expression AS data_type)

# CONVERT
# CAST
# CAST() and CONVERT() are twins. They do almost exactly the same job: taking a value of one data type and turning it into another 
# (e.g., turning a String into an Integer).

/*
Goal								Using CAST()												Using CONVERT()
String to Date						CAST('2026-03-09' AS DATE)									CONVERT('2026-03-09', DATE)
Price to Decimal					CAST(Sales AS DECIMAL(10,2))								CONVERT(Sales, DECIMAL(10,2))
Number to String					CAST(101 AS CHAR)											CONVERT(101, CHAR)
*/


select 
CONVERT('2026-03-09', DATE) as strtodate,
convert(CreationTime, date) as datetimetodate
from orders_Sales;

select 
Cast('2026-03-09' as  DATE) as strtodate,
Cast('2026-03-09' as  DATETIME) as strtodate,
cast(CreationTime as date) as datetimetodate
from orders_Sales;


-- ***********************************************************************************************************************************

# 3. Date & Time Calculations

# DATE_ADD()
# adds or subtracts a specific time interval to/from a table
# DATE_ADD(date, INTERVAL value unit)

select OrderID,
CreationTime,
date_add(CreationTime, INTERVAL 2 YEAR) add_year
FROM orders_sales;

SELECT 
    OrderID,
    CreationTime,
    -- ADDING TIME
    DATE_ADD(CreationTime, INTERVAL 2 YEAR) AS add_year,
    DATE_ADD(CreationTime, INTERVAL 1 QUARTER) AS add_quarter,
    DATE_ADD(CreationTime, INTERVAL 3 MONTH) AS add_month,
    DATE_ADD(CreationTime, INTERVAL 1 WEEK) AS add_week,
    DATE_ADD(CreationTime, INTERVAL 5 DAY) AS add_day,
    
    -- SUBTRACTING TIME (Using negative numbers)
    DATE_ADD(CreationTime, INTERVAL -1 HOUR) AS sub_hour,
    DATE_ADD(CreationTime, INTERVAL -30 MINUTE) AS sub_minute,
    DATE_ADD(CreationTime, INTERVAL -10 SECOND) AS sub_second
FROM orders_sales;

# date_sub() can be used to subtract a specific time interval to/from a table


# DATEDIFF()
# is used to calculate the number of days between two date values.
# Unlike the SQL Server version (which requires you to specify if you want days, months, or years), 
# the MySQL version only returns the number of days.
# DATEDIFF(date1, date2)

# Find Ship and order Duration
SELECT 
    OrderID,
    CreationTime,
    ShipDate,
    DATEDIFF(ShipDate, CreationTime) AS DaysToShip
FROM orders_sales;


# Question : Find the average shipping duration in days for each month
select 
monthname(CreationTime) as Month,
floor(avg(datediff(ShipDate, CreationTime))) as Daystoship
from orders_sales
group by monthname(CreationTime) ;

# Question : Find the number of days between each order and previous order
select * from orders_sales;

select  OrderID,
    OrderDate Currentdate,
    lag(OrderDate) over (order by OrderDate) as Previousorderdate,
    datediff(OrderDate,lag(OrderDate) over (order by OrderDate)) as days
from orders_sales;


select * from employees;

# Question : Calculate the age of employee
select EmployeeID, BirthDate,
floor(datediff(curdate(), BirthDate)/365.25)
from employees;

select EmployeeID, BirthDate,
timestampdiff(year, BirthDate, curdate()) as AGE
from employees;

# TIMESTAMPDIFF 
# This is the most accurate way because it handles leap years correctly and allows you to specify that you want the result in YEARS.

-- ***********************************************************************************************************************************
