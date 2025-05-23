-- Inner self join. Joinning a table to itself.

SELECT t1.lastName,t1.email,t1.jobTitle,t1.reportsTo
FROM employees as t1
LEFT JOIN employees as t2
   USING(reportsTo)
   ORDER BY 
   
-- Merging the two tables or adding new columns to the table
SELECT jobTitle,officecode, 'Senior office' AS 'office lable'
FROM employees
WHERE officeCode = 1
UNION
SELECT jobTitle,officecode, 'Middle office' AS 'office lable'
FROM employees
WHERE officeCode = 2;

-- Copying data from one table to another
CREATE TABLE order_archives AS
SELECT * 
FROM orders
WHERE orderDate< current_date()
