-- =====================================================
-- RANKING FUNCTIONS PRACTICE QUERIES
-- Run after setup_ranking_practice.sql
-- Database: RankingPractice
-- =====================================================

USE RankingPractice;
GO

PRINT 'Starting Ranking Functions Examples...';
PRINT '';
GO

-- =====================================================
-- 1. ROW_NUMBER() Examples
-- =====================================================
PRINT '=== ROW_NUMBER() - Unique Sequential Numbers ===';
PRINT '';
GO

-- Example 1a: Overall ranking
SELECT 
    EmployeeName,
    Department,
    Sales,
    ROW_NUMBER() OVER (ORDER BY Sales DESC) AS RowNum
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024;
GO

-- Example 1b: Ranking within department
SELECT 
    EmployeeName,
    Department,
    Sales,
    ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Sales DESC) AS RowNumByDept
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Department, RowNumByDept;
GO

-- =====================================================
-- 2. RANK() Examples
-- =====================================================
PRINT '';
PRINT '=== RANK() - Rankings with Gaps for Ties ===';
PRINT '';
GO

-- Example 2a: Compare ROW_NUMBER vs RANK
SELECT 
    EmployeeName,
    Department,
    Sales,
    ROW_NUMBER() OVER (ORDER BY Sales DESC) AS RowNum,
    RANK() OVER (ORDER BY Sales DESC) AS RankNum
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Sales DESC;
GO

-- Example 2b: RANK by department
SELECT 
    EmployeeName,
    Department,
    Sales,
    RANK() OVER (PARTITION BY Department ORDER BY Sales DESC) AS RankByDept
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Department, Sales DESC;
GO

-- =====================================================
-- 3. DENSE_RANK() Examples
-- =====================================================
PRINT '';
PRINT '=== DENSE_RANK() - Rankings Without Gaps ===';
PRINT '';
GO

-- Example 3a: Compare all three functions
SELECT 
    EmployeeName,
    Department,
    Sales,
    ROW_NUMBER() OVER (ORDER BY Sales DESC) AS RowNum,
    RANK() OVER (ORDER BY Sales DESC) AS RankNum,
    DENSE_RANK() OVER (ORDER BY Sales DESC) AS DenseRank
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Sales DESC;
GO

-- Example 3b: Top 3 unique sales per department
SELECT * FROM (
    SELECT 
        EmployeeName,
        Department,
        Sales,
        DENSE_RANK() OVER (PARTITION BY Department ORDER BY Sales DESC) AS DenseRank
    FROM SalesPerformance
    WHERE Quarter = 'Q1' AND Year = 2024
) AS Ranked
WHERE DenseRank <= 3
ORDER BY Department, DenseRank;
GO

-- =====================================================
-- 4. PERCENT_RANK() Examples
-- =====================================================
PRINT '';
PRINT '=== PERCENT_RANK() - Relative Position (0 to 1) ===';
PRINT '';
GO

-- Example 4a: Overall percentile ranking
SELECT 
    EmployeeName,
    Department,
    Sales,
    PERCENT_RANK() OVER (ORDER BY Sales) AS PercentRank,
    CAST(ROUND(PERCENT_RANK() OVER (ORDER BY Sales) * 100, 2) AS DECIMAL(5,2)) AS Percentile
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Sales DESC;
GO

-- Example 4b: Top 20% performers by department
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
GO

-- =====================================================
-- 5. CUME_DIST() Examples
-- =====================================================
PRINT '';
PRINT '=== CUME_DIST() - Cumulative Distribution ===';
PRINT '';
GO

-- Example 5a: Cumulative distribution
SELECT 
    EmployeeName,
    Department,
    Sales,
    CUME_DIST() OVER (ORDER BY Sales) AS CumeDist,
    CAST(ROUND(CUME_DIST() OVER (ORDER BY Sales) * 100, 2) AS DECIMAL(5,2)) AS CumeDistPercent
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Sales;
GO

-- Example 5b: Compare PERCENT_RANK vs CUME_DIST
SELECT 
    EmployeeName,
    Sales,
    CAST(PERCENT_RANK() OVER (ORDER BY Sales) AS DECIMAL(5,4)) AS PercentRank,
    CAST(CUME_DIST() OVER (ORDER BY Sales) AS DECIMAL(5,4)) AS CumeDist,
    CAST(CUME_DIST() OVER (ORDER BY Sales) - PERCENT_RANK() OVER (ORDER BY Sales) AS DECIMAL(5,4)) AS Difference
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Sales;
GO

