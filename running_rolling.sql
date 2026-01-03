select 
ProductCategory,
ProductName,
Saledate, 
unitPrice,
avg(UnitPrice) over(PARTITION BY ProductName) avgbyProduct,
avg(UnitPrice) over(PARTITION BY ProductName ORDER BY Saledate) avgbyProdCat
from Sales;

Select ProductName,
avg(TotalAmount) over(PARTITION BY ProductName),
avg(TotalAmount) over(PARTITION BY ProductName ORDER BY Saledate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW AND) movingavg from Sales1;