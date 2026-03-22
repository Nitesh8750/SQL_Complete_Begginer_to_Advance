# Stored Procedures
# A Stored Procedure is a prepared piece of SQL code that you save in your database so you can reuse it over and over again.

# Think of it like a "macro" or a "function" for your database.
# Instead of typing a long, complex query every time, you just "call" the procedure by its name.

# we can use this for smaller projects but for bigger projects use Python

/*
Syntax
Create Procedure procedureName ()
Begin
	select
    From
    where
END;

-- to run the procedure
CALL GetMonthlySales();
*/


-- Step 1 : Write a Query
-- For US customers Find the Total Number of Customers and the Average Score

select 
count(*) Total_Number_of_Customers,
avg(Score) Avg_score
from customers
where country = 'USA';

-- Step 2 : Turning the Query into a stored procedure

Delimiter //
create procedure GetCustomerSummary()
Begin
select 
count(*) Total_Number_of_Customers,
avg(Score) Avg_score
from customers
where country = 'USA';
END//
DELIMITER ;

-- Step 3. Execute the procedure
# Use the CALL command to execute procedure
CALL GetCustomerSummary();


# In MySQL, the ; normally tells the server, "Stop, the command is finished!" When you define a procedure, 
# MySQL sees the ; inside your code and tries to run the procedure before you've even finished typing the END keyword.
# To fix this, you must use the Delimiter Move.

# By using DELIMITER //, you successfully told MySQL to ignore the semicolons inside the BEGIN...END block 
# and treat the entire procedure as one single unit.


-- *************************************************************************************************************************************

# Parameter Procedure

# Parameters are variables you pass into or out of a stored procedure. 
# They allow your code to be dynamic—instead of writing a new procedure for every specific case, 
# you write one "template" that reacts to the data you give it.

# to avoid repetetion are giving parameters so that we imporve reusability

-- For German Customers Find the total number of customers and the average score

Delimiter //

create procedure germanyprocedure(in p_status varchar(50))
Begin
select Count(*) totalnumber,
avg(Score) avgscore
from customers
where country = p_status;
END//

Delimiter ;

CALL germanyprocedure('Germany');

CALL germanyprocedure('USA');

drop procedure germanyprocedure;

-- ***************************************************************************************************

# Types of procedures

# 1. IN Parameters (The Input)
# This is the most common type. It passes a value into the procedure. 
# The procedure can use it to filter data, but it cannot change the original value of the variable outside the procedure.

Delimiter //

create procedure IntypeProcedure(in p_status varchar(50))
Begin
select Count(*) totalnumber,
avg(Score) avgscore
from customers
where country = p_status;
END//

Delimiter ;

CALL IntypeProcedure('Germany');

CALL IntypeProcedure('USA');

drop procedure germanyprocedure;


-- ***************************************************************************************************

# 2. OUT Parameters (The Result)
# An OUT parameter is used to pass a value back to the caller. 
# You use this when you want the procedure to calculate a specific number (like a total or average) and "hand it over" 
# so you can use it in another query.


# For Single Parameter
Delimiter //

create procedure outtypeProcedure(out p_status decimal(10,2))
Begin
select 
sum(Score) totalscore into p_status
from customers;
-- where country = p_status;
END//

Delimiter ;
call outtypeProcedure(@my_total);
select @my_total;

# @my_total : is a variable which is used to store a value and by using select we print that variable
# here we store totalscore in variable @my_total and then print that variable


# For Multiple Parameter
Delimiter //

create procedure outtypeProceduremulti(
		out p_count int,
        out p_avg_score decimal(10,2),
		out p_total_Score decimal(10,2)
)
Begin
	select 
		Count(*),
        avg(Score),
        sum(Score) 
	INTO 
		p_count,
		p_avg_score,
		p_total_score
	from customers;
-- where country = p_status;
END//

Delimiter ;

call outtypeProceduremulti(@count, @Average, @Sum);
select @count as Count, @Average as Average, @Sum AS Sum;

drop procedure outtypeProcedure;

# The number of columns in your SELECT statement must exactly match the number of variables in your INTO statement.


