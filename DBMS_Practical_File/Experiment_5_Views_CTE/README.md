# Experiment 5: Database Views and Common Table Expressions (CTEs)

## 📌 Aim & Objective
To create and manipulate **SQL Views** (read-only and updatable views with `WITH CHECK OPTION`) and write **Common Table Expressions (CTEs)** including non-recursive and recursive CTEs for hierarchical data processing.

---

## 💻 Concepts & SQL Implementations

### 1. Database Views (`CREATE VIEW`)
A **View** is a virtual table based on the result-set of an SQL statement. It simplifies complex queries, improves security by restricting column visibility, and enhances data abstraction.

#### Summary View
> **Task:** Create a view aggregating order statistics per customer.

```sql
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
```

---

### 2. Updatable View with `WITH CHECK OPTION`
The `WITH CHECK OPTION` clause prevents updates or inserts that do not satisfy the `WHERE` condition of the view definition.

```sql
CREATE OR REPLACE VIEW Premium_Products AS
SELECT productid, productname, price, brand, categoryid, sellerid
FROM Product
WHERE price >= 50.00
WITH CHECK OPTION;

-- Query the Updatable View
SELECT * FROM Premium_Products;

-- Update record through the view
UPDATE Premium_Products
SET price = 55.00
WHERE productid = 504;
```

---

### 3. Common Table Expressions (CTE)
A **CTE** (`WITH` clause) provides a temporary named result set that can be referenced within a `SELECT`, `INSERT`, `UPDATE`, or `DELETE` statement.

#### Single CTE Example
> **Task:** Find products whose prices are above their respective category average price.

```sql
WITH CategoryAvgPrice AS (
    SELECT categoryid, AVG(price) AS avg_category_price
    FROM Product
    GROUP BY categoryid
)
SELECT P.productid, P.productname, P.price, CAP.avg_category_price
FROM Product P
JOIN CategoryAvgPrice CAP ON P.categoryid = CAP.categoryid
WHERE P.price > CAP.avg_category_price;
```

---

#### Multiple Chained CTEs
> **Task:** Isolate high-value customers by chaining multiple CTE steps.

```sql
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
```

---

### 4. Recursive CTE (Organizational Hierarchy)
Recursive CTEs self-reference to query hierarchical data (such as manager-employee organization trees).

```sql
WITH RECURSIVE EmployeeHierarchy AS (
    -- Anchor member: Top-level managers
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
```

---

- **Executable SQL File:** [`queries.sql`](./queries.sql)
