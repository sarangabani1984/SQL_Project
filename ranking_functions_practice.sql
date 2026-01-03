-- =====================================================
-- RANKING FUNCTIONS PRACTICE DATASET
-- Functions: ROW_NUMBER, RANK, DENSE_RANK, 
--            PERCENT_RANK, CUME_DIST, NTILE
-- =====================================================

-- Create sample sales performance table
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

-- Insert sample data with various scenarios
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

-- View the data
SELECT * FROM SalesPerformance ORDER BY Department, Region, Sales DESC;

-- =====================================================
-- 1. ROW_NUMBER() - Assigns unique sequential numbers
-- =====================================================
-- Use Case: Give unique ranking even for duplicate values

-- Example 1: Overall ranking by sales
SELECT 
    EmployeeName,
    Department,
    Region,
    Sales,
    ROW_NUMBER() OVER (ORDER BY Sales DESC) AS RowNum
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024;

-- Example 2: Ranking within each department
SELECT 
    EmployeeName,
    Department,
    Region,
    Sales,
    ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Sales DESC) AS RowNumByDept
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024;

-- Example 3: Ranking within department and region
SELECT 
    EmployeeName,
    Department,
    Region,
    Sales,
    ROW_NUMBER() OVER (PARTITION BY Department, Region ORDER BY Sales DESC) AS RowNumByDeptRegion
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024;

-- =====================================================
-- 2. RANK() - Assigns ranking with gaps for ties
-- =====================================================
-- Use Case: Standard competition ranking (1,2,2,4)

-- Example 1: Overall ranking (notice gaps after ties)
SELECT 
    EmployeeName,
    Department,
    Region,
    Sales,
    RANK() OVER (ORDER BY Sales DESC) AS RankNum,
    ROW_NUMBER() OVER (ORDER BY Sales DESC) AS RowNum
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024;

-- Example 2: Ranking within each department
SELECT 
    EmployeeName,
    Department,
    Sales,
    RANK() OVER (PARTITION BY Department ORDER BY Sales DESC) AS RankByDept
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024;

-- Example 3: Compare RANK vs ROW_NUMBER for ties
SELECT 
    EmployeeName,
    Department,
    Sales,
    RANK() OVER (PARTITION BY Department ORDER BY Sales DESC) AS Rank_Num,
    ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Sales DESC) AS Row_Num
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Department, Sales DESC;

-- =====================================================
-- 3. DENSE_RANK() - Assigns ranking without gaps
-- =====================================================
-- Use Case: Continuous ranking without gaps (1,2,2,3)

-- Example 1: Compare RANK vs DENSE_RANK
SELECT 
    EmployeeName,
    Department,
    Sales,
    RANK() OVER (ORDER BY Sales DESC) AS Rank_WithGaps,
    DENSE_RANK() OVER (ORDER BY Sales DESC) AS DenseRank_NoGaps,
    ROW_NUMBER() OVER (ORDER BY Sales DESC) AS RowNum_Unique
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024;

-- Example 2: Dense ranking by department
SELECT 
    EmployeeName,
    Department,
    Region,
    Sales,
    DENSE_RANK() OVER (PARTITION BY Department ORDER BY Sales DESC) AS DenseRankByDept
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024;

-- Example 3: Find top 3 unique sales values per department
SELECT * FROM (
    SELECT 
        EmployeeName,
        Department,
        Sales,
        DENSE_RANK() OVER (PARTITION BY Department ORDER BY Sales DESC) AS DenseRank
    FROM SalesPerformance
    WHERE Quarter = 'Q1' AND Year = 2024
) AS Ranked
WHERE DenseRank <= 3;

-- =====================================================
-- 4. PERCENT_RANK() - Relative rank as percentage (0 to 1)
-- =====================================================
-- Use Case: Show relative position in distribution
-- Formula: (RANK - 1) / (Total Rows - 1)

