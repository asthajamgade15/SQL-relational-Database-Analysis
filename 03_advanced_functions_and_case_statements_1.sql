-- ============================================================
-- SQL Relational Database Design & Analysis
-- Part 3: Advanced Functions & CASE Statements (Restaurant Dataset)
-- ============================================================
-- Practice with user-defined functions, CASE-based categorization,
-- built-in math/date functions, and ROLLUP aggregation on a
-- restaurant listings dataset.
-- ============================================================

SELECT * FROM [dbo].[Jomato];

-- 1. User-defined function to replace "Quick Bites" with "Chicken Bites"
--    e.g. "Quick Bites" -> "Chicken Bites"
--    Guarded with a CASE check: if "Quick Bites" isn't found in the input,
--    CHARINDEX returns 0, and STUFF() with a start position of 0 raises an
--    error in SQL Server. The function returns the original value unchanged
--    in that case instead of failing.
CREATE FUNCTION dbo.fn_StuffFoodName(@RestaurantType NVARCHAR(100))
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @Result NVARCHAR(100)
    DECLARE @Position INT = CHARINDEX('Quick Bites', @RestaurantType)

    IF @Position = 0
        SET @Result = @RestaurantType
    ELSE
        SET @Result = STUFF(
            @RestaurantType,
            @Position,
            LEN('Quick Bites'),
            'Chicken Bites'
        )

    RETURN @Result
END;

-- 2. Use the function to display restaurant name and cuisine type
--    for the highest-rated restaurant among "Quick Bites" type restaurants
SELECT TOP 1
    RestaurantName,
    CuisinesType,
    RestaurantType AS OriginalType,
    dbo.fn_StuffFoodName(RestaurantType) AS ModifiedType,
    No_of_Rating
FROM Jomato
WHERE RestaurantType = 'Quick Bites'
ORDER BY No_of_Rating DESC;

-- 3. Create a Rating Status column:
--    'Excellent' if rating > 4, 'Average' if between 3 and 4, else 'Bad'
SELECT
    RestaurantName,
    Rating,
    CASE
        WHEN Rating > 4 THEN 'Excellent'
        WHEN Rating BETWEEN 3 AND 4 THEN 'Average'
        ELSE 'Bad'
    END AS RatingStatus
FROM Jomato;

-- 4. Ceiling, floor, and absolute value of the rating column,
--    plus the current date split into year, month name, and day
SELECT
    RestaurantName,
    Rating,
    CEILING(Rating) AS CeilValue,
    FLOOR(Rating) AS FloorValue,
    ABS(Rating - 5) AS AbsValue,
    GETDATE() AS CurrentDate,
    YEAR(GETDATE()) AS Year_,
    DATENAME(MONTH, GETDATE()) AS MonthName,
    DATEPART(DAYOFYEAR, GETDATE()) AS DayOfYear
FROM Jomato;

-- 5. Restaurant type and total average cost using ROLLUP
SELECT
    RestaurantType,
    SUM(AverageCost) AS TotalAverageCost
FROM Jomato
GROUP BY ROLLUP(RestaurantType);
