---------------------------------------------------------------------
-- Microsoft SQL Server T-SQL Fundamentals
-- Chapter 02 - Single-Table Queries
-- Exercises
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

-- 1 
-- Return orders placed in June 2015
-- Tables involved: TSQLV4 database, Sales.Orders table
SELECT orderid, orderdate, custid, empid FROM Sales.Orders WHERE orderdate >= '2015-06-01' AND orderdate < '2015-07-01';

-- 2 
-- Return orders placed on the last day of the month
-- Tables involved: Sales.Orders table

SELECT orderid, orderdate, custid, empid FROM Sales.Orders WHERE orderdate = EOMONTH(orderdate);

-- 3 
-- Return employees with last name containing the letter 'e' twice or more
-- Tables involved: HR.Employees table

SELECT empid, firstname, lastname from HR.employees where lastname LIKE '%e%e%';

-- 4 
-- Return orders with total value(qty*unitprice) greater than 10000
-- sorted by total value
-- Tables involved: Sales.OrderDetails table
SELECT orderid, SUM(qty * unitprice) as totalvalue FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM(qty * unitprice) > 10000
ORDER BY totalvalue DESC;

-- 5
-- Write a query against the HR.Employees table that returns employees
-- with a last name that starts with a lower case letter.
-- Remember that the collation of the sample database
-- is case insensitive (Latin1_General_CI_AS).
-- For simplicity, you can assume that only English letters are used
-- in the employee last names.
-- Tables involved: Sales.OrderDetails table

SELECT empid, lastname FROM HR.Employees
WHERE lastname COLLATE Latin1_General_BIN LIKE '[a-z]%';

-- 6
-- Explain the difference between the following two queries

-- Query 1
SELECT empid, COUNT(*) AS numorders
FROM Sales.Orders
WHERE orderdate < '20160501'
GROUP BY empid;

-- Query 2
SELECT empid, COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY empid
HAVING MAX(orderdate) < '20160501';

-- difference is order in which they are ran. HAVING is run after the GROUP BY operation.

-- 7 
-- Return the three shipped-to countries with the highest average freight for orders placed in 2015
-- Tables involved: Sales.Orders table
SELECT TOP 3 shipcountry, AVG(freight) as avgfreight
FROM Sales.Orders
WHERE orderdate >= '2015-01-01' AND orderdate < '2016-01-01'
GROUP BY shipcountry
ORDER BY avgfreight DESC;

-- 8 
-- Calculate row numbers for orders
-- based on order date ordering (using order id as tiebreaker)
-- for each customer separately
-- Tables involved: Sales.Orders table
SELECT custid, orderdate, orderid, ROW_NUMBER() OVER(PARTITION BY custid
													 ORDER BY orderdate,orderid) AS rownum
FROM Sales.Orders
ORDER BY custid, orderid;

-- 9
-- Figure out and return for each employee the gender based on the title of courtesy
-- Ms., Mrs. - Female, Mr. - Male, Dr. - Unknown
-- Tables involved: HR.Employees table
SELECT empid, firstname, lastname, titleofcourtesy, 
	CASE
		WHEN titleofcourtesy = 'Ms.' or titleofcourtesy = 'Mrs.' THEN 'Female'
		WHEN titleofcourtesy = 'Mr.' THEN 'Male'
		ELSE 'Unknown'
	END AS gender
FROM HR.Employees;

-- 10
-- Return for each customer the customer ID and region
-- sort the rows in the output by region
-- having NULLs sort last (after non-NULL values)
-- Note that the default in T-SQL is that NULLs sort first
-- Tables involved: Sales.Customers table
SELECT custid, region 
FROM Sales.Customers
ORDER BY 
	CASE WHEN region IS NULL then 1 else 0 end ASC, region ASC;