
  
    

  create  table "prism"."analytics_marts"."mart_risco_divida__dbt_tmp"
  
  
    as
  
  (
    with t as (select * from "prism"."analytics"."risk_thresholds"),
base as (
    select
        i.*,
        
case
    when i.divida_bruta_pct_pib is null then null
    when i.divida_bruta_pct_pib >= t.divida_vermelho then 2
    when i.divida_bruta_pct_pib >= t.divida_amarelo then 1
    else 0
end
 as nivel_divida,
        
case
    when i.juros_reais_pct is null then null
    when i.juros_reais_pct >= t.juros_vermelho then 2
    when i.juros_reais_pct >= t.juros_amarelo then 1
    else 0
end
 as nivel_juros,
        
case
    when i.diferencial_r_g_pp is null then null
    when i.diferencial_r_g_pp >= t.rg_vermelho then 2
    when i.diferencial_r_g_pp >= t.rg_amarelo then 1
    else 0
end
 as nivel_r_g
    from "prism"."analytics_intermediate"."int_indicadores_mensais" i
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
  );
  