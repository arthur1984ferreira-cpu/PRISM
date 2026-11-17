
  create view "prism"."analytics_staging"."stg_divida_liquida_pib__dbt_tmp"
    
    
  as (
    
select
    to_date(data, 'DD/MM/YYYY') as data_ref,
    nullif(replace(valor, ',', '.'), '')::numeric as divida_liquida_pct_pib
from "prism"."raw"."divida_liquida_pib"

  );