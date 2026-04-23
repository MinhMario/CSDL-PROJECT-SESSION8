
CREATE DATABASE IF NOT EXISTS CarRentalDB;
USE CarRentalDB;

-- Xóa bảng nếu đã tồn tại (theo thứ tự FK)
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Rentals;
DROP TABLE IF EXISTS Staffs;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id  VARCHAR(10)  PRIMARY KEY,
    full_name    VARCHAR(100) NOT NULL,
    license_no   VARCHAR(20)  NOT NULL UNIQUE,
    phone        VARCHAR(15)  NOT NULL,
    address      VARCHAR(200)
);

CREATE TABLE Staffs (
    staff_id          VARCHAR(10)   PRIMARY KEY,
    full_name         VARCHAR(100)  NOT NULL,
    branch            VARCHAR(50)   NOT NULL,
    salary_base       DECIMAL(15,2) NOT NULL CHECK (salary_base >= 0),
    performance_score DECIMAL(3,2)  NOT NULL DEFAULT 0
);

CREATE TABLE Rentals (
    rental_id   INT          PRIMARY KEY AUTO_INCREMENT,
    customer_id VARCHAR(10)  NOT NULL,
    staff_id    VARCHAR(10)  NOT NULL,
    rental_date TIMESTAMP    NOT NULL,
    return_date TIMESTAMP    NOT NULL,
    status      ENUM('Booked','PickedUp','Returned','Cancelled') NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (staff_id)    REFERENCES Staffs(staff_id)
);

CREATE TABLE Payments (
    payment_id     INT           PRIMARY KEY AUTO_INCREMENT,
    rental_id      INT           NOT NULL,
    payment_method VARCHAR(50)   NOT NULL,
    payment_date   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount         DECIMAL(15,2) NOT NULL CHECK (amount >= 0),
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id)
);


-- 5 Khách hàng
INSERT INTO Customers (customer_id, full_name, license_no, phone, address) VALUES
('C001', 'Nguyen Van An',   'BLX-001122', '0901234561', 'Hà Nội'),
('C002', 'Tran Thi Bich',   'BLX-002233', '0901234562', 'Hồ Chí Minh'),
('C003', 'Le Hoang Nam',    'BLX-003344', '0901234563', 'Đà Nẵng'),
('C004', 'Pham Minh Tuan',  'BLX-004455', '0901234564', 'Hải Phòng'),
('C005', 'Vo Thi Thu Hien', 'BLX-005566', '0901234565', 'Cần Thơ');

-- 5 Nhân viên
INSERT INTO Staffs (staff_id, full_name, branch, salary_base, performance_score) VALUES
('S001', 'Nguyen Duc Minh',  'Hanoi',    12000000.00, 4.5),
('S002', 'Tran Bao Ngoc',    'Hanoi',    11000000.00, 4.2),
('S003', 'Le Van Thanh',     'Da Nang',  10500000.00, 3.8),
('S004', 'Pham Thi Lan',     'Da Nang',  10000000.00, 4.0),
('S005', 'Hoang Quoc Viet',  'HCM',      13000000.00, 4.7);

-- 5 Hợp đồng thuê xe
INSERT INTO Rentals (customer_id, staff_id, rental_date, return_date, status) VALUES
('C001', 'S001', '2025-01-10 08:00:00', '2025-01-15 08:00:00', 'Returned'),
('C002', 'S002', '2025-02-05 09:00:00', '2025-02-10 09:00:00', 'Returned'),
('C003', 'S003', '2025-03-01 10:00:00', '2025-03-05 10:00:00', 'PickedUp'),
('C004', 'S004', '2025-03-20 11:00:00', '2025-03-25 11:00:00', 'Booked'),
('C005', 'S005', '2025-04-01 08:30:00', '2025-04-07 08:30:00', 'Cancelled');

-- 5 Phiếu thanh toán
INSERT INTO Payments (rental_id, payment_method, payment_date, amount) VALUES
(1, 'Cash',        '2025-01-15 09:00:00', 2500000.00),
(2, 'Credit Card', '2025-02-10 10:00:00', 3000000.00),
(3, 'Cash',        '2025-03-01 10:30:00', 1500000.00),
(4, 'Bank Transfer','2025-03-20 11:30:00',2000000.00),
(5, 'Credit Card', '2025-04-01 09:00:00',  500000.00);

