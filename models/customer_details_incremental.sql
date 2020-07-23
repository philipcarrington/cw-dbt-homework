{{
    config(
        materialized='incremental'
    )
}}

select *
from homework__loading.customer_stage

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where parse_date('%d/%m/%Y', load_date) = (                                              
                                              select min(parse_date('%d/%m/%Y', load_date)) 
                                              from homework__loading.customer_stage
                                              where parse_date('%d/%m/%Y', load_date) > (select max(loaded_date)
                                                                                         from {{ this }}) 
                                            )

{% endif %}