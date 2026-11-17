
select
    to_date(data, 'DD/MM/YYYY') as data_ref,
    nullif(replace(valor, ',', '.'), '')::numeric as divida_liquida_pct_pib
from "prism"."raw"."divida_liquida_pib"
