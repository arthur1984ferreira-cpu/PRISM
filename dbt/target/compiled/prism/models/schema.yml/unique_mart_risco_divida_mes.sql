
    
    

select
    mes as unique_field,
    count(*) as n_records

from "prism"."analytics_marts"."mart_risco_divida"
where mes is not null
group by mes
having count(*) > 1


