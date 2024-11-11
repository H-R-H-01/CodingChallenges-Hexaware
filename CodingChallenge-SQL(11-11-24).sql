-- CODING CHALLENGE - CAR RENTAL SYSTEM

CREATE DATABASE CarRentalSystem

USE CarRentalSystem

-- Creating tables Vehicles, Customers, Lease, Payments
CREATE TABLE Vehicles (
vehicleID INT PRIMARY KEY,
make VARCHAR(50) NOT NULL,
model VARCHAR(50) NOT NULL,
V_Year INT NOT NULL,
dailyRate DECIMAL(10, 2) NOT NULL,
V_Status INT CHECK (V_Status IN (1, 0)),  -- 1 -> available, 0 -> notAvailable
passengerCapacity INT,
engineCapacity INT
)

CREATE TABLE Customers (
customerID INT PRIMARY KEY,
firstName VARCHAR(50) NOT NULL,
lastName VARCHAR(50) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
phoneNumber VARCHAR(15) NOT NULL
)

CREATE TABLE Lease (
leaseID INT PRIMARY KEY,
vehicleID INT,
customerID INT,
startDate DATE NOT NULL,
endDate DATE,
L_Type VARCHAR(15) CHECK (L_Type IN ('DailyLease', 'MonthlyLease')),
FOREIGN KEY (vehicleID) REFERENCES Vehicles(vehicleID) ON DELETE CASCADE,
FOREIGN KEY (customerID) REFERENCES Customers(customerID) ON DELETE CASCADE
)

CREATE TABLE Payments (
paymentID INT PRIMARY KEY,
leaseID INT,
paymentDate DATE NOT NULL,
amount DECIMAL(10, 2),
FOREIGN KEY (leaseID) REFERENCES Lease(leaseID) ON DELETE CASCADE
)

INSERT INTO Vehicles(vehicleID, make, model, V_Year, dailyRate, V_Status, passengerCapacity, engineCapacity)
VALUES (1, 'Toyota', 'Camry', 2022, 50.00, 1, 4, 1450), --V_Status 0 -> not Available, 1 -> Available
(2, 'Honda', 'Civic', 2023, 45.00, 1, 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, 0, 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 1, 7, 1200), 
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 1, 4, 1800), 
(6, 'Hyundai', 'Sonata', 2023, 49.00, 0, 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 1, 7, 2499),
(8, 'Mercedes', 'C-Class', 2022, 58.00, 1, 8, 2599), 
(9, 'Audi', 'A4', 2022, 55.00, 0, 4, 2500),
(10, 'Lexus', 'ES', 2023, 54.00, 1, 4, 2500)

