DROP DATABASE IF EXISTS CarRepairShop;
CREATE DATABASE CarRepairShop;
USE CarRepairShop;

-- =========================
-- Customer
-- =========================
CREATE TABLE Customer(
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    phone CHAR(11) NOT NULL,
    email VARCHAR(50),
    
    CONSTRAINT chk_phone
        CHECK (phone REGEXP '^09[0-9]{9}$'),
        
    CONSTRAINT uq_email UNIQUE (email)
);

-- =========================
-- Vehicle
-- =========================
CREATE TABLE Vehicle(
    vin VARCHAR(20) PRIMARY KEY,
    plate_no VARCHAR(20) NOT NULL UNIQUE,
    brand VARCHAR(50),
    model VARCHAR(50),
    model_year INT,
    customer_id INT,
   
	CONSTRAINT chk_plate_format 
    CHECK (plate_no REGEXP '^IR [0-9]{2}[A-Z][0-9]{3}$'),

   
    CONSTRAINT chk_year
        CHECK (model_year BETWEEN 1980 AND 2035),

    FOREIGN KEY(customer_id)
        REFERENCES Customer(customer_id)
        ON DELETE RESTRICT
);

-- =========================
-- Part
-- =========================
CREATE TABLE Part(
    part_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE,
    unit_price DECIMAL(10,2) NOT NULL,
    stock_qty INT NOT NULL,

    CHECK(unit_price > 0),
    CHECK(stock_qty >= 0)
);

-- =========================
-- Repair Order
-- =========================
CREATE TABLE Repair_Order(
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    opened_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('OPEN','CLOSED') DEFAULT 'OPEN',
    closed_at TIMESTAMP NULL,
    labor_cost DECIMAL(10,2) NOT NULL,
    part_id INT,
    part_qty INT,
    vin VARCHAR(20),

    CHECK(labor_cost > 0),
    CHECK(part_qty > 0),

    FOREIGN KEY(part_id)
        REFERENCES Part(part_id)
        ON DELETE RESTRICT,

    FOREIGN KEY(vin)
        REFERENCES Vehicle(vin)
        ON DELETE RESTRICT
);

-- =========================
-- Invoice
-- =========================
CREATE TABLE Invoice(
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT UNIQUE,
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status ENUM('UNPAID','PARTIAL','PAID') DEFAULT 'UNPAID',

    FOREIGN KEY(order_id)
        REFERENCES Repair_Order(order_id)
        ON DELETE RESTRICT
);

-- =========================
-- Payment
-- =========================
CREATE TABLE Payment(
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT,
    paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2),
    method ENUM('CASH','CARD','TRANSFER'),

    CHECK(amount > 0),

    FOREIGN KEY(invoice_id)
        REFERENCES Invoice(invoice_id)
        ON DELETE CASCADE
);

-- ===================================
-- Initial Customers
-- ===================================
INSERT INTO Customer (customer_id, full_name, phone, email) VALUES
(1, 'Ali Ahmadi', '09121111111', 'ali@example.com'),
(2, 'Sara Mohammadi', '09122222222', 'sara@example.com'),
(3, 'Reza Karimi', '09123333333', 'reza@example.com'),
(4, 'Hassan Nouri', '09124444444', 'hassan@example.com'),
(5, 'Zahra Jafari', '09125555555', 'zahra@example.com'),
(6, 'Nima Ahmadi', '09126666666', 'nima@example.com'),
(7, 'Fatemeh Rahimi', '09127777777', 'fatemeh@example.com'),
(8, 'Soheil Rahimi', '09128888888', 'soheil@example.com'),
(9, 'Neda Shirazi', '09129999999', 'neda@example.com'),
(10, 'Sina Kamali', '09351111111', 'sina@example.com');

-- ===================================
-- Vehicles
-- ===================================
INSERT INTO Vehicle (vin, plate_no, brand, model, model_year, customer_id) VALUES
('VIN001', 'IR 11A111', 'Honda', 'Accord', 2012, 1),
('VIN002', 'IR 22B222', 'Chrysler', '300', 2016, 2),
('VIN003', 'IR 33C333', 'Toyota', 'Camry', 2020, 3),
('VIN004', 'IR 44D444', 'Ford', 'Mustang', 2019, 4),
('VIN005', 'IR 55E555', 'Hyundai', 'Sonata', 2017, 5),
('VIN006', 'IR 66F666', 'BMW', '320i', 2021, 6),
('VIN007', 'IR 77G777', 'Kia', 'Optima', 2015, 7),
('VIN008', 'IR 88H888', 'Nissan', 'Altima', 2019, 8),
('VIN009', 'IR 99I999', 'Honda', 'Civic', 2018, 9),
('VIN010', 'IR 10J100', 'Benz', 'C200', 2018, 10);

-- ===================================
-- Parts
-- ===================================
INSERT INTO Part (part_id, name, unit_price, stock_qty) VALUES
(1, 'Brake Pad Set', 80.00, 5),
(2, 'Oil Filter', 12.00, 10),
(3, 'AC Gas Can', 25.00, 3),
(4, 'Spark Plug', 15.00, 20),
(5, 'Car Battery', 120.00, 4),
(6, 'Air Filter', 18.00, 15),
(7, 'Cabin Filter', 22.00, 8),
(8, 'Wiper Blade', 10.00, 25),
(9, 'Timing Belt', 90.00, 2),
(10, 'Fuel Pump', 150.00, 5);

