# Functions Basics

/*
SQL Functions
A built in Sql code :
- accept an input value
- process it 
- returns an output value

Types of functions:-
- Single-Row Functions  
		Maria -> Lower() -> maria
- Multi-Row Functions
		30 ->
        10 ->   sum () ----> 100
        20 ->
        40 ->

# Nested Functions
Function used inside another functions

'Maria' -> LEFT(2) -> 'Ma' -> Lower() -> 'ma'
len(Lower(left('Maria',2)))

# Types 
1. Single-Row Functions
	- String Functions
    - Numeric Functions
    - Data and Time Functions
	- NULL Functions
    
2. Multi-Row Functions
	- Aggregate Functions
    - Window Functions
*/

-- *************************************************************************************************************************************--
# 1. Single-Row Functions

# String Functions
/*
1. Manipulation
	- Concat
    - Upper
    - Lower
    - Trim
    - Replace
2. Calculation
	- Length()
3. String Extraction
	- Left
    - Right
    - Substring
*/

# 1. Manipulation

# Concat
# Combine multiple strings to one

use data_with_baraa;
select * from employees;

# Concatenate firstname and Lastname into one column
select concat(FirstName," ",LastName) as Full_name from employees;


# Upper & Lower
# Upper - converts all characters to upper case
# Lower - converts all characters to lower case 

select upper(FirstName) as Upper from employees;
select lower(FirstName) as Lower from employees;

# TRIM
# Remove leading and Trailing spaces
# "__John" is leading space
# "John__" is trailing space
# "__John__"
# "John_____"

# Find custoemrs whose first name contains leading or trailing spaces
select FirstName from employees
where FirstName != Trim(FirstName);

select Trim(FirstName) from employees;


# Replace
# Replace a specific character with a new character

select 
'123-456-789'as phone,
replace('123-456-789','-','/') as clean_phone,
replace('123-456-789','-',' ') as clean_phone;

select 
'report.txt',
replace('report.txt','txt','csv');



# 2. Calculation
# LENGTH
# count the lenth of character

select FirstName,length(FirstName) as Lenth from employees;
select length('Nitesh');



# 3. String Extraction

# Left - extract specific value from the left
# Right - extract specific value from the right

select left(FirstName,3) as Left_name from employees;
select right(FirstName,3) as Right_name from employees;
select  FirstName,left(FirstName,3) as Left_name, right(FirstName,3) as Right_name from employees;


# Substring
# Extract a part of string at a specified position
# Substring(value, start_position,No_of_character_from_start_position)

select FirstName,substring(FirstName, 2, 5) from employees; 

-- *************************************************************************************************************************************--


# 2. Numeric Functions

# Round
select 3.516,round(3.516,2) as round_2;
select 3.516,round(3.516,1) as round_1;
select 3.516,round(3.516,0) as round_0;

select 3.516,round(3.516,2) as round_2, round(3.516,1) as round_1, round(3.516,0) as round_0;


# ABS
# return the absolute(positive) value of a number, removing any negative sign

select -10, abs(-10) as abs;
select 10, abs(10) as abs;