-- Example 1: Percentile ranking overall
SELECT 
    EmployeeName,
    Department,
    Sales,
    PERCENT_RANK() OVER (ORDER BY Sales) AS PercentRank,
    RANK() OVER (ORDER BY Sales) AS Rank_Num
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024;

-- Example 2: Percentile ranking by department
SELECT 
    EmployeeName,
    Department,
    Sales,
    PERCENT_RANK() OVER (PARTITION BY Department ORDER BY Sales) AS PercentRankByDept,
    ROUND(PERCENT_RANK() OVER (PARTITION BY Department ORDER BY Sales) * 100, 2) AS Percentile
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Department, Sales DESC;

-- Example 3: Identify top 20% performers by department
SELECT * FROM (
    SELECT 
        EmployeeName,
        Department,
        Sales,
        PERCENT_RANK() OVER (PARTITION BY Department ORDER BY Sales DESC) AS PercentRank
    FROM SalesPerformance
    WHERE Quarter = 'Q1' AND Year = 2024
) AS Ranked
WHERE PercentRank <= 0.20
ORDER BY Department, Sales DESC;

-- =====================================================
-- 5. CUME_DIST() - Cumulative distribution (0 to 1)
-- =====================================================
-- Use Case: Percentage of values less than or equal to current
-- Formula: (Number of rows <= current row) / (Total rows)

-- Example 1: Cumulative distribution overall
SELECT 
    EmployeeName,
    Department,
    Sales,
    CUME_DIST() OVER (ORDER BY Sales) AS CumulativeDist,
    ROUND(CUME_DIST() OVER (ORDER BY Sales) * 100, 2) AS CumDistPercent
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024;

-- Example 2: Compare PERCENT_RANK vs CUME_DIST
SELECT 
    EmployeeName,
    Department,
    Sales,
    PERCENT_RANK() OVER (ORDER BY Sales) AS PercentRank,
    CUME_DIST() OVER (ORDER BY Sales) AS CumeDist,
    CUME_DIST() OVER (ORDER BY Sales) - PERCENT_RANK() OVER (ORDER BY Sales) AS Difference
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024;

-- Example 3: Cumulative distribution by department
SELECT 
    EmployeeName,
    Department,
    Sales,
    CUME_DIST() OVER (PARTITION BY Department ORDER BY Sales) AS CumeDistByDept,
    ROUND(CUME_DIST() OVER (PARTITION BY Department ORDER BY Sales) * 100, 2) AS CumPercentile
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Department, Sales;

-- =====================================================
-- 6. NTILE() - Divide rows into N equal buckets
-- =====================================================
-- Use Case: Create quartiles, quintiles, deciles, etc.

-- Example 1: Divide into 4 quartiles
SELECT 
    EmployeeName,
    Department,
    Sales,
    NTILE(4) OVER (ORDER BY Sales) AS Quartile
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024;

-- Example 2: Divide into quartiles by department
SELECT 
    EmployeeName,
    Department,
    Sales,
    NTILE(4) OVER (PARTITION BY Department ORDER BY Sales) AS QuartileByDept
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Department, Sales DESC;

-- Example 3: Create performance tiers (Top, High, Medium, Low)
SELECT 
    EmployeeName,
    Department,
    Sales,
    NTILE(4) OVER (PARTITION BY Department ORDER BY Sales DESC) AS Tier,
    CASE 
        WHEN NTILE(4) OVER (PARTITION BY Department ORDER BY Sales DESC) = 1 THEN 'Top Performer'
        WHEN NTILE(4) OVER (PARTITION BY Department ORDER BY Sales DESC) = 2 THEN 'High Performer'
        WHEN NTILE(4) OVER (PARTITION BY Department ORDER BY Sales DESC) = 3 THEN 'Medium Performer'
        ELSE 'Needs Improvement'
    END AS PerformanceCategory
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Department, Sales DESC;

