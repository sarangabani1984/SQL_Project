-- Sample Dataset for Window Aggregation Functions Practice
-- Sales data with multiple dimensions for comprehensive window function examples

USE bigdata;
GO

-- Drop table if exists
IF OBJECT_ID('Sales', 'U') IS NOT NULL 
    DROP TABLE Sales;
GO

-- Create Sales table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    SaleDate DATE,
    Region VARCHAR(50),
    ProductCategory VARCHAR(50),
    ProductName VARCHAR(100),
    Salesperson VARCHAR(100),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    TotalAmount DECIMAL(10,2)
);
GO

-- Insert sample data (100+ records for meaningful window function practice)
INSERT INTO Sales VALUES
-- January 2024 - Electronics - East Region
(1, '2024-01-05', 'East', 'Electronics', 'Laptop', 'John Smith', 2, 1200.00, 2400.00),
(2, '2024-01-08', 'East', 'Electronics', 'Mouse', 'John Smith', 5, 25.00, 125.00),
(3, '2024-01-10', 'East', 'Electronics', 'Keyboard', 'Sarah Johnson', 3, 75.00, 225.00),
(4, '2024-01-12', 'East', 'Electronics', 'Monitor', 'John Smith', 4, 300.00, 1200.00),
(5, '2024-01-15', 'East', 'Electronics', 'Laptop', 'Sarah Johnson', 1, 1200.00, 1200.00),

-- January 2024 - Electronics - West Region
(6, '2024-01-05', 'West', 'Electronics', 'Laptop', 'Mike Brown', 3, 1200.00, 3600.00),
(7, '2024-01-07', 'West', 'Electronics', 'Tablet', 'Mike Brown', 5, 500.00, 2500.00),
(8, '2024-01-10', 'West', 'Electronics', 'Headphones', 'Lisa Davis', 10, 50.00, 500.00),
(9, '2024-01-12', 'West', 'Electronics', 'Monitor', 'Mike Brown', 2, 300.00, 600.00),
(10, '2024-01-18', 'West', 'Electronics', 'Keyboard', 'Lisa Davis', 6, 75.00, 450.00),

-- January 2024 - Furniture
(11, '2024-01-06', 'East', 'Furniture', 'Desk', 'John Smith', 2, 450.00, 900.00),
(12, '2024-01-09', 'West', 'Furniture', 'Chair', 'Mike Brown', 8, 150.00, 1200.00),
(13, '2024-01-14', 'East', 'Furniture', 'Cabinet', 'Sarah Johnson', 1, 800.00, 800.00),
(14, '2024-01-16', 'West', 'Furniture', 'Desk', 'Lisa Davis', 3, 450.00, 1350.00),
(15, '2024-01-20', 'East', 'Furniture', 'Chair', 'John Smith', 10, 150.00, 1500.00),

-- February 2024 - Electronics - East Region
(16, '2024-02-02', 'East', 'Electronics', 'Laptop', 'John Smith', 5, 1200.00, 6000.00),
(17, '2024-02-05', 'East', 'Electronics', 'Mouse', 'Sarah Johnson', 8, 25.00, 200.00),
(18, '2024-02-08', 'East', 'Electronics', 'Keyboard', 'John Smith', 4, 75.00, 300.00),
(19, '2024-02-12', 'East', 'Electronics', 'Monitor', 'Sarah Johnson', 3, 300.00, 900.00),
(20, '2024-02-15', 'East', 'Electronics', 'Tablet', 'John Smith', 6, 500.00, 3000.00),

-- February 2024 - Electronics - West Region
(21, '2024-02-03', 'West', 'Electronics', 'Laptop', 'Mike Brown', 4, 1200.00, 4800.00),
(22, '2024-02-06', 'West', 'Electronics', 'Headphones', 'Lisa Davis', 12, 50.00, 600.00),
(23, '2024-02-10', 'West', 'Electronics', 'Mouse', 'Mike Brown', 7, 25.00, 175.00),
(24, '2024-02-14', 'West', 'Electronics', 'Monitor', 'Lisa Davis', 5, 300.00, 1500.00),
(25, '2024-02-18', 'West', 'Electronics', 'Keyboard', 'Mike Brown', 9, 75.00, 675.00),

