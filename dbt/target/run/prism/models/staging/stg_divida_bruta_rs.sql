
  create view "prism"."analytics_staging"."stg_divida_bruta_rs__dbt_tmp"
    
    
  as (
    
select
    to_date(data, 'DD/MM/YYYY') as data_ref,
    nullif(replace(valor, ',', '.'), '')::numeric as divida_bruta_rs_mi
from "prism"."raw"."divida_bruta_rs"

  );