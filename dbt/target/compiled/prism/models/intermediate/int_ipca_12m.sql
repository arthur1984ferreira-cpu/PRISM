with base as (
    select
        date_trunc('month', data_ref)::date as mes,
        ln(1 + ipca_mensal_pct / 100) as ln_ipca
    from "prism"."analytics_staging"."stg_ipca_mensal"
),
acum as (
    select
        mes,
        sum(ln_ipca) over (order by mes rows between 11 preceding and current row) as soma_ln,
        count(*) over (order by mes rows between 11 preceding and current row) as n
    from base
)
select mes, (exp(soma_ln) - 1) * 100 as ipca_12m_pct
from acum
where n = 12