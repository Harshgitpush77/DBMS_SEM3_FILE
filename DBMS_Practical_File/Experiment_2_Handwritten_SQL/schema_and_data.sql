-- Experiment 2: Relational Schema DDL and Sample DML Queries
-- Database System: PostgreSQL / Standard SQL

-- =========================================================
-- 1. DROP TABLES (In Reverse Dependency Order)
-- =========================================================
DROP TABLE IF EXISTS Order_Item CASCADE;
DROP TABLE IF EXISTS Delivery CASCADE;
DROP TABLE IF EXISTS Payment CASCADE;
DROP TABLE IF EXISTS Orders CASCADE;
DROP TABLE IF EXISTS Address CASCADE;
DROP TABLE IF EXISTS Customer CASCADE;
DROP TABLE IF EXISTS Product CASCADE;
DROP TABLE IF EXISTS Seller CASCADE;
DROP TABLE IF EXISTS Category CASCADE;

-- =========================================================
-- 2. DDL - TABLE CREATION
-- =========================================================

-- Category Table
CREATE TABLE Category (
    categoryid INT PRIMARY KEY,
    categoryname VARCHAR(100) NOT NULL UNIQUE
);

-- Seller Table
CREATE TABLE Seller (
    sellerid INT PRIMARY KEY,
    sellername VARCHAR(150) NOT NULL,
    phone VARCHAR(20)
);

-- Product Table
CREATE TABLE Product (
    productid INT PRIMARY KEY,
    productname VARCHAR(200) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    brand VARCHAR(100),
    categoryid INT NOT NULL,
    sellerid INT NOT NULL,
    FOREIGN KEY (categoryid) REFERENCES Category(categoryid) ON DELETE CASCADE,
    FOREIGN KEY (sellerid) REFERENCES Seller(sellerid) ON DELETE CASCADE
);

-- Customer Table
CREATE TABLE Customer (
    customerid INT PRIMARY KEY,
    customername VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20)
);

-- Address Table (Weak Entity relative to Customer)
CREATE TABLE Address (
    addressid INT NOT NULL,
    customerid INT NOT NULL,
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(20) NOT NULL,
    PRIMARY KEY (addressid, customerid),
    FOREIGN KEY (customerid) REFERENCES Customer(customerid) ON DELETE CASCADE
);

-- Orders Table
CREATE TABLE Orders (
    orderid INT PRIMARY KEY,
    customerid INT NOT NULL,
    orderdate DATE NOT NULL DEFAULT CURRENT_DATE,
    totalamount DECIMAL(12, 2) NOT NULL CHECK (totalamount >= 0),
    FOREIGN KEY (customerid) REFERENCES Customer(customerid) ON DELETE CASCADE
);

-- Payment Table (1:1 with Orders)
CREATE TABLE Payment (
    paymentid INT PRIMARY KEY,
    orderid INT NOT NULL UNIQUE,
    paymentmode VARCHAR(50) NOT NULL CHECK (paymentmode IN ('Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'COD')),
    amount DECIMAL(12, 2) NOT NULL CHECK (amount >= 0),
    paymentdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (orderid) REFERENCES Orders(orderid) ON DELETE CASCADE
);

-- Delivery Table (1:1 with Orders)
CREATE TABLE Delivery (
    deliveryid INT PRIMARY KEY,
    orderid INT NOT NULL UNIQUE,
    status VARCHAR(50) NOT NULL DEFAULT 'Pending' CHECK (status IN ('Pending', 'Dispatched', 'In Transit', 'Delivered', 'Cancelled')),
    deliverydate DATE,
    FOREIGN KEY (orderid) REFERENCES Orders(orderid) ON DELETE CASCADE
);

-- Order_Item Table (Associative Entity for Order-Product M:N)
CREATE TABLE Order_Item (
    itemno INT NOT NULL,
    orderid INT NOT NULL,
    productid INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    PRIMARY KEY (itemno, orderid),
    FOREIGN KEY (orderid) REFERENCES Orders(orderid) ON DELETE CASCADE,
    FOREIGN KEY (productid) REFERENCES Product(productid) ON DELETE CASCADE
);

-- =========================================================
-- 3. DML - SAMPLE DATA INSERTION
-- =========================================================

-- Insert Categories
INSERT INTO Category (categoryid, categoryname) VALUES
(1, 'Electronics'),
(2, 'Footwear'),
(3, 'Apparel'),
(4, 'Home Appliances');

-- Insert Sellers
INSERT INTO Seller (sellerid, sellername, phone) VALUES
(101, 'TechWorld Retailers', '9876543210'),
(102, 'Apex Sports Gear', '9812345678'),
(103, 'Urban Style Fashions', '9765432109');

-- Insert Products
INSERT INTO Product (productid, productname, price, brand, categoryid, sellerid) VALUES
(501, 'Wireless Noise Cancelling Headphones', 149.99, 'AudioPhonics', 1, 101),
(502, 'Pro Running Shoes', 89.50, 'Velocity', 2, 102),
(503, 'Cotton Casual Shirt', 29.99, 'UrbanCotton', 3, 103),
(504, 'Smart Electric Kettle', 45.00, 'HomeEasy', 4, 101);

-- Insert Customers
INSERT INTO Customer (customerid, customername, email, phone) VALUES
(1, 'Rahul Sharma', 'rahul.sharma@example.com', '9988776655'),
(2, 'Priya Patel', 'priya.patel@example.com', '9877665544'),
(3, 'Amit Verma', 'amit.verma@example.com', '9766554433');

-- Insert Addresses
INSERT INTO Address (addressid, customerid, street, city, state, pincode) VALUES
(1, 1, '12 MG Road', 'Bengaluru', 'Karnataka', '560001'),
(2, 1, '45 Tech Park Avenue', 'Bengaluru', 'Karnataka', '560100'),
(1, 2, '88 Park Street', 'Kolkata', 'West Bengal', '700016'),
(1, 3, '104 Connaught Place', 'New Delhi', 'Delhi', '110001');

-- Insert Orders
INSERT INTO Orders (orderid, customerid, orderdate, totalamount) VALUES
(1001, 1, '2026-03-01', 239.49),
(1002, 2, '2026-03-02', 29.99),
(1003, 3, '2026-03-05', 90.00);

-- Insert Payments
INSERT INTO Payment (paymentid, orderid, paymentmode, amount, paymentdate) VALUES
(9001, 1001, 'UPI', 239.49, '2026-03-01 10:15:00'),
(9002, 1002, 'Credit Card', 29.99, '2026-03-02 14:30:00'),
(9003, 1003, 'COD', 90.00, '2026-03-05 16:45:00');

-- Insert Deliveries
INSERT INTO Delivery (deliveryid, orderid, status, deliverydate) VALUES
(8001, 1001, 'Delivered', '2026-03-04'),
(8002, 1002, 'In Transit', '2026-03-06'),
(8003, 1003, 'Pending', NULL);

-- Insert Order_Items
INSERT INTO Order_Item (itemno, orderid, productid, quantity, unit_price) VALUES
(1, 1001, 501, 1, 149.99),
(2, 1001, 502, 1, 89.50),
(1, 1002, 503, 1, 29.99),
(1, 1003, 504, 2, 45.00);
