-- =====================================================
-- RANKING FUNCTIONS PRACTICE - DATABASE SETUP
-- Run this file to create database and sample data
-- Command: sqlcmd -S localhost -i setup_ranking_practice.sql
-- =====================================================

USE master;
GO

-- Create database if not exists
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'RankingPractice')
BEGIN
    CREATE DATABASE RankingPractice;
    PRINT 'Database RankingPractice created successfully.';
END
ELSE
BEGIN
    PRINT 'Database RankingPractice already exists.';
END
GO

USE RankingPractice;
GO

-- Drop table if exists
IF OBJECT_ID('SalesPerformance', 'U') IS NOT NULL
BEGIN
    DROP TABLE SalesPerformance;
    PRINT 'Existing SalesPerformance table dropped.';
END
GO

-- Create sales performance table
CREATE TABLE SalesPerformance (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(30),
    Region VARCHAR(20),
    Sales DECIMAL(10, 2),
    Quarter VARCHAR(10),
    Year INT
);
PRINT 'SalesPerformance table created successfully.';
GO

-- Insert sample data
INSERT INTO SalesPerformance (EmployeeID, EmployeeName, Department, Region, Sales, Quarter, Year) VALUES
-- Sales Department - North Region - Q1
(101, 'John Smith', 'Sales', 'North', 85000.00, 'Q1', 2024),
(102, 'Sarah Johnson', 'Sales', 'North', 92000.00, 'Q1', 2024),
(103, 'Mike Davis', 'Sales', 'North', 78000.00, 'Q1', 2024),
(104, 'Emily Brown', 'Sales', 'North', 92000.00, 'Q1', 2024),
(105, 'David Wilson', 'Sales', 'North', 67000.00, 'Q1', 2024),

-- Sales Department - South Region - Q1
(106, 'Lisa Anderson', 'Sales', 'South', 95000.00, 'Q1', 2024),
(107, 'Tom Martinez', 'Sales', 'South', 88000.00, 'Q1', 2024),
(108, 'Amy Taylor', 'Sales', 'South', 91000.00, 'Q1', 2024),
(109, 'Chris Garcia', 'Sales', 'South', 88000.00, 'Q1', 2024),
(110, 'Jennifer Lee', 'Sales', 'South', 73000.00, 'Q1', 2024),

-- Marketing Department - North Region - Q1
(201, 'Robert White', 'Marketing', 'North', 72000.00, 'Q1', 2024),
(202, 'Maria Rodriguez', 'Marketing', 'North', 81000.00, 'Q1', 2024),
(203, 'James Moore', 'Marketing', 'North', 69000.00, 'Q1', 2024),
(204, 'Patricia Martin', 'Marketing', 'North', 81000.00, 'Q1', 2024),

-- Marketing Department - South Region - Q1
(205, 'Daniel Clark', 'Marketing', 'South', 76000.00, 'Q1', 2024),
(206, 'Linda Lewis', 'Marketing', 'South', 83000.00, 'Q1', 2024),
(207, 'Mark Walker', 'Marketing', 'South', 79000.00, 'Q1', 2024),

-- Q2 Data for time-series practice
(101, 'John Smith', 'Sales', 'North', 90000.00, 'Q2', 2024),
(102, 'Sarah Johnson', 'Sales', 'North', 95000.00, 'Q2', 2024),
(106, 'Lisa Anderson', 'Sales', 'South', 98000.00, 'Q2', 2024),
(201, 'Robert White', 'Marketing', 'North', 75000.00, 'Q2', 2024),

-- Additional Q3 Data
(101, 'John Smith', 'Sales', 'North', 88000.00, 'Q3', 2024),
(102, 'Sarah Johnson', 'Sales', 'North', 97000.00, 'Q3', 2024),
(103, 'Mike Davis', 'Sales', 'North', 82000.00, 'Q3', 2024),
(106, 'Lisa Anderson', 'Sales', 'South', 99000.00, 'Q3', 2024),
(107, 'Tom Martinez', 'Sales', 'South', 90000.00, 'Q3', 2024),
(201, 'Robert White', 'Marketing', 'North', 78000.00, 'Q3', 2024),
(202, 'Maria Rodriguez', 'Marketing', 'North', 84000.00, 'Q3', 2024);

PRINT 'Sample data inserted successfully.';
GO

-- Verify data
SELECT COUNT(*) AS TotalRecords FROM SalesPerformance;
GO

PRINT '';
PRINT '==============================================';
PRINT 'Setup Complete!';
PRINT 'Database: RankingPractice';
PRINT 'Table: SalesPerformance';
PRINT '==============================================';
PRINT '';
PRINT 'Quick verification query:';
GO

SELECT Department, Region, COUNT(*) AS EmployeeCount, AVG(Sales) AS AvgSales
FROM SalesPerformance
WHERE Quarter = 'Q1' AND Year = 2024
GROUP BY Department, Region
ORDER BY Department, Region;
GO

select * from SalesPerformance;