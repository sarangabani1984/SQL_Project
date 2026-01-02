
SELECT * from Sales1 ORDER BY ProductName
select 
ProductName,
min(TotalAmount) over(  )as MinTotalAmount,
max(TotalAmount) over( ) as MaxTotalAmount,
AVG(coalesce(TotalAmount, 0)) over( )as AverageTotalAmount,
AVG(coalesce(TotalAmount, 0)) over(PARTITION BY ProductName)as AverageTotalAmountbyproduct,
min(TotalAmount) over(PARTITION BY ProductName)as MinTotalAmountbyproduct,
max(TotalAmount) over(PARTITION BY ProductName) as MaxTotalAmountbyproduct,
sum(coalesce(TotalAmount, 0)) over(PARTITION BY ProductName) as SumTotalAmount,
COUNT(*) over(PARTITION BY ProductName) as Count,
COUNT(*) over() as Count,
TotalAmount
from Sales1 ;