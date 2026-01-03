
SELECT
    EmployeeID,
    EmployeeName,
    Department,
    Region,
    Sales,
    ROW_NUMBER() OVER (ORDER BY Sales DESC) AS RowNum,
    RANK() OVER (ORDER BY Sales DESC) AS RankNum,
    DENSE_RANK() OVER (ORDER BY Sales DESC) AS DenseRankNum,
    NTILE(4) OVER (ORDER BY Sales DESC) AS SalesQuartile
    
FROM SalesPerformance ;