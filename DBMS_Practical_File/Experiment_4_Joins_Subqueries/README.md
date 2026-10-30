# Experiment 4: SQL Joins and Nested Subqueries

## 📌 Aim & Objective
To implement multi-table operations using various SQL Join types (`INNER`, `LEFT OUTER`, `RIGHT OUTER`, `SELF JOIN`) and evaluate nested SQL Subqueries (Scalar, Multi-row with `IN`/`EXISTS`, and Correlated Subqueries).

---

## 💻 Queries and Solutions

### 1. INNER JOIN (Multiple Tables)
> **Task:** Combine Customer, Order, and Payment information for paid transactions.

```sql
SELECT C.customerid, C.customername, O.orderid, O.orderdate, P.paymentmode, P.amount
FROM Customer C
INNER JOIN Orders O ON C.customerid = O.customerid
INNER JOIN Payment P ON O.orderid = P.orderid;
```

---

### 2. LEFT OUTER JOIN
> **Task:** Display all registered customers alongside their orders (including customers without any orders).

```sql
SELECT C.customerid, C.customername, C.email, O.orderid, O.totalamount
FROM Customer C
LEFT JOIN Orders O ON C.customerid = O.customerid;
```

---

### 3. RIGHT OUTER JOIN
> **Task:** List all categories and matching products, preserving unmatched categories.

```sql
SELECT P.productid, P.productname, C.categoryname
FROM Product P
RIGHT JOIN Category C ON P.categoryid = C.categoryid;
```

---

### 4. SELF JOIN
> **Task:** Display employee names paired with their direct manager's name from the same Employee table.

```sql
SELECT E.emp_id AS employee_id,
       E.emp_name AS employee_name,
       M.emp_name AS manager_name
FROM Employee E
LEFT JOIN Employee M ON E.manager_id = M.emp_id;
```

---

### 5. SCALAR SUBQUERY
> **Task:** Find employees earning more than the overall average salary.

```sql
SELECT emp_id, emp_name, salary
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee);
```

---

### 6. MULTI-ROW SUBQUERY (`IN` Operator)
> **Task:** Retrieve products belonging to specific category names using a nested query.

```sql
SELECT productid, productname, price
FROM Product
WHERE categoryid IN (
    SELECT categoryid
    FROM Category
    WHERE categoryname IN ('Electronics', 'Footwear')
);
```

---

### 7. CORRELATED SUBQUERY (`EXISTS`)
> **Task:** Retrieve customers who have placed orders exceeding 200.00.

```sql
SELECT C.customerid, C.customername, C.email
FROM Customer C
WHERE EXISTS (
    SELECT 1
    FROM Orders O
    WHERE O.customerid = C.customerid
      AND O.totalamount > 200.00
);
```

---

### 8. MULTI-TABLE JOIN WITH AGGREGATION
> **Task:** Compute total revenue per category across orders.

```sql
SELECT Cat.categoryname,
       COUNT(DISTINCT OI.orderid) AS orders_count,
       SUM(OI.quantity * OI.unit_price) AS total_revenue
FROM Category Cat
JOIN Product P ON Cat.categoryid = P.categoryid
JOIN Order_Item OI ON P.productid = OI.productid
GROUP BY Cat.categoryid, Cat.categoryname
ORDER BY total_revenue DESC;
```

---

- **Executable SQL File:** [`queries.sql`](./queries.sql)
