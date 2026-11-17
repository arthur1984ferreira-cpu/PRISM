
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select divida_bruta_pct_pib
from "prism"."analytics_staging"."stg_divida_bruta_pib"
where divida_bruta_pct_pib is null



  
  
      
    ) dbt_internal_test