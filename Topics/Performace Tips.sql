# 30X Performace Tips

-- Golden Rule
# Always check the execution plan to confirm performance improvements when optimizing your query

# If there's no improvements then just focus on readability

-- Best Practices

-- Fetching Data

# Tip 1 : Select only what you need
select * from customers;  -- bad way

select CustomerID, First_Name from customers; -- good way

# Tip 2 : Avoid unnecessary Distinct & ORDER BY
select Distinct First_Name from customers
order by First_Name;  -- not always we have to choose this method

select First_Name from custoemrs; -- correct method


# Tip 3 : 