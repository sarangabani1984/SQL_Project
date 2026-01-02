select * from Sales1

SELECT 
    ProductName,
    COUNT(*) AS TotalRecords,
    COUNT(TotalAmount) AS NonNullRecords,
    COUNT(*) - COUNT(TotalAmount) AS NullRecords
FROM Sales1
GROUP BY ProductName;


SELECT 
    ProductName,
    COALESCE(TotalAmount, 0) AS TotalAmount,
    AVG(TotalAmount) OVER (PARTITION BY ProductName) AS AverageTotalAmount1,
    AVG(COALESCE(TotalAmount, 0)) OVER (PARTITION BY ProductName) AS AverageTotalAmount
FROM Sales1;

SELECT * FROM (
    SELECT 
        ProductName,
        TotalAmount,
        AVG(TotalAmount) OVER (PARTITION BY ProductName) AS AvgAmount
    FROM Sales1
   
)T WHERE TotalAmount > AvgAmount;