-- February 2024 - Furniture
(26, '2024-02-04', 'East', 'Furniture', 'Desk', 'Sarah Johnson', 4, 450.00, 1800.00),
(27, '2024-02-07', 'West', 'Furniture', 'Chair', 'Lisa Davis', 12, 150.00, 1800.00),
(28, '2024-02-11', 'East', 'Furniture', 'Cabinet', 'John Smith', 2, 800.00, 1600.00),
(29, '2024-02-16', 'West', 'Furniture', 'Desk', 'Mike Brown', 5, 450.00, 2250.00),
(30, '2024-02-20', 'East', 'Furniture', 'Chair', 'Sarah Johnson', 8, 150.00, 1200.00),

-- March 2024 - Electronics - East Region
(31, '2024-03-01', 'East', 'Electronics', 'Laptop', 'John Smith', 3, 1200.00, 3600.00),
(32, '2024-03-05', 'East', 'Electronics', 'Monitor', 'Sarah Johnson', 6, 300.00, 1800.00),
(33, '2024-03-08', 'East', 'Electronics', 'Tablet', 'John Smith', 4, 500.00, 2000.00),
(34, '2024-03-12', 'East', 'Electronics', 'Mouse', 'Sarah Johnson', 10, 25.00, 250.00),
(35, '2024-03-15', 'East', 'Electronics', 'Keyboard', 'John Smith', 7, 75.00, 525.00),

-- March 2024 - Electronics - West Region
(36, '2024-03-02', 'West', 'Electronics', 'Laptop', 'Mike Brown', 6, 1200.00, 7200.00),
(37, '2024-03-06', 'West', 'Electronics', 'Headphones', 'Lisa Davis', 15, 50.00, 750.00),
(38, '2024-03-09', 'West', 'Electronics', 'Monitor', 'Mike Brown', 4, 300.00, 1200.00),
(39, '2024-03-13', 'West', 'Electronics', 'Tablet', 'Lisa Davis', 7, 500.00, 3500.00),
(40, '2024-03-17', 'West', 'Electronics', 'Mouse', 'Mike Brown', 8, 25.00, 200.00),

-- March 2024 - Furniture
(41, '2024-03-03', 'East', 'Furniture', 'Chair', 'John Smith', 15, 150.00, 2250.00),
(42, '2024-03-07', 'West', 'Furniture', 'Desk', 'Lisa Davis', 6, 450.00, 2700.00),
(43, '2024-03-11', 'East', 'Furniture', 'Cabinet', 'Sarah Johnson', 3, 800.00, 2400.00),
(44, '2024-03-14', 'West', 'Furniture', 'Chair', 'Mike Brown', 10, 150.00, 1500.00),
(45, '2024-03-18', 'East', 'Furniture', 'Desk', 'John Smith', 4, 450.00, 1800.00),

-- April 2024 - Electronics - East Region
(46, '2024-04-02', 'East', 'Electronics', 'Laptop', 'Sarah Johnson', 7, 1200.00, 8400.00),
(47, '2024-04-06', 'East', 'Electronics', 'Monitor', 'John Smith', 5, 300.00, 1500.00),
(48, '2024-04-10', 'East', 'Electronics', 'Keyboard', 'Sarah Johnson', 8, 75.00, 600.00),
(49, '2024-04-14', 'East', 'Electronics', 'Mouse', 'John Smith', 12, 25.00, 300.00),
(50, '2024-04-18', 'East', 'Electronics', 'Tablet', 'Sarah Johnson', 5, 500.00, 2500.00),

-- April 2024 - Electronics - West Region
(51, '2024-04-03', 'West', 'Electronics', 'Laptop', 'Mike Brown', 8, 1200.00, 9600.00),
(52, '2024-04-07', 'West', 'Electronics', 'Headphones', 'Lisa Davis', 18, 50.00, 900.00),
(53, '2024-04-11', 'West', 'Electronics', 'Monitor', 'Mike Brown', 6, 300.00, 1800.00),
(54, '2024-04-15', 'West', 'Electronics', 'Tablet', 'Lisa Davis', 9, 500.00, 4500.00),
(55, '2024-04-19', 'West', 'Electronics', 'Keyboard', 'Mike Brown', 10, 75.00, 750.00),

