
  create view "prism"."analytics_staging"."stg_selic_meta__dbt_tmp"
    
    
  as (
    
select
    to_date(data, 'DD/MM/YYYY') as data_ref,
    nullif(replace(valor, ',', '.'), '')::numeric as selic_meta_aa
from "prism"."raw"."selic_meta"

  );