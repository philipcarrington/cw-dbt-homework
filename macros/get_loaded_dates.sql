{% macro get_loaded_dates() %}

{% set loaded_dates_query %}
select parse_date('%d/%m/%Y', load_date) as loaded_date
from homework__loading.customer_stage
group by loaded_date
order by loaded_date asc
{% endset %}

{% set results = run_query(loaded_dates_query) %}

{% if execute %}
{# Return the first column #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}

{{ return(results_list) }}

{% endmacro %}