-- April 2024 - Furniture
(56, '2024-04-04', 'East', 'Furniture', 'Desk', 'John Smith', 7, 450.00, 3150.00),
(57, '2024-04-08', 'West', 'Furniture', 'Chair', 'Lisa Davis', 14, 150.00, 2100.00),
(58, '2024-04-12', 'East', 'Furniture', 'Cabinet', 'Sarah Johnson', 4, 800.00, 3200.00),
(59, '2024-04-16', 'West', 'Furniture', 'Desk', 'Mike Brown', 8, 450.00, 3600.00),
(60, '2024-04-20', 'East', 'Furniture', 'Chair', 'John Smith', 12, 150.00, 1800.00),

-- South Region - May 2024
(61, '2024-05-02', 'South', 'Electronics', 'Laptop', 'Tom Wilson', 5, 1200.00, 6000.00),
(62, '2024-05-05', 'South', 'Electronics', 'Monitor', 'Amy Chen', 4, 300.00, 1200.00),
(63, '2024-05-08', 'South', 'Electronics', 'Tablet', 'Tom Wilson', 6, 500.00, 3000.00),
(64, '2024-05-12', 'South', 'Furniture', 'Chair', 'Amy Chen', 10, 150.00, 1500.00),
(65, '2024-05-15', 'South', 'Furniture', 'Desk', 'Tom Wilson', 5, 450.00, 2250.00),

-- North Region - May 2024
(66, '2024-05-03', 'North', 'Electronics', 'Laptop', 'David Lee', 4, 1200.00, 4800.00),
(67, '2024-05-06', 'North', 'Electronics', 'Keyboard', 'Emma White', 8, 75.00, 600.00),
(68, '2024-05-09', 'North', 'Electronics', 'Mouse', 'David Lee', 15, 25.00, 375.00),
(69, '2024-05-13', 'North', 'Furniture', 'Cabinet', 'Emma White', 3, 800.00, 2400.00),
(70, '2024-05-16', 'North', 'Furniture', 'Chair', 'David Lee', 9, 150.00, 1350.00);

GO

-- ================================================================
-- WINDOW FUNCTION EXAMPLES & PRACTICE QUERIES
-- ================================================================

PRINT '========================================';
PRINT 'WINDOW AGGREGATION FUNCTION EXAMPLES';
PRINT '========================================';
PRINT '';

-- 1. ROW_NUMBER() - Assign sequential numbers
PRINT '1. ROW_NUMBER - Rank sales by amount within each region';
SELECT 
    Region,
    Salesperson,
    SaleDate,
    TotalAmount,
    ROW_NUMBER() OVER (PARTITION BY Region ORDER BY TotalAmount DESC) AS RowNum
FROM Sales
ORDER BY Region, RowNum;

PRINT '';
PRINT '----------------------------------------';
PRINT '';

-- 2. RANK() and DENSE_RANK() - Ranking with ties
PRINT '2. RANK vs DENSE_RANK - Compare ranking methods';
SELECT 
    ProductCategory,
    ProductName,
    TotalAmount,
    RANK() OVER (PARTITION BY ProductCategory ORDER BY TotalAmount DESC) AS RankNum,
    DENSE_RANK() OVER (PARTITION BY ProductCategory ORDER BY TotalAmount DESC) AS DenseRankNum
FROM Sales
ORDER BY ProductCategory, TotalAmount DESC;

PRINT '';
PRINT '----------------------------------------';
PRINT '';

-- 3. SUM() OVER - Running totals
PRINT '3. Running Total - Cumulative sales by date for each region';
SELECT 
    Region,
    SaleDate,
    TotalAmount,
    SUM(TotalAmount) OVER (PARTITION BY Region ORDER BY SaleDate) AS RunningTotal
FROM Sales
ORDER BY Region, SaleDate;

PRINT '';
PRINT '----------------------------------------';
PRINT '';

