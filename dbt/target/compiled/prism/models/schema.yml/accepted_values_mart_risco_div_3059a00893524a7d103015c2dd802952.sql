
    
    

with all_values as (

    select
        semaforo as value_field,
        count(*) as n_records

    from "prism"."analytics_marts"."mart_risco_divida"
    group by semaforo

)

select *
from all_values
where value_field not in (
    'verde','amarelo','vermelho'
)


