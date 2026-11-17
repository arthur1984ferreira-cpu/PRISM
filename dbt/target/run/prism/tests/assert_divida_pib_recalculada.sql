
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  select
    o.data_ref,
    o.divida_bruta_pct_pib as oficial,
    r.divida_bruta_rs_mi / p.pib_12m_rs_mi * 100 as recalculado
from "prism"."analytics_staging"."stg_divida_bruta_pib" o
join "prism"."analytics_staging"."stg_divida_bruta_rs" r on r.data_ref = o.data_ref
join "prism"."analytics_staging"."stg_pib_12m" p on p.data_ref = o.data_ref
where abs(o.divida_bruta_pct_pib - r.divida_bruta_rs_mi / p.pib_12m_rs_mi * 100) > 0.1
  
  
      
    ) dbt_internal_test