# Triggers

# Special Stored Procedure (set of statements) that automatically runs in response to a specific event on a table or view\

# Events means like Insert, Update and Delete the value in the table


# Type of Triggers
# 1. DML Triggers : Insert, Update, Delete
# 2. DDL Triggers : Create, Alter, Drop
# 3. LOGGON : 


# 1. DML Triggers : Insert, Update, Delete

# 1.1 After Triggers
# It will run after the execution of events

# 1.2 Before Triggers
# It will run before the execution of events

/*
Syntax
DELIMITER //

CREATE TRIGGER trigger_name
BEFORE/AFTER INSERT/UPDATE/DELETE
ON table_name FOR EACH ROW
BEGIN
    -- Your logic here
END //

DELIMITER ;
*/

# Triggers USE CASE

# 1. Logging

-- Create Table for Trigger
Create Table log_employee( 
LogId int primary key AUTO_INCREMENT,
employeeId int,
LogMessage varchar(255),
LogDate Date
);

-- Create Trigger
Delimiter //
Create trigger try_after_insert_employee
After Insert
on Employees For each row
Begin
	Insert into log_employee( employeeId, LogMessage, LogDate)
    values ( 
		New.EmployeeID,
        concat('New Employee Addedd=' , cast(EmployeeID as char)),
        CURDATE()
	);
END //

Delimiter ;


-- to delete the trigger
Drop trigger try_after_insert_employee;

-- to delete the table
drop table log_employee;


# NEW : the keyword NEW to refer to the row currently being added.

-- to execute the trigger operations
INSERT INTO Employees VALUES (6, 'John', 'Doe', 'HR','1988-01-12','F',80000, 3);

-- Check the log table to see the magic happen:
SELECT * FROM log_employee;

