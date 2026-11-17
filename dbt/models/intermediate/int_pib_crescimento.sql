select
    data_ref as mes,
    (pib_12m_rs_mi / lag(pib_12m_rs_mi, 12) over (order by data_ref) - 1) * 100
        as cresc_pib_nominal_pct
from {{ ref('stg_pib_12m') }}
