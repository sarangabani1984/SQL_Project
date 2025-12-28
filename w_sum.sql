select 
ProductCategory,
ProductName,
sum(UnitPrice) over(PARTITION BY ProductCategory) salesbyprodcat,
sum(UnitPrice) over(PARTITION BY ProductName) salesbyprod 
from Sales;

select 
SaleID,
ProductCategory,
TotalAmount, 
sum(TotalAmount) over() as TotalSalesAll,
ROUND(CAST(TotalAmount AS FLOAT)/sum(TotalAmount) over()* 100, 2) as SalesProportion
from Sales ORDER BY SalesProportion DESC;

## this use case shows part to whole analysis using window functions, shows the contribution of each sale to the overall sales total.
