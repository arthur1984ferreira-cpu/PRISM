{% macro stg_bcb(tabela, nome_valor) %}
select
    to_date(data, 'DD/MM/YYYY') as data_ref,
    nullif(replace(valor, ',', '.'), '')::numeric as {{ nome_valor }}
from {{ source('bcb', tabela) }}
{% endmacro %}
