
    
    

select
    data_ref as unique_field,
    count(*) as n_records

from "prism"."analytics_staging"."stg_selic_meta"
where data_ref is not null
group by data_ref
having count(*) > 1


