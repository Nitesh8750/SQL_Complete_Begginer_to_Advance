# Index
# Data Structure provides quick access to data, optimizing the speed of your queries
# An Index in MySQL is a powerful tool used to speed up the retrieval of rows from a table. 
# Without an index, MySQL must perform a Full Table Scan (reading every single row) to find the data you want.

/*
Index Type
1. Structure
	1.1 Clustered Index
    1.2 Non-Clustered Index
2. Storage
	2.1 RowStore Index
    2.2 ColumnStore Index
3. Functions
	3.1 Unique Index
    3.2 Filtered Index

*/

# Note :- 
# Table is stored in database in Data files where values(data) are stored as Pages
# A Data File contains multiple Pages which store data in rows


# Page :- The smallest unit of data storage in a database (8kb)
# It can stores anything(Data, Metadata, Index, etc)
# type of Page
# 1. Data Page
# 2. Index Page
/*
		 _________________________________________________	0				-- Here 1 Is Data File ID
	|---|	Header 			1 : 150						  |  				-- 150 is Page Number which is unique
	|	|_________________________________________________|	96 bytes		-- Header has fixed size of 96 bytes		
	|	|				Row 1							  | 118 bytes		-- Row 1 from 96-118 bytes
	|	|					Row 2						  | 140 bytes		-- Row 2 from 118-140
	|	|						Row 3					  |
	8	|							.					  |
	kb	|							.					  |
	|	|							.					  |
	|	|_______________________________3_______2_____1___|
	|	|	Offset 					|  140	|  118	| 96  |  -- this is like a quick index of the rows, it tells where the specific rows begins
	|---|___________________________|_______|_______|_____|

# The whole page size is 8 kb

Heap Storage 
When tables are store wihout clusteres index 
when rows are stoed randomly not in a partcular order
in this type of table, we can easily insert new data , but we try to search any particular row than it will take extra time and some time
give error

In this case when user try to find any data, than sql will search every data page to find that row and searching all data pages till
it get that row this type of searching is called Table full scan

Full table Scan :- Scans the entire table page by page and row by row, search for data

Index page :- It stores key value(Pointers) to another index page or data page. It doesn't store the actual rows

		_________________________________________________				
		|				 1 : 200						 |  				
		|________________________________________________|		
		|				 1	is key						 | 
		|		200 is value (Points to data page		 | 

*/


# 1. Structure

# 1.1 Clustered Index
# in this type of index the data are stored in a orders from low value to high value in a data page like 1-20
# The data are stored like stored in decision tree 
# Firtly their is a root node then their are multiple Intermediate nodes to root node and 
# down their are many Leaf nodes to each intermediate nodes

# the acutal data pages are stored at Leaf level that means all data are stored at last level
