
---Quality Check 
--duplicate
SELECT prd_id, count(*) FROM silver.crm_prd_info group by prd_id having count(*)>1 ;
SELECT prd_id, count(*) FROM silver.crm_prd_info group by prd_id having count(*)>1 ;

--Check the white space
SELECT prd_nm FROM silver.crm_prd_info where prd_nm != trim(prd_nm);


--Check the Null or Negative 
SELECT prd_cost from silver.crm_prd_info where prd_cost<0 or prd_cost is null ;

--Check the invalid date Orders
-- data standardization & consistency 
SELECT distinct prd_line from silver.crm_prd_info 

-- check the invalid date Orders
select * from silver.crm_prd_info where prd_end_dt<prd_start_dt;

--- Transformation 
-- Derived new columns 
-- handling missing iformation ( Instead of Null we changing into 0)
-- Data Normalizatoin ( case when like more friend word convestion) 
-- Data Enrichment
-- (using Lead function corrected dates, add new relavnt data to enhance the dataset for analysis)


