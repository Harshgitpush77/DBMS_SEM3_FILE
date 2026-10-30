# Experiment 6: Stored Procedures, Functions, and Database Triggers

## 📌 Aim & Objective
To construct **Stored Procedures** with input (`IN`) and output (`OUT`) parameters for encapsulating business logic, and implement **Database Triggers** (`BEFORE` and `AFTER` triggers on `INSERT`/`UPDATE`) for data validation and audit log tracking.

---

## 💻 Concepts & SQL Implementations

### 1. Audit Table Setup
```sql
CREATE TABLE Price_Audit_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    old_price DECIMAL(10, 2),
    new_price DECIMAL(10, 2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

### 2. Stored Procedure 1: Customer Order Placement
> **Objective:** Encapsulate validation and transaction logic when creating a new order.

```sql
DELIMITER //

CREATE PROCEDURE PlaceOrder (
    IN p_customer_id INT,
    IN p_amount DECIMAL(12, 2),
    OUT p_order_id INT,
    OUT p_status_msg VARCHAR(255)
)
BEGIN
    DECLARE v_cust_exists INT DEFAULT 0;

    -- Verify customer presence
    SELECT COUNT(*) INTO v_cust_exists
    FROM Customer
    WHERE customerid = p_customer_id;

    IF v_cust_exists = 0 THEN
        SET p_order_id = NULL;
        SET p_status_msg = 'Error: Customer ID does not exist.';
    ELSE
        INSERT INTO Orders (customerid, orderdate, totalamount)
        VALUES (p_customer_id, CURRENT_DATE, p_amount);

        SET p_order_id = LAST_INSERT_ID();
        SET p_status_msg = 'Success: Order placed successfully.';
    END IF;
END //

DELIMITER ;
```

---

### 3. Stored Procedure 2: Customer Spend Calculator
> **Objective:** Calculate total revenue generated from a specific customer.

```sql
DELIMITER //

CREATE PROCEDURE GetCustomerTotalSpend (
    IN p_customer_id INT,
    OUT p_total_spend DECIMAL(12, 2)
)
BEGIN
    SELECT COALESCE(SUM(totalamount), 0.00) INTO p_total_spend
    FROM Orders
    WHERE customerid = p_customer_id;
END //

DELIMITER ;
```

---

### 4. Trigger 1: `BEFORE INSERT` Validation Trigger
> **Objective:** Ensure no product is inserted with a negative price.

```sql
DELIMITER //

CREATE TRIGGER trg_Before_Product_Insert
BEFORE INSERT ON Product
FOR EACH ROW
BEGIN
    IF NEW.price < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Product price cannot be negative.';
    END IF;
END //

DELIMITER ;
```

---

### 5. Trigger 2: `AFTER UPDATE` Audit Logging Trigger
> **Objective:** Record historical price adjustments into `Price_Audit_Log`.

```sql
DELIMITER //

CREATE TRIGGER trg_After_Product_Price_Update
AFTER UPDATE ON Product
FOR EACH ROW
BEGIN
    IF OLD.price <> NEW.price THEN
        INSERT INTO Price_Audit_Log (product_id, old_price, new_price, changed_at)
        VALUES (NEW.productid, OLD.price, NEW.price, NOW());
    END IF;
END //

DELIMITER ;
```

---

### 6. Executing and Testing

```sql
-- Test Procedure 1
CALL PlaceOrder(1, 150.00, @new_ord_id, @msg);
SELECT @new_ord_id AS Created_Order_ID, @msg AS Execution_Status;

-- Test Procedure 2
CALL GetCustomerTotalSpend(1, @total);
SELECT @total AS Customer_1_Total_Spend;

-- Test Price Update Trigger
UPDATE Product
SET price = 179.99
WHERE productid = 501;

-- Inspect Audit Log
SELECT * FROM Price_Audit_Log;
```

---

- **Executable SQL File:** [`procedures_triggers.sql`](./procedures_triggers.sql)
