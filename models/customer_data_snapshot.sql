{%- set loaded_dates = get_loaded_dates() -%}

{% for loaded_date in loaded_dates %}

  select {{ loaded_date }} {% if not loop.last %} union all {% endif %}

{% endfor %}