
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select mes
from "prism"."analytics_marts"."mart_risco_divida"
where mes is null



  
  
      
    ) dbt_internal_test