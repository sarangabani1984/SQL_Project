DROP TABLE IF EXISTS SalesPerformance;

CREATE TABLE SalesPerformance (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(30),
    Region VARCHAR(20),
    Sales DECIMAL(10, 2),
    Quarter VARCHAR(10),
    Year INT
);

INSERT INTO SalesPerformance (EmployeeID, EmployeeName, Department, Region, Sales, Quarter, Year) VALUES
-- Sales Department - North Region
(101, 'John Smith', 'Sales', 'North', 85000.00, 'Q1', 2024),
(102, 'Sarah Johnson', 'Sales', 'North', 92000.00, 'Q1', 2024),
(103, 'Mike Davis', 'Sales', 'North', 78000.00, 'Q1', 2024),
(104, 'Emily Brown', 'Sales', 'North', 92000.00, 'Q1', 2024),  -- Duplicate sales value
(105, 'David Wilson', 'Sales', 'North', 67000.00, 'Q1', 2024),

-- Sales Department - South Region
(106, 'Lisa Anderson', 'Sales', 'South', 95000.00, 'Q1', 2024),
(107, 'Tom Martinez', 'Sales', 'South', 88000.00, 'Q1', 2024),
(108, 'Amy Taylor', 'Sales', 'South', 91000.00, 'Q1', 2024),
(109, 'Chris Garcia', 'Sales', 'South', 88000.00, 'Q1', 2024),  -- Duplicate sales value
(110, 'Jennifer Lee', 'Sales', 'South', 73000.00, 'Q1', 2024),

-- Marketing Department - North Region
(201, 'Robert White', 'Marketing', 'North', 72000.00, 'Q1', 2024),
(202, 'Maria Rodriguez', 'Marketing', 'North', 81000.00, 'Q1', 2024),
(203, 'James Moore', 'Marketing', 'North', 69000.00, 'Q1', 2024),
(204, 'Patricia Martin', 'Marketing', 'North', 81000.00, 'Q1', 2024),  -- Duplicate

-- Marketing Department - South Region
(205, 'Daniel Clark', 'Marketing', 'South', 76000.00, 'Q1', 2024),
(206, 'Linda Lewis', 'Marketing', 'South', 83000.00, 'Q1', 2024),
(207, 'Mark Walker', 'Marketing', 'South', 79000.00, 'Q1', 2024),

-- Q2 Data for time-series practice
(101, 'John Smith', 'Sales', 'North', 90000.00, 'Q2', 2024),
(102, 'Sarah Johnson', 'Sales', 'North', 95000.00, 'Q2', 2024),
(106, 'Lisa Anderson', 'Sales', 'South', 98000.00, 'Q2', 2024),
(201, 'Robert White', 'Marketing', 'North', 75000.00, 'Q2', 2024);

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