-- 4. AVG() OVER - Moving average
PRINT '4. Moving Average - 3-row moving average of sales';
SELECT 
    SaleDate,
    Region,
    TotalAmount,
    AVG(TotalAmount) OVER (
        PARTITION BY Region 
        ORDER BY SaleDate 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAvg3
FROM Sales
ORDER BY Region, SaleDate;

PRINT '';
PRINT '----------------------------------------';
PRINT '';

-- 5. LAG() and LEAD() - Access previous/next rows
PRINT '5. LAG and LEAD - Compare with previous and next sale';
SELECT 
    Salesperson,
    SaleDate,
    TotalAmount,
    LAG(TotalAmount) OVER (PARTITION BY Salesperson ORDER BY SaleDate) AS PreviousSale,
    LEAD(TotalAmount) OVER (PARTITION BY Salesperson ORDER BY SaleDate) AS NextSale,
    TotalAmount - LAG(TotalAmount) OVER (PARTITION BY Salesperson ORDER BY SaleDate) AS SalesDiff
FROM Sales
WHERE Salesperson IN ('John Smith', 'Mike Brown')
ORDER BY Salesperson, SaleDate;

PRINT '';
PRINT '----------------------------------------';
PRINT '';

-- 6. FIRST_VALUE() and LAST_VALUE() - First and last in window
PRINT '6. FIRST_VALUE and LAST_VALUE - Compare with best sale in category';
SELECT 
    ProductCategory,
    ProductName,
    TotalAmount,
    FIRST_VALUE(TotalAmount) OVER (
        PARTITION BY ProductCategory 
        ORDER BY TotalAmount DESC
    ) AS HighestSaleInCategory,
    LAST_VALUE(TotalAmount) OVER (
        PARTITION BY ProductCategory 
        ORDER BY TotalAmount DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS LowestSaleInCategory
FROM Sales
ORDER BY ProductCategory, TotalAmount DESC;

PRINT '';
PRINT '----------------------------------------';
PRINT '';

-- 7. Percent of Total
PRINT '7. Percentage of Total - Sales contribution by region';
SELECT 
    Region,
    SUM(TotalAmount) AS RegionTotal,
    SUM(SUM(TotalAmount)) OVER () AS GrandTotal,
    CAST(SUM(TotalAmount) * 100.0 / SUM(SUM(TotalAmount)) OVER () AS DECIMAL(5,2)) AS PercentOfTotal
FROM Sales
GROUP BY Region
ORDER BY RegionTotal DESC;

PRINT '';
PRINT '----------------------------------------';
PRINT '';

-- 8. Top N per group
PRINT '8. Top 3 Products by Sales in Each Category';
WITH RankedProducts AS (
    SELECT 
        ProductCategory,
        ProductName,
        SUM(TotalAmount) AS TotalSales,
        ROW_NUMBER() OVER (PARTITION BY ProductCategory ORDER BY SUM(TotalAmount) DESC) AS Rank
    FROM Sales
    GROUP BY ProductCategory, ProductName
)
SELECT 
    ProductCategory,
    ProductName,
    TotalSales,
    Rank
FROM RankedProducts
WHERE Rank <= 3
ORDER BY ProductCategory, Rank;

PRINT '';
PRINT '----------------------------------------';
PRINT '';

-- 9. Month-over-Month Growth
PRINT '9. Month-over-Month Sales Growth';
WITH MonthlySales AS (
    SELECT 
        FORMAT(SaleDate, 'yyyy-MM') AS Month,
        SUM(TotalAmount) AS MonthlyTotal
    FROM Sales
    GROUP BY FORMAT(SaleDate, 'yyyy-MM')
)
SELECT 
    Month,
    MonthlyTotal,
    LAG(MonthlyTotal) OVER (ORDER BY Month) AS PreviousMonth,
    MonthlyTotal - LAG(MonthlyTotal) OVER (ORDER BY Month) AS Growth,
    CASE 
        WHEN LAG(MonthlyTotal) OVER (ORDER BY Month) IS NOT NULL 
        THEN CAST((MonthlyTotal - LAG(MonthlyTotal) OVER (ORDER BY Month)) * 100.0 / 
                  LAG(MonthlyTotal) OVER (ORDER BY Month) AS DECIMAL(5,2))
        ELSE NULL 
    END AS GrowthPercent
FROM MonthlySales
ORDER BY Month;

PRINT '';
PRINT '----------------------------------------';
PRINT '';

-- 10. NTILE - Divide into quartiles
PRINT '10. Sales Quartiles - Divide sales into 4 equal groups';
SELECT 
    SaleID,
    Salesperson,
    TotalAmount,
    NTILE(4) OVER (ORDER BY TotalAmount) AS Quartile
FROM Sales
ORDER BY TotalAmount DESC;

GO

PRINT '';
PRINT '========================================';
PRINT 'Dataset created and examples executed!';
PRINT 'You can now practice with the Sales table.';
PRINT '========================================';
