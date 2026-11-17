
select
    to_date(data, 'DD/MM/YYYY') as data_ref,
    nullif(replace(valor, ',', '.'), '')::numeric as ipca_mensal_pct
from "prism"."raw"."ipca_mensal"