-- =====================================================
-- 6. NTILE() Examples
-- =====================================================
PRINT '';
PRINT '=== NTILE() - Divide into Equal Buckets ===';
PRINT '';
GO

-- Example 6a: Divide into quartiles
SELECT 
    EmployeeName,
    Department,
    Sales,
    NTILE(4) OVER (ORDER BY Sales) AS Quartile
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Sales DESC;
GO

-- Example 6b: Performance categories by department
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
GO

-- =====================================================
-- COMPREHENSIVE COMPARISON
-- =====================================================
PRINT '';
PRINT '=== ALL RANKING FUNCTIONS TOGETHER ===';
PRINT '';
GO

SELECT 
    EmployeeName,
    Department,
    Sales,
    ROW_NUMBER() OVER (ORDER BY Sales DESC) AS RowNum,
    RANK() OVER (ORDER BY Sales DESC) AS Rank_Num,
    DENSE_RANK() OVER (ORDER BY Sales DESC) AS DenseRank,
    CAST(ROUND(PERCENT_RANK() OVER (ORDER BY Sales DESC) * 100, 2) AS DECIMAL(5,2)) AS PercentRank,
    CAST(ROUND(CUME_DIST() OVER (ORDER BY Sales DESC) * 100, 2) AS DECIMAL(5,2)) AS CumeDist,
    NTILE(4) OVER (ORDER BY Sales DESC) AS Quartile
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
ORDER BY Sales DESC;
GO

-- =====================================================
-- PRACTICAL USE CASES
-- =====================================================
PRINT '';
PRINT '=== PRACTICAL USE CASES ===';
PRINT '';
GO

-- Use Case 1: Top 3 earners per department
PRINT 'Use Case 1: Top 3 Earners Per Department';
SELECT * FROM (
    SELECT 
        EmployeeName,
        Department,
        Sales,
        RANK() OVER (PARTITION BY Department ORDER BY Sales DESC) AS Rank_Num
    FROM SalesPerformance
    WHERE Quarter = 'Q1' AND Year = 2024
) AS Ranked
WHERE Rank_Num <= 3
ORDER BY Department, Rank_Num;
GO

-- Use Case 2: Bottom 25% performers
PRINT '';
PRINT 'Use Case 2: Bottom 25% Performers (Need Training)';
SELECT 
    EmployeeName,
    Department,
    Sales,
    NTILE(4) OVER (PARTITION BY Department ORDER BY Sales) AS Quartile
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
    AND NTILE(4) OVER (PARTITION BY Department ORDER BY Sales) = 1
ORDER BY Department, Sales;
GO

-- Use Case 3: Outliers (top/bottom 10%)
PRINT '';
PRINT 'Use Case 3: Performance Outliers (Top/Bottom 10%)';
SELECT * FROM (
    SELECT 
        EmployeeName,
        Department,
        Sales,
        PERCENT_RANK() OVER (ORDER BY Sales DESC) AS PercentRank
    FROM SalesPerformance
    WHERE Quarter = 'Q1' AND Year = 2024
) AS Ranked
WHERE PercentRank <= 0.10 OR PercentRank >= 0.90
ORDER BY Sales DESC;
GO

-- Use Case 4: Growth tracking across quarters
PRINT '';
PRINT 'Use Case 4: Sales Growth Tracking Across Quarters';
SELECT 
    EmployeeName,
    Quarter,
    Sales,
    ROW_NUMBER() OVER (PARTITION BY EmployeeName ORDER BY Quarter) AS QuarterNum,
    RANK() OVER (PARTITION BY Quarter ORDER BY Sales DESC) AS RankByQuarter,
    Sales - LAG(Sales) OVER (PARTITION BY EmployeeName ORDER BY Quarter) AS Growth,
    CAST(ROUND((Sales - LAG(Sales) OVER (PARTITION BY EmployeeName ORDER BY Quarter)) / 
        NULLIF(LAG(Sales) OVER (PARTITION BY EmployeeName ORDER BY Quarter), 0) * 100, 2) AS DECIMAL(6,2)) AS GrowthPercent
FROM SalesPerformance
WHERE EmployeeName IN ('John Smith', 'Sarah Johnson', 'Lisa Anderson', 'Robert White')
ORDER BY EmployeeName, Quarter;
GO

PRINT '';
PRINT '==============================================';
PRINT 'All queries executed successfully!';
PRINT '==============================================';
GO
