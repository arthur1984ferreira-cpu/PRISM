
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  select max(data_ref) as ultima_data
from "prism"."analytics_staging"."stg_selic_meta"
having max(data_ref) < date '2026-06-01'
  
  
      
    ) dbt_internal_test