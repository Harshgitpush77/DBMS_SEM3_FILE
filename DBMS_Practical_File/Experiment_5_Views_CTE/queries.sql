-- Experiment 5: Database Views & Common Table Expressions (CTEs)
-- Database System: Standard SQL / MySQL 8.0+ / PostgreSQL

-- =========================================================
-- 1. SIMPLE VIEW CREATION & QUERYING
-- =========================================================
-- Create a view summarizing customer order histories.
CREATE OR REPLACE VIEW Customer_Order_Summary AS
SELECT C.customerid,
       C.customername,
       C.email,
       COUNT(O.orderid) AS total_orders,
       COALESCE(SUM(O.totalamount), 0.00) AS total_spent
FROM Customer C
LEFT JOIN Orders O ON C.customerid = O.customerid
GROUP BY C.customerid, C.customername, C.email;

-- Querying the View
SELECT * FROM Customer_Order_Summary WHERE total_orders > 0;


-- =========================================================
-- 2. UPDATABLE VIEW WITH CHECK OPTION
-- =========================================================
-- View for high-priced products (price >= 50.00).
CREATE OR REPLACE VIEW Premium_Products AS
SELECT productid, productname, price, brand, categoryid, sellerid
FROM Product
WHERE price >= 50.00
WITH CHECK OPTION;

-- Query the Updatable View
SELECT * FROM Premium_Products;

-- Updating data through the view
UPDATE Premium_Products
SET price = 55.00
WHERE productid = 504;


-- =========================================================
-- 3. SIMPLE COMMON TABLE EXPRESSION (CTE)
-- =========================================================
-- CTE to calculate average product price per category and filter items above average.
WITH CategoryAvgPrice AS (
    SELECT categoryid, AVG(price) AS avg_category_price
    FROM Product
    GROUP BY categoryid
)
SELECT P.productid, P.productname, P.price, CAP.avg_category_price
FROM Product P
JOIN CategoryAvgPrice CAP ON P.categoryid = CAP.categoryid
WHERE P.price > CAP.avg_category_price;


-- =========================================================
-- 4. MULTIPLE CTES IN A SINGLE QUERY
-- =========================================================
-- Compute high value customers and order statistics in steps.
WITH CustomerStats AS (
    SELECT customerid, COUNT(orderid) AS order_cnt, SUM(totalamount) AS total_val
    FROM Orders
    GROUP BY customerid
),
HighSpenders AS (
    SELECT customerid, total_val
    FROM CustomerStats
    WHERE total_val >= 100.00
)
SELECT C.customerid, C.customername, C.email, HS.total_val
FROM Customer C
JOIN HighSpenders HS ON C.customerid = HS.customerid;


-- =========================================================
-- 5. RECURSIVE CTE - Management Organizational Hierarchy
-- =========================================================
-- Recursively traverse employee manager relationships to compute organizational levels.
WITH RECURSIVE EmployeeHierarchy AS (
    -- Anchor member: Top-level managers (manager_id IS NULL)
    SELECT emp_id, emp_name, manager_id, 1 AS org_level
    FROM Employee
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive member: Subordinates
    SELECT E.emp_id, E.emp_name, E.manager_id, EH.org_level + 1
    FROM Employee E
    INNER JOIN EmployeeHierarchy EH ON E.manager_id = EH.emp_id
)
SELECT emp_id, emp_name, manager_id, org_level
FROM EmployeeHierarchy
ORDER BY org_level, emp_id;
