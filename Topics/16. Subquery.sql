# SubQuery
# A query inside another query

# STEP1 JOIN TABLES  --> STEP2 FILTERING  -->  STEP3 TRANSFORMATION  -->  STEP4 AGGREGATION
# SUB QUERY     ------>  SUB QUERY       ------>  SUB QUERY		 ------>  MAIN QUERY 

# Subquery is categorised in different ways
/*

Result Types Subquery
1. Scalar Subquery ----> it returns only one single value
2. Row subquery   -----> it returns multiple rows
3. table subquery -----> it returns multiple rows and multiple columns


Categories based on realtion :-
1. Non-Correlated Subquery ----- subquery is independent from the query
2. Corelated Subquery   ------ subquery is depend on the query


Categories based on Location / Clauses
Select ---> 
From   ---> 
Join   ---> before joining table
Where  ---> to filter the data
	   ---> Comparison operator -->>  >, <, =, !=, >=, <=
       ---> Logical operator   -->>  IN, ANY, ALL, EXISTS

*/
-- ***************************************************************************************************************************************

# Result Types Subquery
# 1. Scalar Subquery ----> it returns only one single value