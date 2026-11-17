
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select data_ref
from "prism"."analytics_staging"."stg_divida_bruta_pib"
where data_ref is null



  
  
      
    ) dbt_internal_test