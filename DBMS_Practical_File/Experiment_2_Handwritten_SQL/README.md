# Experiment 2: Relational Schema DDL and DML Queries (Handwritten SQL)

## 📌 Aim & Objective
To convert the E-R Diagram designed in Experiment 1 into a **Relational Schema** and write standard **SQL DDL (Data Definition Language)** commands to create tables with appropriate primary keys, foreign keys, and constraints, followed by **SQL DML (Data Manipulation Language)** commands to insert sample records.

---

## 🗂️ Relational Schema Mapping

| Entity / Relationship | Relational Table | Attributes (*Primary Keys*, Foreign Keys) |
| :--- | :--- | :--- |
| **Category** | `Category` | ***categoryid***, `categoryname` |
| **Seller** | `Seller` | ***sellerid***, `sellername`, `phone` |
| **Product** | `Product` | ***productid***, `productname`, `price`, `brand`, `categoryid` (FK), `sellerid` (FK) |
| **Customer** | `Customer` | ***customerid***, `customername`, `email`, `phone` |
| **Address** | `Address` | ***addressid***, ***customerid*** (FK), `street`, `city`, `state`, `pincode` |
| **Order** | `Orders` | ***orderid***, `customerid` (FK), `orderdate`, `totalamount` |
| **Payment** | `Payment` | ***paymentid***, `orderid` (FK, Unique), `paymentmode`, `amount`, `paymentdate` |
| **Delivery** | `Delivery` | ***deliveryid***, `orderid` (FK, Unique), `status`, `deliverydate` |
| **Order_Item** | `Order_Item` | ***itemno***, ***orderid*** (FK), `productid` (FK), `quantity`, `unit_price` |

---

## 💻 SQL DDL Statements (Data Definition Language)

```sql
-- 1. Category Table
CREATE TABLE Category (
    categoryid INT PRIMARY KEY,
    categoryname VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Seller Table
CREATE TABLE Seller (
    sellerid INT PRIMARY KEY,
    sellername VARCHAR(150) NOT NULL,
    phone VARCHAR(20)
);

-- 3. Product Table
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

-- 4. Customer Table
CREATE TABLE Customer (
    customerid INT PRIMARY KEY,
    customername VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20)
);

-- 5. Address Table (Weak Entity)
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

-- 6. Orders Table
CREATE TABLE Orders (
    orderid INT PRIMARY KEY,
    customerid INT NOT NULL,
    orderdate DATE NOT NULL DEFAULT CURRENT_DATE,
    totalamount DECIMAL(12, 2) NOT NULL CHECK (totalamount >= 0),
    FOREIGN KEY (customerid) REFERENCES Customer(customerid) ON DELETE CASCADE
);

-- 7. Payment Table (1:1 Relationship with Orders)
CREATE TABLE Payment (
    paymentid INT PRIMARY KEY,
    orderid INT NOT NULL UNIQUE,
    paymentmode VARCHAR(50) NOT NULL CHECK (paymentmode IN ('Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'COD')),
    amount DECIMAL(12, 2) NOT NULL CHECK (amount >= 0),
    paymentdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (orderid) REFERENCES Orders(orderid) ON DELETE CASCADE
);

-- 8. Delivery Table (1:1 Relationship with Orders)
CREATE TABLE Delivery (
    deliveryid INT PRIMARY KEY,
    orderid INT NOT NULL UNIQUE,
    status VARCHAR(50) NOT NULL DEFAULT 'Pending' CHECK (status IN ('Pending', 'Dispatched', 'In Transit', 'Delivered', 'Cancelled')),
    deliverydate DATE,
    FOREIGN KEY (orderid) REFERENCES Orders(orderid) ON DELETE CASCADE
);

-- 9. Order_Item Table (Associative Entity)
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
```

---

## 📝 SQL DML Statements (Data Manipulation Language)

```sql
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
```

---

## 🔍 Verification Queries

```sql
SELECT * FROM Category;
SELECT * FROM Seller;
SELECT * FROM Product;
SELECT * FROM Customer;
SELECT * FROM Address;
SELECT * FROM Orders;
SELECT * FROM Payment;
SELECT * FROM Delivery;
SELECT * FROM Order_Item;
```

- **Executable SQL Script:** [`schema_and_data.sql`](./schema_and_data.sql)
- **Handwritten SQL Assignment PDF:** [`EXP_2_DBMD.pdf`](./EXP_2_DBMD.pdf)
