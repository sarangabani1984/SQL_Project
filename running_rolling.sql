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
avg(TotalAmount) over(PARTITION BY ProductName ORDER BY Saledate) movingavg from Sales1;