-- Create Sales table with NULL values in TotalAmount
CREATE TABLE Sales1 (
    SaleID INT PRIMARY KEY,
    SaleDate DATE,
    ProductName VARCHAR(100),
    TotalAmount DECIMAL(10, 2)
);

-- Insert sample data with some NULL values in TotalAmount
INSERT INTO Sales1 (SaleID, SaleDate, ProductName, TotalAmount) VALUES
(1, '2025-01-15', 'Laptop', 1200.00),
(2, '2025-01-16', 'Mouse', 25.50),
(3, '2025-01-17', 'Laptop', NULL),
(4, '2025-01-18', 'Keyboard', 75.00),
(5, '2025-01-19', 'Mouse', 30.00),
(6, '2025-01-20', 'Laptop', 1150.00),
(7, '2025-01-21', 'Monitor', NULL),
(8, '2025-01-22', 'Keyboard', NULL),
(9, '2025-01-23', 'Mouse', 28.75),
(10, '2025-01-24', 'Monitor', 350.00),
(11, '2025-01-25', 'Laptop', 1300.00),
(12, '2025-01-26', 'Monitor', 400.00),
(13, '2025-01-27', 'Keyboard', 80.00),
(14, '2025-01-28', 'Mouse', NULL),
(15, '2025-01-29', 'Laptop', 1250.00),
(16, '2025-01-30', 'Monitor', NULL),
(17, '2025-02-01', 'Keyboard', 70.00),
(18, '2025-02-02', 'Laptop', 1180.00),
(19, '2025-02-03', 'Mouse', 32.00),
(20, '2025-02-04', 'Monitor', 380.00);

-- View the data
SELECT * FROM Sales1;

-- Check NULL values
SELECT 
    ProductName,
    COUNT(*) AS TotalRecords,
    COUNT(TotalAmount) AS NonNullRecords,
    COUNT(*) - COUNT(TotalAmount) AS NullRecords
FROM Sales
GROUP BY ProductName;

-- Handle NULLs before calculating average (Option 1: Filter out NULLs)
SELECT 
    SaleID,
    SaleDate,
    ProductName,
    TotalAmount,
    AVG(TotalAmount) OVER (PARTITION BY ProductName) AS AverageTotalAmount
FROM Sales
WHERE TotalAmount IS NOT NULL;

-- Handle NULLs before calculating average (Option 2: Replace NULLs with 0)
SELECT 
    SaleID,
    SaleDate,
    ProductName,
    COALESCE(TotalAmount, 0) AS TotalAmount,
    AVG(COALESCE(TotalAmount, 0)) OVER (PARTITION BY ProductName) AS AverageTotalAmount
FROM Sales;

-- Handle NULLs before calculating average (Option 3: Replace NULLs with product average)
WITH ProductAvg AS (
    SELECT 
        ProductName,
        AVG(TotalAmount) AS AvgAmount
    FROM Sales
    WHERE TotalAmount IS NOT NULL
    GROUP BY ProductName
)
SELECT 
    s.SaleID,
    s.SaleDate,
    s.ProductName,
    COALESCE(s.TotalAmount, pa.AvgAmount) AS TotalAmount,
    pa.AvgAmount AS ProductAverage
FROM Sales s
LEFT JOIN ProductAvg pa ON s.ProductName = pa.ProductName;
