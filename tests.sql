USE CarRepairShop;

-- ======================================================
-- 1) Repair history for Ahmadi Ali
-- ======================================================
SELECT
    c.full_name,
    v.plate_no,
    r.opened_at,
    r.labor_cost
FROM Repair_Order r
JOIN Vehicle v ON r.vin = v.vin
JOIN Customer c ON v.customer_id = c.customer_id
WHERE c.full_name = 'Ali Ahmadi';



-- ======================================================
-- 2) Total confirmed revenue
-- ======================================================
SELECT
    SUM(p.amount) AS total_revenue
FROM Payment p
JOIN Invoice i ON p.invoice_id = i.invoice_id
WHERE i.status = 'PAID';



-- ======================================================
-- 3) Most used part
-- ======================================================
SELECT 
    p.name, 
    SUM(r.part_qty) AS usage_count
FROM Repair_Order r
JOIN Part p ON r.part_id = p.part_id
GROUP BY p.name
ORDER BY usage_count DESC
LIMIT 1;



-- ======================================================
-- 4) Customers with debt
-- ======================================================
SELECT 
    c.full_name, 
    c.phone,
    SUM(i.total_amount - IFNULL(p.total_paid, 0)) AS remaining_debt
FROM Invoice i
JOIN Repair_Order r ON i.order_id = r.order_id
JOIN Vehicle v ON r.vin = v.vin
JOIN Customer c ON v.customer_id = c.customer_id
LEFT JOIN (
    SELECT invoice_id, SUM(amount) AS total_paid
    FROM Payment
    GROUP BY invoice_id
) p ON i.invoice_id = p.invoice_id
WHERE i.status IN ('UNPAID', 'PARTIAL')
GROUP BY c.customer_id, c.full_name, c.phone
HAVING remaining_debt > 0;



-- ======================================================
-- 5) Vehicles without repair
-- ======================================================
SELECT *
FROM Vehicle
WHERE vin NOT IN (SELECT vin FROM Repair_Order);



-- ======================================================
-- 6) Total cost of BMW 320i
-- ======================================================
SELECT
    v.vin,
    SUM(r.labor_cost + (r.part_qty * p.unit_price)) AS total_cost
FROM Repair_Order r
JOIN Vehicle v ON r.vin = v.vin
JOIN Part p ON r.part_id = p.part_id
WHERE v.brand = 'BMW'
  AND v.model = '320i'
GROUP BY v.vin;



-- ======================================================
-- 7) VIP customers (more than 2 repairs)
-- ======================================================
SELECT
    c.full_name,
    c.phone,
    COUNT(r.order_id) AS total_repairs
FROM Repair_Order r
JOIN Vehicle v ON r.vin = v.vin
JOIN Customer c ON v.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name, c.phone
HAVING total_repairs > 2;



-- ======================================================
-- 8) Average labor cost of CLOSED orders
-- ======================================================
SELECT AVG(labor_cost)
FROM Repair_Order
WHERE status = 'CLOSED';



-- ======================================================
-- 9) Unused parts
-- ======================================================
SELECT *
FROM Part
WHERE part_id NOT IN (SELECT part_id FROM Repair_Order);



-- ======================================================
-- 10) EXPECTED FAIL — invalid phone format
-- ======================================================
INSERT INTO Customer(full_name, phone)
VALUES ('Bad Phone', '08123456789');



-- ======================================================
-- 11) EXPECTED FAIL — negative payment
-- ======================================================
INSERT INTO Payment(invoice_id, amount, method)
VALUES (1, -50, 'CASH');



-- ======================================================
-- 12) EXPECTED FAIL — invalid ENUM
-- ======================================================
UPDATE Repair_Order
SET status = 'INVALID'
WHERE order_id = 1;



-- ======================================================
-- 13) EXPECTED FAIL — part_qty exceeds stock
-- ======================================================
INSERT INTO Repair_Order (vin, part_id, part_qty, labor_cost)
VALUES ('VIN001', 1, 100, 500000);



-- ======================================================
-- 14) PASS — check initial stock of part #1
-- ======================================================
SELECT stock_qty FROM Part WHERE part_id = 1;



-- ======================================================
-- 15) PASS — valid repair order reduces stock
-- ======================================================
INSERT INTO Repair_Order (vin, part_id, part_qty, labor_cost)
VALUES ('VIN001', 1, 2, 500000);

SELECT stock_qty FROM Part WHERE part_id = 1;



-- ======================================================
-- 16) EXPECTED FAIL — attempt to manually override total_amount
-- ======================================================
UPDATE Invoice
SET total_amount = 100
WHERE invoice_id = 1;



-- ======================================================
-- 17) PASS — partial payment updates invoice status
-- ======================================================
INSERT INTO Payment (invoice_id, amount, method)
VALUES (3, 50, 'CARD');

SELECT status FROM Invoice WHERE invoice_id = 3;



-- ======================================================
-- 18) EXPECTED FAIL — paying more than remaining amount
-- ======================================================
INSERT INTO Payment (invoice_id, amount, method)
VALUES (3, 999999, 'CASH');
