select
    o.data_ref,
    o.divida_bruta_pct_pib as oficial,
    r.divida_bruta_rs_mi / p.pib_12m_rs_mi * 100 as recalculado
from {{ ref('stg_divida_bruta_pib') }} o
join {{ ref('stg_divida_bruta_rs') }} r on r.data_ref = o.data_ref
join {{ ref('stg_pib_12m') }} p on p.data_ref = o.data_ref
where abs(o.divida_bruta_pct_pib - r.divida_bruta_rs_mi / p.pib_12m_rs_mi * 100) > 0.1
