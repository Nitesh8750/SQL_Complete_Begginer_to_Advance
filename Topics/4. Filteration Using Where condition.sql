# Filtering Data Using Where Conditions

/* 
Multiple operators :-

1. Comparison Operators     -      =, <> / != , > , >=, <, <=
2. Logical operators        -      AND, OR, NOT
3. Range operator           -      Between
4. Membership operator      -      IN , NOT IN
5. Search operator          -      LIKE

*/

-- **********************************************************************************************************************************--
use data_with_baraa;

# 1. Comparison Operator
# It use to compare two things

# = 
select * from customers where country = 'USA';

# != or <>
select * from customers where country <> 'USA';

# >
select * from customers where score > 500;

# >=
select * from customers where score >= 500;

# < 
select * from customers where score < 500;

# <=
select * from customers where score <= 500;


-- **********************************************************************************************************************************--

# 2. Logical Operators

# AND - all condition must be true
select * from customers where country = 'USA' and score > 500;

# OR - At least one condition must be true
select * from customers where country = 'USA' or score > 500;

# NOT - it will reverse the where condition
select * from customers where NOT country = 'USA';

-- **********************************************************************************************************************************--

# 3. Range operator

# Between - check if a value is within a range

select * from customers where score between 100 and 500;

select * from customers where score >= 100 and score <= 500;

# between include 100 and 500 in result
# boundaries are inclusive in between operator

-- **********************************************************************************************************************************--

# 4. Membership operator 

# IN - Check if a value exists in a list
# if we have to write multiple OR operator in a query, than we should use IN operator 

select * from customers where country in ('USA','India','UK');

# Retrieve all customers from either Germany or USA
select * from customers where country = 'Germany' or country = 'USA';
select * from customers where country in ('Germany', 'USA');


# NOT IN - check if a value not exists in a list
select * from customers where country NOT IN ('Germany', 'USA');


-- **********************************************************************************************************************************--

# 5. Search operator

# LIKE - search of a pattern in text
# Two special pattern are 
# % means Anything, which means no characters, 1 character, many characters 
# underscore ( "_" ) means exactly 1 character

# star with 'M'
select * from customers where first_name like 'm%';

# ends with 'n'
select * from customers where first_name like '%n';

# customers whose first_name contains 'r'
select * from customers where first_name like '%r%';

# all customers whose first_name has 'r' in the third positions
select * from customers where first_name like '__r%';