{{ config(materialized='table') }}

select parse_date('%d/%m/%Y', load_date) as loaded_date
from `cw-dbt-homework.homework__loading.customer_stage` 
group by load_date