
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        semaforo as value_field,
        count(*) as n_records

    from "prism"."analytics_marts"."mart_risco_divida"
    group by semaforo

)

select *
from all_values
where value_field not in (
    'verde','amarelo','vermelho'
)



  
  
      
    ) dbt_internal_test