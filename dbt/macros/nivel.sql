{% macro nivel(valor, amarelo, vermelho) %}
case
    when {{ valor }} is null then null
    when {{ valor }} >= {{ vermelho }} then 2
    when {{ valor }} >= {{ amarelo }} then 1
    else 0
end
{% endmacro %}
