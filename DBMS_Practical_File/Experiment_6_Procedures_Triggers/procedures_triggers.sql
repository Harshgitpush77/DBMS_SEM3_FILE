-- Experiment 6: Stored Procedures, Functions & Database Triggers
-- Database System: Standard SQL / MySQL / PostgreSQL PL/pgSQL

-- =========================================================
-- 1. SETUP AUDIT LOG & PRODUCT INVENTORY TABLES
-- =========================================================

DROP TABLE IF EXISTS Price_Audit_Log CASCADE;

CREATE TABLE Price_Audit_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    old_price DECIMAL(10, 2),
    new_price DECIMAL(10, 2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =========================================================
-- 2. STORED PROCEDURE 1: Place New Order with Validation
-- =========================================================

DELIMITER //

CREATE PROCEDURE PlaceOrder (
    IN p_customer_id INT,
    IN p_amount DECIMAL(12, 2),
    OUT p_order_id INT,
    OUT p_status_msg VARCHAR(255)
)
BEGIN
    DECLARE v_cust_exists INT DEFAULT 0;

    -- Check if customer exists
    SELECT COUNT(*) INTO v_cust_exists
    FROM Customer
    WHERE customerid = p_customer_id;

    IF v_cust_exists = 0 THEN
        SET p_order_id = NULL;
        SET p_status_msg = 'Error: Customer ID does not exist.';
    ELSE
        -- Insert new order
        INSERT INTO Orders (customerid, orderdate, totalamount)
        VALUES (p_customer_id, CURRENT_DATE, p_amount);

        -- Get last inserted order ID
        SET p_order_id = LAST_INSERT_ID();
        SET p_status_msg = 'Success: Order placed successfully.';
    END IF;
END //

DELIMITER ;


-- =========================================================
-- 3. STORED PROCEDURE 2: Calculate Total Customer Spend
-- =========================================================

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


-- =========================================================
-- 4. TRIGGER 1: BEFORE INSERT - Validate Product Price
-- =========================================================

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


-- =========================================================
-- 5. TRIGGER 2: AFTER UPDATE - Audit Log for Product Price Changes
-- =========================================================

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


-- =========================================================
-- 6. TESTING PROCEDURES AND TRIGGERS
-- =========================================================

-- Test Procedure 1
CALL PlaceOrder(1, 150.00, @new_ord_id, @msg);
SELECT @new_ord_id AS Created_Order_ID, @msg AS Execution_Status;

-- Test Procedure 2
CALL GetCustomerTotalSpend(1, @total);
SELECT @total AS Customer_1_Total_Spend;

-- Test Trigger 2 (Price Update & Audit Log Verification)
UPDATE Product
SET price = 179.99
WHERE productid = 501;

-- Check Audit Log Table
SELECT * FROM Price_Audit_Log;
