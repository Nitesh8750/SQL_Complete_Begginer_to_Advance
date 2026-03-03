# DDL - Data Definition Language

use data_with_baraa;

create table persons(
id int primary key,
name varchar(255) not null ,
birth_date date,
phone varchar(15) not null
);

describe persons;

-- ***********************************************************************************************************************************--

# ALTER Command
# alter command is use to change the structure of the table
alter table persons 
add email varchar(50) not null;

describe persons;

-- ***********************************************************************************************************************************--

# Remove the column from table

alter table persons drop phone;
describe persons;

-- ***********************************************************************************************************************************--
# Delete table

drop table persons;
