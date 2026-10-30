# Database Management Systems (DBMS) - Practical Lab File

Welcome to the **DBMS Semester 3 Practical Laboratory File** repository (`DBMS_SEM3_FILE`). This repository houses comprehensive experiments, database schemas, ER diagrams, SQL scripts, handwritten assignments, and query solutions covering foundational and advanced relational database concepts.

---

## 📚 Table of Contents

| Exp No. | Experiment Title | Key Topics & Concepts | Links |
| :---: | :--- | :--- | :---: |
| **01** | **E-R Diagram Design** | Entity-Relationship modeling, Strong/Weak Entities, Multi-valued attributes, Cardinalities, Mermaid diagram | [Folder](./DBMS_Practical_File/Experiment_1_ER_Diagram) \| [README](./DBMS_Practical_File/Experiment_1_ER_Diagram/README.md) |
| **02** | **Relational Schema DDL & DML** | E-R to Relational conversion, Table Creation, Constraints (PK, FK, CHECK), Sample Data Insertion | [Folder](./DBMS_Practical_File/Experiment_2_Handwritten_SQL) \| [README](./DBMS_Practical_File/Experiment_2_Handwritten_SQL/README.md) \| [SQL](./DBMS_Practical_File/Experiment_2_Handwritten_SQL/schema_and_data.sql) |
| **03** | **Filtering, Aggregation & Functions** | `WHERE`, `ORDER BY`, Aggregate Functions (`SUM`, `AVG`, `COUNT`), `GROUP BY`, `HAVING`, `LIKE`, Date & String functions | [Folder](./DBMS_Practical_File/Experiment_3_Employee_Queries) \| [README](./DBMS_Practical_File/Experiment_3_Employee_Queries/README.md) \| [SQL](./DBMS_Practical_File/Experiment_3_Employee_Queries/queries.sql) |
| **04** | **Relational Joins & Subqueries** | `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `SELF JOIN`, Scalar Subqueries, Multi-row (`IN`), Correlated (`EXISTS`) | [Folder](./DBMS_Practical_File/Experiment_4_Joins_Subqueries) \| [README](./DBMS_Practical_File/Experiment_4_Joins_Subqueries/README.md) \| [SQL](./DBMS_Practical_File/Experiment_4_Joins_Subqueries/queries.sql) |
| **05** | **Views & Common Table Expressions** | Database Views, Updatable Views with `WITH CHECK OPTION`, Non-recursive CTEs, Recursive CTEs (Hierarchical trees) | [Folder](./DBMS_Practical_File/Experiment_5_Views_CTE) \| [README](./DBMS_Practical_File/Experiment_5_Views_CTE/README.md) \| [SQL](./DBMS_Practical_File/Experiment_5_Views_CTE/queries.sql) |
| **06** | **Stored Procedures, Functions & Triggers** | Stored Procedures (`IN`/`OUT` parameters), Business logic encapsulation, `BEFORE INSERT` validation, `AFTER UPDATE` audit logs | [Folder](./DBMS_Practical_File/Experiment_6_Procedures_Triggers) \| [README](./DBMS_Practical_File/Experiment_6_Procedures_Triggers/README.md) \| [SQL](./DBMS_Practical_File/Experiment_6_Procedures_Triggers/procedures_triggers.sql) |

---

## 🗂️ Repository Structure

```text
DBMS_SEM3_FILE/
│
├── README.md                                          # Master repository documentation
└── DBMS_Practical_File/                               # Complete laboratory experiments
    ├── Experiment_1_ER_Diagram/
    │   ├── er_diagram.png                             # Rendered E-Commerce ER diagram
    │   └── README.md                                  # Experiment 1 aim, entities, attributes & Mermaid ER code
    │
    ├── Experiment_2_Handwritten_SQL/
    │   ├── EXP_2_DBMD.pdf                             # Handwritten SQL assignment document
    │   ├── schema_and_data.sql                        # Complete DDL schema and DML seed data script
    │   └── README.md                                  # Experiment 2 relational schema mapping and SQL
    │
    ├── Experiment_3_Employee_Queries/
    │   ├── queries.sql                                # Queries for filtering, grouping, aggregation, and functions
    │   └── README.md                                  # Query problem statements and solutions
    │
    ├── Experiment_4_Joins_Subqueries/
    │   ├── queries.sql                                # Complex Joins and nested subquery scripts
    │   └── README.md                                  # Detailed explanations for each join and subquery
    │
    ├── Experiment_5_Views_CTE/
    │   ├── queries.sql                                # View definitions and CTE implementations
    │   └── README.md                                  # Experiment 5 concepts and recursive hierarchy examples
    │
    └── Experiment_6_Procedures_Triggers/
        ├── procedures_triggers.sql                    # Stored procedures, triggers and test executions
        └── README.md                                  # Business logic validation and audit trail documentation
```

---

## 🛠️ How to Execute the Scripts

### Prerequisites
- Any standard Relational Database Management System:
  - **PostgreSQL** (v12 or higher recommended)
  - **MySQL** (v8.0 or higher) / **MariaDB**
  - **Oracle Database** / **SQLite** (for core SQL syntax)

### Steps to Run
1. **Clone the repository:**
   ```bash
   git clone https://github.com/Harshgitpush77/DBMS_SEM3_FILE.git
   cd DBMS_SEM3_FILE
   ```

2. **Execute Database Schemas & Queries:**
   - For PostgreSQL:
     ```bash
     psql -U your_username -d your_database -f DBMS_Practical_File/Experiment_2_Handwritten_SQL/schema_and_data.sql
     ```
   - For MySQL:
     ```bash
     mysql -u your_username -p your_database < DBMS_Practical_File/Experiment_2_Handwritten_SQL/schema_and_data.sql
     ```

---

## ✍️ Author
- **Repository:** [DBMS_SEM3_FILE](https://github.com/Harshgitpush77/DBMS_SEM3_FILE)
- **Account:** [Harshgitpush77](https://github.com/Harshgitpush77)
