with base as (
    select
        d.data_ref as mes,
        d.divida_bruta_pct_pib,
        l.divida_liquida_pct_pib,
        p.pib_12m_rs_mi,
        c.cresc_pib_nominal_pct,
        s.selic_meta_aa,
        i.ipca_12m_pct
    from "prism"."analytics_staging"."stg_divida_bruta_pib" d
    left join "prism"."analytics_staging"."stg_divida_liquida_pib" l on l.data_ref = d.data_ref
    left join "prism"."analytics_staging"."stg_pib_12m" p on p.data_ref = d.data_ref
    left join "prism"."analytics_intermediate"."int_pib_crescimento" c on c.mes = d.data_ref
    left join "prism"."analytics_intermediate"."int_selic_mensal" s on s.mes = d.data_ref
    left join "prism"."analytics_intermediate"."int_ipca_12m" i on i.mes = d.data_ref
),
calc as (
    select
        *,
        divida_bruta_pct_pib
            - lag(divida_bruta_pct_pib, 12) over (order by mes) as var_divida_12m_pp,
        ((1 + selic_meta_aa / 100) / (1 + ipca_12m_pct / 100) - 1) * 100 as juros_reais_pct,
        ((1 + cresc_pib_nominal_pct / 100) / (1 + ipca_12m_pct / 100) - 1) * 100 as cresc_pib_real_pct
    from base
)
select
    *,
    juros_reais_pct - cresc_pib_real_pct as diferencial_r_g_pp,
    divida_bruta_pct_pib
        * ((juros_reais_pct / 100 - cresc_pib_real_pct / 100) / (1 + cresc_pib_real_pct / 100))
        as primario_requerido_pct_pib
from calc