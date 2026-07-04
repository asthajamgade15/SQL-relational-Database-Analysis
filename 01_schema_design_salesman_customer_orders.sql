-- ============================================================
-- SQL Relational Database Design & Analysis
-- Part 1: Schema Design - Salesman, Customer, Orders
-- ============================================================
-- Designed a relational database from scratch with primary keys,
-- foreign keys, and constraints, simulating a real-world
-- database maintenance scenario.
-- ============================================================

-- ---------- SALESMAN TABLE ----------
CREATE TABLE Salesman (
    SalesmanId INT,
    Name VARCHAR(255),
    Commission DECIMAL(10, 2),
    City VARCHAR(255),
    Age INT
);

INSERT INTO Salesman (SalesmanId, Name, Commission, City, Age)
VALUES
    (101, 'Joe', 50, 'California', 17),
    (102, 'Simon', 75, 'Texas', 25),
    (103, 'Jessie', 105, 'Florida', 35),
    (104, 'Danny', 100, 'Texas', 22),
    (105, 'Lia', 65, 'New Jersey', 30);

SELECT * FROM Salesman;

-- Add NOT NULL constraint on primary identifier
ALTER TABLE Salesman
ALTER COLUMN SalesmanId INT NOT NULL;

-- Add a default value constraint on City
ALTER TABLE Salesman
ADD CONSTRAINT DF_city DEFAULT 'Not Mentioned' FOR City;

-- ---------- CUSTOMER TABLE ----------
CREATE TABLE Customer (
    SalesmanId INT,
    CustomerId INT,
    CustomerName VARCHAR(255),
    PurchaseAmount INT
);

INSERT INTO Customer (SalesmanId, CustomerId, CustomerName, PurchaseAmount)
VALUES
    (101, 2345, 'Andrew', 550),
    (103, 1575, 'Lucky', 4500),
    (104, 2345, 'Andrew', 4000),
    (107, 3747, 'Remona', 2700),
    (110, 4004, 'Julia', 4545);

SELECT * FROM Customer;

-- Add a foreign key linking Customer to Salesman
ALTER TABLE Customer
ADD CONSTRAINT FK_salesman_customer
FOREIGN KEY (SalesmanId) REFERENCES Salesman(SalesmanId);

-- Enforce NOT NULL on CustomerName
ALTER TABLE Customer
ALTER COLUMN CustomerName VARCHAR(50) NOT NULL;

-- Find customers whose name ends with 'N' and purchase amount > 500
SELECT * FROM Customer
WHERE CustomerName LIKE '%N'
  AND PurchaseAmount > 500;

-- ---------- ORDERS TABLE ----------
CREATE TABLE Orders (
    OrderId INT,
    CustomerId INT,
    SalesmanId INT,
    OrderDate DATE,
    Amount MONEY
);

INSERT INTO Orders (OrderId, CustomerId, SalesmanId, OrderDate, Amount)
VALUES
    (5001, 2345, 101, '2021-07-01', 550),
    (5003, 1234, 105, '2022-02-15', 1500),
    (5004, 1575, 102, '2023-08-10', 1200);

SELECT * FROM Orders;

-- ---------- COMBINED QUERIES ----------

-- List of all distinct Salesman IDs appearing in either table
SELECT SalesmanId FROM Salesman
UNION
SELECT SalesmanId FROM Orders;

-- Order details for customers with purchase amount between 500 and 1500
SELECT
    o.OrderDate,
    s.Name AS SalesmanName,
    c.CustomerName,
    s.Commission,
    s.City
FROM Orders o
JOIN Salesman s ON o.SalesmanId = s.SalesmanId
JOIN Customer c ON o.CustomerId = c.CustomerId
WHERE c.PurchaseAmount BETWEEN 500 AND 1500;

-- Right join to list all orders along with salesman details
SELECT
    s.SalesmanId,
    s.Name AS SalesmanName,
    s.City,
    o.OrderId,
    o.Amount,
    o.OrderDate
FROM Salesman s
RIGHT JOIN Orders o ON s.SalesmanId = o.SalesmanId;
