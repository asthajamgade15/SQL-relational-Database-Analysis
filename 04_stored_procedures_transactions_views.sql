-- ============================================================
-- SQL Relational Database Design & Analysis
-- Part 4: Stored Procedures, Transactions, Views & Triggers
-- ============================================================
-- Advanced database programming on the restaurant listings
-- dataset: stored procedures, transaction control (rollback),
-- window functions, views, loops, and triggers.
-- ============================================================

SELECT * FROM [dbo].[Jomato];

-- 1. Stored procedure to display restaurant name, type, and cuisine
--    where the cuisine type is 'Pizza'
IF OBJECT_ID('GetPizzaRestaurants', 'P') IS NOT NULL
    DROP PROCEDURE GetPizzaRestaurants;
GO

CREATE PROCEDURE GetPizzaRestaurants
AS
BEGIN
    SELECT RestaurantName, RestaurantType, CuisinesType
    FROM [dbo].[Jomato]
    WHERE CuisinesType = 'Pizza';
END;
GO

EXEC GetPizzaRestaurants;

-- 2. Transaction: update cuisine type 'Cafe' to 'Cafeteria',
--    check the result, then roll back the change
BEGIN TRANSACTION;

UPDATE Jomato
SET CuisinesType = 'Cafeteria'
WHERE CuisinesType = 'Cafe';

SELECT * FROM Jomato
WHERE CuisinesType = 'Cafeteria';

ROLLBACK;

-- 3. Row number column to find the top 5 areas with the highest
--    restaurant rating
SELECT
    ROW_NUMBER() OVER (ORDER BY RestaurantName) AS RowNum,
    RestaurantName,
    RestaurantType,
    Rating
FROM Jomato;

-- 4. WHILE loop to display numbers 1 to 50
DECLARE @i INT = 1;

WHILE @i <= 50
BEGIN
    PRINT @i;
    SET @i = @i + 1;
END;

-- 5. View to store the top 5 highest-rated areas
CREATE VIEW Top5Areas AS
SELECT TOP 5
    Area,
    AVG(Rating) AS AvgRating
FROM Jomato
GROUP BY Area
ORDER BY AvgRating DESC;

SELECT * FROM Top5Areas;

-- 6. Trigger that prints a message whenever a new record is inserted
CREATE TRIGGER trg_AfterInsert
ON Jomato
AFTER INSERT
AS
BEGIN
    PRINT 'New restaurant record inserted successfully!';
END;
