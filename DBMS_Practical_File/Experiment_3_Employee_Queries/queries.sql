-- Experiment 3: Advanced SQL Queries (Filtering, Aggregation, Grouping & String/Date Functions)
-- Database System: Standard SQL / MySQL / PostgreSQL

-- =========================================================
-- 1. SETUP EMPLOYEE & DEPARTMENT SCHEMA FOR LAB EXERCISES
-- =========================================================

DROP TABLE IF EXISTS Employee CASCADE;
DROP TABLE IF EXISTS Department CASCADE;

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL
);

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE,
    salary DECIMAL(10, 2) NOT NULL CHECK (salary > 0),
    hire_date DATE NOT NULL,
    dept_id INT,
    manager_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id) ON DELETE SET NULL,
    FOREIGN KEY (manager_id) REFERENCES Employee(emp_id) ON DELETE SET NULL
);

-- Insert Sample Data
INSERT INTO Department (dept_id, dept_name, location) VALUES
(10, 'Engineering', 'Bengaluru'),
(20, 'Sales & Marketing', 'Mumbai'),
(30, 'Human Resources', 'New Delhi'),
(40, 'Finance', 'Hyderabad');

INSERT INTO Employee (emp_id, emp_name, email, salary, hire_date, dept_id, manager_id) VALUES
(101, 'Aarav Mehta', 'aarav.m@company.com', 95000.00, '2020-01-15', 10, NULL),
(102, 'Neha Gupta', 'neha.g@company.com', 78000.00, '2021-03-20', 10, 101),
(103, 'Rohan Verma', 'rohan.v@company.com', 82000.00, '2019-07-10', 20, 101),
(104, 'Ananya Sen', 'ananya.s@company.com', 62000.00, '2022-05-12', 20, 103),
(105, 'Vikram Singh', 'vikram.s@company.com', 55000.00, '2021-11-01', 30, NULL),
(106, 'Kavya Rao', 'kavya.r@company.com', 88000.00, '2018-09-25', 10, 101),
(107, 'Siddharth Joshi', 'siddharth.j@company.com', 48000.00, '2023-02-14', 40, NULL);


-- =========================================================
-- 2. QUERY EXERCISES & SOLUTIONS
-- =========================================================

-- Q1: Display all employees earning a salary greater than 70,000 ordered by salary descending.
SELECT emp_id, emp_name, salary, hire_date
FROM Employee
WHERE salary > 70000.00
ORDER BY salary DESC;

-- Q2: Find the total number of employees, average salary, maximum salary, and minimum salary in each department.
SELECT dept_id,
       COUNT(emp_id) AS total_employees,
       ROUND(AVG(salary), 2) AS avg_salary,
       MAX(salary) AS max_salary,
       MIN(salary) AS min_salary
FROM Employee
GROUP BY dept_id;

-- Q3: Find departments having an average salary greater than 70,000 (HAVING Clause).
SELECT dept_id, ROUND(AVG(salary), 2) AS avg_salary
FROM Employee
GROUP BY dept_id
HAVING AVG(salary) > 70000.00;

-- Q4: Pattern Matching - Find employees whose names start with 'A' or contain 'Singh'.
SELECT emp_id, emp_name, email
FROM Employee
WHERE emp_name LIKE 'A%' OR emp_name LIKE '%Singh%';

-- Q5: Date Functions - Find employees hired between 2020-01-01 and 2022-12-31 and calculate years of service.
SELECT emp_id, emp_name, hire_date,
       (2026 - EXTRACT(YEAR FROM hire_date)) AS years_completed
FROM Employee
WHERE hire_date BETWEEN '2020-01-01' AND '2022-12-31';

-- Q6: NULL Value Handling - Find all employees who do not have a assigned manager.
SELECT emp_id, emp_name, salary, dept_id
FROM Employee
WHERE manager_id IS NULL;

-- Q7: String Functions - Convert employee names to UPPERCASE and extract email domains.
SELECT emp_name,
       UPPER(emp_name) AS upper_name,
       SUBSTRING(email FROM POSITION('@' IN email) + 1) AS email_domain
FROM Employee;
