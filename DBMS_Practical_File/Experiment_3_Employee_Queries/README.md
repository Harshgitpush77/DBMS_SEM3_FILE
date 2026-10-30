# Experiment 3: Data Retrieval Using Filtering, Aggregation & Built-in Functions

## 📌 Aim & Objective
To formulate SQL data retrieval queries demonstrating the use of `WHERE`, `ORDER BY`, aggregate functions (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`), grouping constructs (`GROUP BY`, `HAVING`), pattern matching (`LIKE`), `NULL` value handling, and built-in string and date functions.

---

## 🗄️ Database Schema

This experiment operates on the `Department` and `Employee` tables:

- **Department** (`dept_id` [PK], `dept_name`, `location`)
- **Employee** (`emp_id` [PK], `emp_name`, `email`, `salary`, `hire_date`, `dept_id` [FK], `manager_id` [FK])

---

## 💻 SQL Queries & Solutions

### Query 1: Salary Filtering & Sorting
> **Task:** Retrieve employees earning more than 70,000, sorted in descending order of salary.

```sql
SELECT emp_id, emp_name, salary, hire_date
FROM Employee
WHERE salary > 70000.00
ORDER BY salary DESC;
```

---

### Query 2: Department-wise Aggregation
> **Task:** Calculate employee count, average, minimum, and maximum salary per department.

```sql
SELECT dept_id,
       COUNT(emp_id) AS total_employees,
       ROUND(AVG(salary), 2) AS avg_salary,
       MAX(salary) AS max_salary,
       MIN(salary) AS min_salary
FROM Employee
GROUP BY dept_id;
```

---

### Query 3: Group Filtering with `HAVING`
> **Task:** Display departments where the average employee salary exceeds 70,000.

```sql
SELECT dept_id, ROUND(AVG(salary), 2) AS avg_salary
FROM Employee
GROUP BY dept_id
HAVING AVG(salary) > 70000.00;
```

---

### Query 4: Wildcard & Pattern Matching
> **Task:** Find employees whose names begin with 'A' or contain 'Singh'.

```sql
SELECT emp_id, emp_name, email
FROM Employee
WHERE emp_name LIKE 'A%' OR emp_name LIKE '%Singh%';
```

---

### Query 5: Date Filtering & Calculation
> **Task:** Find employees hired between 2020 and 2022 and compute their completed tenure.

```sql
SELECT emp_id, emp_name, hire_date,
       (2026 - EXTRACT(YEAR FROM hire_date)) AS years_completed
FROM Employee
WHERE hire_date BETWEEN '2020-01-01' AND '2022-12-31';
```

---

### Query 6: Handling NULL Values
> **Task:** Retrieve employees who report directly to top management (manager_id IS NULL).

```sql
SELECT emp_id, emp_name, salary, dept_id
FROM Employee
WHERE manager_id IS NULL;
```

---

### Query 7: String Manipulation Functions
> **Task:** Convert employee names to uppercase and extract the email domain name.

```sql
SELECT emp_name,
       UPPER(emp_name) AS upper_name,
       SUBSTRING(email FROM POSITION('@' IN email) + 1) AS email_domain
FROM Employee;
```

---

- **Executable SQL File:** [`queries.sql`](./queries.sql)