-- Inserting Values into Customers table
INSERT INTO Customers(customerID, firstName, lastName, email, phoneNumber)
VALUES (1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'), 
(2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'), 
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'), 
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321')

INSERT INTO Lease (leaseID, vehicleID, customerID, startDate, endDate, L_Type)
VALUES(1, 1, 1, '2023-01-01', '2023-01-05', 'DailyLease'),
(2, 2, 2, '2023-02-15', '2023-02-28', 'MonthlyLease'),
(3, 3, 3, '2023-03-10', '2023-03-15', 'DailyLease'),
(4, 4, 4, '2023-04-20', '2023-04-30', 'MonthlyLease'),
(5, 5, 5, '2023-05-05', '2023-05-10', 'DailyLease'),
(6, 4, 3, '2023-06-15', '2023-06-30', 'MonthlyLease'),
(7, 7, 7, '2023-07-01', '2023-07-10', 'DailyLease'),
(8, 8, 8, '2023-08-12', '2023-08-15', 'MonthlyLease'),
(9, 3, 3, '2023-09-07', '2023-09-10', 'DailyLease'),
(10, 10, 10, '2023-10-10', '2023-10-31', 'MonthlyLease')

INSERT INTO Payments (paymentID, leaseID, paymentDate, amount)
VALUES (1, 1, '2023-01-03', 200.00),
(2, 2, '2023-02-20', 1000.00),
(3, 3, '2023-03-12', 75.00),
(4, 4, '2023-04-25', 900.00),
(5, 5, '2023-05-07', 60.00),
(6, 6, '2023-06-18', 1200.00),
(7, 7, '2023-07-03', 40.00),
(8, 8, '2023-08-14', 1100.00),
(9, 9, '2023-09-09', 80.00),
(10, 10, '2023-10-25', 1500.00)

-- 1: Update the daily rate for a Mercedes car to 68
UPDATE Vehicles
SET dailyRate = 68.00
WHERE make = 'Mercedes' AND model = 'C-Class'

-- 2: Delete a specific customer and all associated leases and payments
DELETE FROM Customers
WHERE customerID = 5

-- 3: Rename the "paymentDate" column in the Payment table to "transactionDate"
EXEC sp_rename 'Payments.paymentDate', 'transactionDate'

-- 4: Find a specific customer by email
SELECT *
FROM Customers
WHERE email = 'johndoe@example.com'

-- 5: Get active leases for a specific customer
	-- No active lease records in Table , inserting a record with an active lease
	INSERT INTO Lease (leaseID, vehicleID, customerID, startDate, endDate, L_Type)
	VALUES(11, 1, 1, '2024-11-01', '2025-01-05', 'DailyLease'),
	(12, 2, 2, '2024-11-15', '2025-02-28', 'MonthlyLease')

SELECT L.leaseID, L.vehicleID, V.make, V.model, L.startDate, L.endDate
FROM Lease L
JOIN Vehicles V ON L.vehicleID = V.vehicleID
WHERE L.customerID = 1 AND L.endDate >= GETDATE()

-- 6: Find all payments made by a customer with a specific phone number
SELECT P.paymentID,C.firstName + ' ' + C.lastName AS Name,C.phoneNumber, P.transactionDate, P.amount
FROM Payments P
JOIN Lease L ON P.leaseID = L.leaseID
JOIN Customers C ON L.customerID = C.customerID
WHERE C.phoneNumber = '555-555-5555'

-- 7: Calculate the average daily rate of all available cars
SELECT AVG(dailyRate) AS avgDailyRate
FROM Vehicles
WHERE V_Status = 1

-- 8: Find the car with the highest daily rate
SELECT TOP 1 vehicleID, make, model, dailyRate
FROM Vehicles
ORDER BY dailyRate DESC

-- 9: Retrieve all cars leased by a specific customer (lets assume customer_id = 3, because 3 has multiple lease)
SELECT V.vehicleID, V.make, V.model, V.dailyRate
FROM Vehicles V
JOIN Lease L ON V.vehicleID = L.vehicleID
WHERE L.customerID = 3

-- 10: Find the details of the most recent lease
SELECT TOP 1 L.leaseID, L.vehicleID, L.customerID, L.startDate, L.endDate
FROM Lease L
ORDER BY L.startDate DESC

-- 11: List all payments made in the year 2023
SELECT *
FROM Payments P
WHERE YEAR(P.transactionDate) = 2023

-- 12: Retrieve customers who have not made any payments
SELECT C.customerID, C.firstName + ' ' + C.lastName as Name, C.email, C.phoneNumber
FROM Customers C
WHERE NOT EXISTS (SELECT 1
 FROM Payments P
 JOIN Lease L ON P.leaseID = L.leaseID
 WHERE L.customerID = C.customerID
)

-- 13: Retrieve Car Details and Their Total Payments
SELECT V.make, V.model, SUM(P.amount) AS totalPayments
FROM Vehicles V
JOIN Lease L ON V.vehicleID = L.vehicleID
JOIN Payments P ON L.leaseID = P.leaseID
GROUP BY V.make, V.model

-- 14: Calculate Total Payments for Each Customer
SELECT C.firstName + ' ' + C.lastName AS Name, SUM(P.amount) AS totalPayments
FROM Customers C
JOIN Lease L ON C.customerID = L.customerID
JOIN Payments P ON L.leaseID = P.leaseID
GROUP BY C.customerID, C.firstName, C.lastName


-- 15: List Car Details for Each Lease
SELECT L.leaseID, V.make, V.model, L.startDate, L.endDate
FROM Lease L
JOIN Vehicles V ON L.vehicleID = V.vehicleID

-- 16: Retrieve Details of Active Leases with Customer and Car Information
SELECT L.leaseID, C.firstName, C.lastName, V.make, V.model, L.startDate, L.endDate
FROM Lease L
JOIN Customers C ON L.customerID = C.customerID
JOIN Vehicles V ON L.vehicleID = V.vehicleID
WHERE L.endDate >= GETDATE()

-- 17: Find the Customer Who Has Spent the Most on Leases
SELECT TOP 1 C.firstName + ' ' + C.lastName, SUM(P.amount) AS totalSpent
FROM Customers C
JOIN Lease L ON C.customerID = L.customerID
JOIN Payments P ON L.leaseID = P.leaseID
GROUP BY C.customerID, C.firstname, C.lastname
ORDER BY totalSpent DESC

-- 18: List All Cars with Their Current Lease Information
SELECT V.make, V.model, L.startDate, L.endDate
FROM Vehicles V
JOIN Lease L ON V.vehicleID = L.vehicleID
WHERE L.endDate >= GETDATE()