SELECT * FROM Customers;
SELECT * FROM Staffs;
SELECT * FROM Rentals;
SELECT * FROM Payments;

UPDATE Customers
SET address='Lien Chieu, Da Nang'
WHERE customer_id='C003';

UPDATE Staffs
SET salary_base = salary_base * 1.1,
    performance_score = 4.8
WHERE staff_id = 'S002';

DELETE FROM Rentals
WHERE status='Cancelled' AND rental_date<"2024-01-01";

ALTER TABLE Customers
MODIFY address  VARCHAR(200) DEFAULT 'Unknown';

ALTER TABLE Staffs
ADD email VARCHAR(100);


UPDATE Payments
SET amount = amount * 0.95
WHERE payment_method = 'Cash';

-- Kiểm tra kết quả
SELECT payment_id, payment_method, amount FROM Payments;



DROP TABLE IF EXISTS Staff_Backup;

CREATE TABLE Staff_Backup (
    staff_id          VARCHAR(10),
    full_name         VARCHAR(100),
    branch            VARCHAR(50),
    salary_base       DECIMAL(15,2),
    performance_score DECIMAL(3,2),
    email             VARCHAR(100),
    backup_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Staff_Backup (staff_id, full_name, branch, salary_base, performance_score, email)
SELECT staff_id, full_name, branch, salary_base, performance_score, email
FROM Staffs;

-- Kiểm tra kết quả
SELECT * FROM Staff_Backup;

ALTER TABLE Rentals
ADD CONSTRAINT chk_return_after_rental
CHECK (return_date >= rental_date);

SELECT full_name FROM Staffs
WHERE performance_score>4.0 AND branch IN('Hanoi');

SELECT full_name,phone FROM Customers
WHERE full_name LIKE'%Hoang%' AND phone IS NOT NULL;

SELECT rental_id, rental_date, status
FROM Rentals
ORDER BY rental_date DESC;

SELECT *
FROM Payments
WHERE payment_method = 'Credit Card'
ORDER BY payment_date DESC
LIMIT 3;

SELECT staff_id, full_name
FROM Staffs
ORDER BY staff_id
LIMIT 2 OFFSET 3;

SELECT * FROM Payments
WHERE amount BETWEEN 1000000 AND 5000000;

SELECT *
FROM Rentals
WHERE MONTH(rental_date) = 10
  AND YEAR(rental_date) = 2024;
  
SELECT DISTINCT branch
FROM Staffs
ORDER BY branch;

SELECT * FROM Staffs
Where branch IN('Hanoi','Da Nang');

SELECT full_name from Customers
WHERE  license_no IS NULL;

SELECT r.rental_id,c.full_name,s.full_name,r.status FROM Rentals r
JOIN Customers c ON c.customer_id=r.customer_id
JOIN Staffs s ON r.staff_id=s.staff_id
WHERE status='PickedUp';

SELECT s.full_name,r.rental_date FROM Staffs s
JOIN Rentals r ON s.staff_id=r.staff_id;

SELECT SUM(amount),payment_method FROM Payments p
GROUP BY payment_method;

select s.staff_id,s.full_name,COUNT(r.staff_id) AS so_hop_dong FROM Staffs s
JOIN Rentals r ON s.staff_id=r.staff_id
GROUP BY s.full_name,s.staff_id
HAVING so_hop_dong>2;

SELECT full_name FROM Staffs
WHERE salary_base>(SELECT AVG(salary_base) FROM Staffs);
 
SELECT c.full_name,SUM(p.amount),r.customer_id FROM Rentals r
JOIN Customers c ON r.customer_id=c.customer_id
JOIN Payments p ON r.rental_id=p.rental_id
WHERE status='Returned'
GROUP BY c.full_name,r.customer_id;

SELECT 
    r.rental_id,
    c.full_name   AS customer_name,
    s.full_name   AS staff_name,
    p.payment_method,
    p.amount
FROM Rentals r
JOIN Customers c ON r.customer_id = c.customer_id
JOIN Staffs    s ON r.staff_id    = s.staff_id
JOIN Payments  p ON r.rental_id   = p.rental_id
ORDER BY r.rental_id;