-- ===================================
-- Repair Orders
-- ===================================
INSERT INTO Repair_Order (order_id, opened_at, status, closed_at, labor_cost, part_id, part_qty, vin) VALUES
(1, '2024-01-01', 'CLOSED', '2024-01-02', 50.00, 2, 1, 'VIN001'),
(2, '2024-01-03', 'OPEN', NULL, 40.00, 1, 1, 'VIN002'),
(3, '2024-01-05', 'CLOSED', '2024-01-06', 80.00, 4, 4, 'VIN003'),
(4, '2024-01-10', 'CLOSED', '2024-01-11', 30.00, 5, 1, 'VIN004'),
(5, '2024-01-12', 'OPEN', NULL, 25.00, 6, 1, 'VIN005'),
(6, '2024-01-15', 'CLOSED', '2024-01-16', 60.00, 2, 1, 'VIN006'),
(7, '2024-01-16', 'CLOSED', '2024-01-16', 15.00, 8, 2, 'VIN006'),
(8, '2024-01-18', 'CLOSED', '2024-01-19', 20.00, 7, 1, 'VIN006'),
(9, '2024-01-20', 'CLOSED', '2024-01-21', 45.00, 3, 1, 'VIN007'),
(10, '2024-01-22', 'CLOSED', '2024-01-23', 55.00, 2, 1, 'VIN008');

INSERT INTO Invoice (invoice_id, order_id, issued_at, total_amount, status) VALUES
(1, 1, '2024-01-02', 62.00, 'PAID'),
(2, 3, '2024-01-06', 140.00, 'PARTIAL'),
(3, 4, '2024-01-11', 150.00, 'UNPAID'),
(4, 6, '2024-01-16', 72.00, 'PAID'),
(5, 7, '2024-01-16', 35.00, 'PAID'),
(6, 8, '2024-01-19', 42.00, 'PAID'),
(7, 9, '2024-01-21', 70.00, 'PAID'),
(8, 10, '2024-01-23', 67.00, 'PARTIAL');


INSERT INTO Payment (payment_id, invoice_id, paid_at, amount, method) VALUES
(1, 1, '2024-01-02', 62.00, 'CARD'),
(2, 2, '2024-01-07', 100.00, 'CASH'),
(3, 4, '2024-01-16', 72.00, 'TRANSFER'),
(4, 5, '2024-01-17', 35.00, 'CARD'),
(5, 6, '2024-01-19', 42.00, 'CASH'),
(6, 7, '2024-01-22', 70.00, 'CARD'),
(7, 8, '2024-01-24', 40.00, 'TRANSFER');


DELIMITER //

CREATE TRIGGER trg_invoice_total_no_manual_update
BEFORE UPDATE ON Invoice
FOR EACH ROW
BEGIN
    DECLARE labor DECIMAL(10,2);
    DECLARE price DECIMAL(10,2);
    DECLARE qty INT;
    DECLARE calc_total DECIMAL(10,2);

    SELECT r.labor_cost, r.part_qty, p.unit_price
      INTO labor, qty, price
    FROM Repair_Order r
    JOIN Part p ON r.part_id = p.part_id
    WHERE r.order_id = NEW.order_id;

    SET calc_total = labor + (qty * price);

    IF NEW.total_amount <> calc_total THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Manual update of total_amount is not allowed';
    END IF;

    SET NEW.total_amount = calc_total;
END//

DELIMITER ;



-- ===================================
-- Stock Management Trigger
-- ===================================
DELIMITER //

CREATE TRIGGER trg_reduce_stock
BEFORE INSERT ON Repair_Order
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;

    SELECT stock_qty INTO current_stock
    FROM Part
    WHERE part_id = NEW.part_id;

    IF current_stock < NEW.part_qty THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Not enough stock';
    ELSE
        UPDATE Part
        SET stock_qty = stock_qty - NEW.part_qty
        WHERE part_id = NEW.part_id;
    END IF;
END//

DELIMITER ;

-- ===================================
-- Payment Status Update Trigger
-- ===================================
DELIMITER //

CREATE TRIGGER trg_payment_update
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
    DECLARE total_paid DECIMAL(10,2);
    DECLARE total_invoice DECIMAL(10,2);

    SELECT SUM(amount) INTO total_paid
    FROM Payment
    WHERE invoice_id = NEW.invoice_id;

    SELECT total_amount INTO total_invoice
    FROM Invoice
    WHERE invoice_id = NEW.invoice_id;

    IF total_paid = total_invoice THEN
        UPDATE Invoice
        SET status='PAID'
        WHERE invoice_id=NEW.invoice_id;

    ELSEIF total_paid < total_invoice THEN
        UPDATE Invoice
        SET status='PARTIAL'
        WHERE invoice_id=NEW.invoice_id;

    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Payment exceeds invoice total';
    END IF;
END//

DELIMITER ;

-- ===================================
-- Views
-- ===================================
CREATE VIEW InvoiceSummary AS
SELECT
c.full_name,
v.plate_no,
i.total_amount,
i.status
FROM Invoice i
JOIN Repair_Order r ON i.order_id=r.order_id
JOIN Vehicle v ON r.vin=v.vin
JOIN Customer c ON v.customer_id=c.customer_id;

CREATE VIEW CriticalParts AS
SELECT *
FROM Part
WHERE stock_qty < 3;
