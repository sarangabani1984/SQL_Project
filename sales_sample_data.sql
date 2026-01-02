-- Create Sales table for window functions practice
DROP  TABLE IF EXISTS Sales;
DROP  TABLE IF EXISTS Sales1;
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    ProductCategory VARCHAR(50),
    ProductName VARCHAR(50),
    Saledate DATE,
    UnitPrice DECIMAL(10,2)
);

-- Create Sales1 table for window functions practice
CREATE TABLE Sales1 (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(50),
    Saledate DATE,
    TotalAmount DECIMAL(10,2)
);

-- Insert sample data into Sales
INSERT INTO Sales (ProductCategory, ProductName, Saledate, UnitPrice) VALUES
('Electronics', 'Laptop', '2024-01-01', 1200.00),
('Electronics', 'Laptop', '2024-01-05', 1250.00),
('Electronics', 'Laptop', '2024-01-10', 1150.00),
('Electronics', 'Laptop', '2024-01-15', 1300.00),
('Electronics', 'Laptop', '2024-01-20', 1280.00),
('Electronics', 'Mouse', '2024-01-02', 25.00),
('Electronics', 'Mouse', '2024-01-08', 30.00),
('Electronics', 'Mouse', '2024-01-12', 28.00),
('Electronics', 'Mouse', '2024-01-18', 32.00),
('Electronics', 'Keyboard', '2024-01-03', 75.00),
('Electronics', 'Keyboard', '2024-01-09', 80.00),
('Electronics', 'Keyboard', '2024-01-14', 78.00),
('Electronics', 'Keyboard', '2024-01-22', 85.00),
('Furniture', 'Desk', '2024-01-04', 350.00),
('Furniture', 'Desk', '2024-01-11', 380.00),
('Furniture', 'Desk', '2024-01-16', 360.00),
('Furniture', 'Chair', '2024-01-06', 150.00),
('Furniture', 'Chair', '2024-01-13', 160.00),
('Furniture', 'Chair', '2024-01-19', 155.00),
('Furniture', 'Chair', '2024-01-25', 165.00),
('Clothing', 'Shirt', '2024-01-07', 45.00),
('Clothing', 'Shirt', '2024-01-14', 50.00),
('Clothing', 'Shirt', '2024-01-21', 48.00),
('Clothing', 'Pants', '2024-01-08', 65.00),
('Clothing', 'Pants', '2024-01-17', 70.00),
('Clothing', 'Pants', '2024-01-24', 68.00);

-- Insert sample data into Sales1
INSERT INTO Sales1 (ProductName, Saledate, TotalAmount) VALUES
('Laptop', '2024-01-01', 2400.00),
('Laptop', '2024-01-05', 3750.00),
('Laptop', '2024-01-10', 2300.00),
('Laptop', '2024-01-15', 5200.00),
('Laptop', '2024-01-20', 3840.00),
('Laptop', '2024-01-25', 6400.00),
('Mouse', '2024-01-02', 75.00),
('Mouse', '2024-01-08', 120.00),
('Mouse', '2024-01-12', 84.00),
('Mouse', '2024-01-18', 160.00),
('Mouse', '2024-01-23', 96.00),
('Keyboard', '2024-01-03', 225.00),
('Keyboard', '2024-01-09', 320.00),
('Keyboard', '2024-01-14', 234.00),
('Keyboard', '2024-01-22', 340.00),
('Desk', '2024-01-04', 1050.00),
('Desk', '2024-01-11', 1520.00),
('Desk', '2024-01-16', 1080.00),
('Desk', '2024-01-28', 1900.00),
('Chair', '2024-01-06', 450.00),
('Chair', '2024-01-13', 640.00),
('Chair', '2024-01-19', 465.00),
('Chair', '2024-01-25', 825.00),
('Shirt', '2024-01-07', 180.00),
('Shirt', '2024-01-14', 250.00),
('Shirt', '2024-01-21', 192.00),
('Shirt', '2024-01-29', 270.00),
('Pants', '2024-01-08', 260.00),
('Pants', '2024-01-17', 350.00),
('Pants', '2024-01-24', 272.00);

-- Verify data
SELECT 'Sales Table' as TableName, COUNT(*) as RecordCount FROM Sales
UNION ALL
SELECT 'Sales1 Table', COUNT(*) FROM Sales1;