-- Example 4: Divide into 10 deciles
SELECT 
    EmployeeName,
    Department,
    Sales,
    NTILE(10) OVER (ORDER BY Sales) AS Decile
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024;

-- =====================================================
-- COMPREHENSIVE COMPARISON - ALL FUNCTIONS TOGETHER
-- =====================================================

SELECT 
    EmployeeName,
    Department,
    Region,
    Sales,
    ROW_NUMBER() OVER (ORDER BY Sales DESC) AS RowNum,
    RANK() OVER (ORDER BY Sales DESC) AS Rank_Num,
    DENSE_RANK() OVER (ORDER BY Sales DESC) AS DenseRank,
    ROUND(PERCENT_RANK() OVER (ORDER BY Sales DESC) * 100, 2) AS PercentRank,
    ROUND(CUME_DIST() OVER (ORDER BY Sales DESC) * 100, 2) AS CumeDist,
    NTILE(4) OVER (ORDER BY Sales DESC) AS Quartile
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Sales DESC;

-- =====================================================
-- PRACTICAL USE CASES
-- =====================================================

-- Use Case 1: Find top 3 earners per department
SELECT * FROM (
    SELECT 
        EmployeeName,
        Department,
        Sales,
        RANK() OVER (PARTITION BY Department ORDER BY Sales DESC) AS Rank_Num
    FROM SalesPerformance
    WHERE Quarter = 'Q1' AND Year = 2024
) AS Ranked
WHERE Rank_Num <= 3;

-- Use Case 2: Find bottom 25% performers who need training
SELECT 
    EmployeeName,
    Department,
    Sales,
    NTILE(4) OVER (PARTITION BY Department ORDER BY Sales) AS Quartile
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
    AND NTILE(4) OVER (PARTITION BY Department ORDER BY Sales) = 1;

-- Use Case 3: Paginate results (10 rows per page)
SELECT 
    EmployeeName,
    Sales,
    NTILE(2) OVER (ORDER BY Sales DESC) AS Page  -- Change to NTILE(3), NTILE(4), etc. for more pages
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Sales DESC;

-- Use Case 4: Identify outliers (top/bottom 10%)
SELECT * FROM (
    SELECT 
        EmployeeName,
        Department,
        Sales,
        PERCENT_RANK() OVER (ORDER BY Sales DESC) AS PercentRank
    FROM SalesPerformance
    WHERE Quarter = 'Q1' AND Year = 2024
) AS Ranked
WHERE PercentRank <= 0.10 OR PercentRank >= 0.90;

-- Use Case 5: Growth tracking across quarters
SELECT 
    EmployeeName,
    Quarter,
    Sales,
    ROW_NUMBER() OVER (PARTITION BY EmployeeName ORDER BY Quarter) AS QuarterNum,
    RANK() OVER (PARTITION BY Quarter ORDER BY Sales DESC) AS RankByQuarter,
    Sales - LAG(Sales) OVER (PARTITION BY EmployeeName ORDER BY Quarter) AS Growth
FROM SalesPerformance
WHERE EmployeeName IN ('John Smith', 'Sarah Johnson', 'Lisa Anderson', 'Robert White')
ORDER BY EmployeeName, Quarter;

-- =====================================================
-- PRACTICE EXERCISES
-- =====================================================

-- Exercise 1: Find the median sales value using NTILE
-- Hint: Use NTILE(2) and find the boundary

-- Exercise 2: Identify employees in the 75th percentile or higher
-- Hint: Use PERCENT_RANK or CUME_DIST

-- Exercise 3: Create a ranking that shows gaps for ties in department rankings
-- Hint: Use RANK() with PARTITION BY

-- Exercise 4: Divide each department's employees into 3 equal groups
-- Hint: Use NTILE(3) with PARTITION BY

-- Exercise 5: Find duplicate sales values and show their ranks
-- Hint: Compare ROW_NUMBER, RANK, and DENSE_RANK