-- ***************************************************************************************************

# 3. INOUT Parameters (The Combo)

# This acts as both an input and an output. You pass a value in, the procedure modifies it, and then passes the updated version back out.

DELIMITER //
CREATE PROCEDURE ApplyInflation(INOUT p_price DECIMAL(10,2))
BEGIN
    SET p_price = p_price * 1.05; -- Add 5%
END //
DELIMITER ;

-- Usage:
SET @current_price = 100.00;
CALL ApplyInflation(@current_price);
SELECT @current_price; -- Result is now 105.00


-- ***************************************************************************************************

# We can do IF-ELSE and Error Handling in Stored Procedure

# For IF - ELSE
/*
Syntax
IF (condition) THEN
    -- code to run if true
    BEGIN
        -- multiple statements go here
    END;
ELSE
    -- code to run if false
    BEGIN
        -- multiple statements go here
    END;
END IF;
*/

# Example
DELIMITER //

CREATE PROCEDURE ArchiveOrderCheck(IN p_order_id INT)
BEGIN
    DECLARE v_qty INT;

    -- Get the quantity of the order
    SELECT Quantity INTO v_qty FROM OrdersArchive WHERE OrderID = p_order_id;

    IF v_qty > 0 THEN
        -- If stock exists, print a success message
        SELECT 'Order is valid and processed' AS Status;
    ELSE
        -- If quantity is 0 or NULL
        BEGIN
            SELECT 'Error: Invalid Quantity' AS Status;
            -- You could also add a DELETE or UPDATE move here
        END;
    END IF;
END //

DELIMITER ;


# Adding "Else If" (Multiple Conditions)
/*
IF v_sales > 100 THEN
    SET v_category = 'High';
ELSEIF v_sales > 50 THEN
    SET v_category = 'Medium';
ELSE
    SET v_category = 'Low';
END IF;
*/


# For Error Handling
/*
Syntax
BEGIN TRY
	-- SQL Statements that might cause error
END TRY

BEGIN CATCH
	-- SQL statements to handle the error
END CATCH
*/

# 1. The "Continue" Handler (Log and Keep Going)
# Use this if you want to record an error but don't want the whole procedure to stop. 
# This is great for bulk inserts where one bad row shouldn't ruin the whole batch.
DELIMITER //

CREATE PROCEDURE ArchiveWithLog(IN p_id INT, IN p_sales DECIMAL(10,2))
BEGIN
    -- If a duplicate key (1062) happens, just set a flag and keep moving
    DECLARE duplicate_error INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR 1062 SET duplicate_error = 1;

    INSERT INTO OrdersArchive (OrderID, Sales) VALUES (p_id, p_sales);

    IF duplicate_error = 1 THEN
        SELECT CONCAT('Order ', p_id, ' was skipped (already exists).') AS Log;
    ELSE
        SELECT 'Success' AS Log;
    END IF;
END //

DELIMITER ;


# 2. The "Exit" Handler (Safe Stop)
# Use this if an error means the data is corrupted and the procedure must stop immediately to prevent further damage.
DELIMITER //

CREATE PROCEDURE CriticalUpdate(IN p_id INT, IN p_new_sales DECIMAL(10,2))
BEGIN
    -- If ANY generic SQL error happens, stop and roll back
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Critical Error: Transaction Rolled Back' AS Status;
    END;

    START TRANSACTION;
        UPDATE OrdersArchive SET Sales = p_new_sales WHERE OrderID = p_id;
        -- Imagine a complex second step here
    COMMIT;
END //

DELIMITER ;

# Common Error Codes to Handle
# 1062: Duplicate entry (Primary Key violation).
# 1048: Column cannot be null.
# 1216: Foreign key constraint fails.
# NOT FOUND: Usually used with Cursors when a SELECT returns no rows.


-- *************************************************************************************************************************************
/*
Why use Parameters?
Reusability: You write the logic once and use it for different IDs, dates, or statuses.
Security: You can prevent SQL Injection because parameters are handled separately from the query logic.
Efficiency: It reduces the amount of data sent between your application and the database server.
*/