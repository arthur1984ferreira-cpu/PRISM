with t as (select * from {{ ref('risk_thresholds') }}),
base as (
    select
        i.*,
        {{ nivel('i.divida_bruta_pct_pib', 't.divida_amarelo', 't.divida_vermelho') }} as nivel_divida,
        {{ nivel('i.juros_reais_pct', 't.juros_amarelo', 't.juros_vermelho') }} as nivel_juros,
        {{ nivel('i.diferencial_r_g_pp', 't.rg_amarelo', 't.rg_vermelho') }} as nivel_r_g
    from {{ ref('int_indicadores_mensais') }} i
    cross join t
    where i.juros_reais_pct is not null
      and i.cresc_pib_real_pct is not null
)
select
    *,
    nivel_divida + nivel_juros + nivel_r_g as score_risco,
    case
        when nivel_divida + nivel_juros + nivel_r_g >= 4 then 'vermelho'
        when nivel_divida + nivel_juros + nivel_r_g >= 2 then 'amarelo'
        else 'verde'
    end as semaforo
from base
