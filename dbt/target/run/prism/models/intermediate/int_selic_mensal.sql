
  create view "prism"."analytics_intermediate"."int_selic_mensal__dbt_tmp"
    
    
  as (
    select distinct on (date_trunc('month', data_ref))
    date_trunc('month', data_ref)::date as mes,
    selic_meta_aa
from "prism"."analytics_staging"."stg_selic_meta"
order by date_trunc('month', data_ref), data_ref desc
  );