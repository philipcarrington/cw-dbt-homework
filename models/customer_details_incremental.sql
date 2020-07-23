{{
    config(
        materialized='incremental'
    )
}}

select *
from homework__loading.customer_stage

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where parse_date('%d/%m/%Y', load_date) > (select max(event_time) from {{ this }})

{% endif %}