
  create view "prism"."analytics_staging"."stg_pib_12m__dbt_tmp"
    
    
  as (
    
select
    to_date(data, 'DD/MM/YYYY') as data_ref,
    nullif(replace(valor, ',', '.'), '')::numeric as pib_12m_rs_mi
from "prism"."raw"."pib_12m"

  );