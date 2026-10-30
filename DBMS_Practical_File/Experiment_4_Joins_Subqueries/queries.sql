-- Experiment 4: SQL Relational Joins & Subqueries
-- Database System: Standard SQL / MySQL / PostgreSQL

-- =========================================================
-- 1. INNER JOIN - Customer Orders & Payment Summary
-- =========================================================
-- Retrieve customer details, order details, and payment modes.
SELECT C.customerid, C.customername, O.orderid, O.orderdate, P.paymentmode, P.amount
FROM Customer C
INNER JOIN Orders O ON C.customerid = O.customerid
INNER JOIN Payment P ON O.orderid = P.orderid;


-- =========================================================
-- 2. LEFT OUTER JOIN - Customers with or without Orders
-- =========================================================
-- Display all customers and their placed orders (including customers who haven't placed orders yet).
SELECT C.customerid, C.customername, C.email, O.orderid, O.totalamount
FROM Customer C
LEFT JOIN Orders O ON C.customerid = O.customerid;


-- =========================================================
-- 3. RIGHT OUTER JOIN / FULL OUTER JOIN - Products & Categories
-- =========================================================
-- Retrieve all products and all categories regardless of association.
SELECT P.productid, P.productname, C.categoryname
FROM Product P
RIGHT JOIN Category C ON P.categoryid = C.categoryid;


-- =========================================================
-- 4. SELF JOIN - Employee & Manager Hierarchy
-- =========================================================
-- Display each employee alongside their direct manager's name.
SELECT E.emp_id AS employee_id,
       E.emp_name AS employee_name,
       M.emp_name AS manager_name
FROM Employee E
LEFT JOIN Employee M ON E.manager_id = M.emp_id;


-- =========================================================
-- 5. SCALAR SUBQUERY - Above Average Salary
-- =========================================================
-- Find employees whose salary is higher than the overall company average salary.
SELECT emp_id, emp_name, salary
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee);


-- =========================================================
-- 6. MULTI-ROW SUBQUERY (IN Operator) - Products in Electronics or Footwear
-- =========================================================
-- List all products belonging to 'Electronics' or 'Footwear' categories using subquery.
SELECT productid, productname, price
FROM Product
WHERE categoryid IN (
    SELECT categoryid
    FROM Category
    WHERE categoryname IN ('Electronics', 'Footwear')
);


-- =========================================================
-- 7. CORRELATED SUBQUERY WITH EXISTS - Customers with High Value Orders
-- =========================================================
-- Retrieve customers who have placed at least one order exceeding 200.00.
SELECT C.customerid, C.customername, C.email
FROM Customer C
WHERE EXISTS (
    SELECT 1
    FROM Orders O
    WHERE O.customerid = C.customerid
      AND O.totalamount > 200.00
);


-- =========================================================
-- 8. COMPLEX MULTI-TABLE JOIN WITH AGGREGATION
-- =========================================================
-- Calculate total revenue generated per product category.
SELECT Cat.categoryname,
       COUNT(DISTINCT OI.orderid) AS orders_count,
       SUM(OI.quantity * OI.unit_price) AS total_revenue
FROM Category Cat
JOIN Product P ON Cat.categoryid = P.categoryid
JOIN Order_Item OI ON P.productid = OI.productid
GROUP BY Cat.categoryid, Cat.categoryname
ORDER BY total_revenue DESC;
