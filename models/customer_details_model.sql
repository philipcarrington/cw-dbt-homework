with base_data as (
        select row_number() over() as surrogate_key,
               hlcs.customer_id,
               hlcs.first_name, 
               hlcs.last_name,
               hlcs.county,
               hlcs.postal,
               parse_date('%d/%m/%Y', hlcs.load_date) as loaded_date,
               row_number() over(partition by hlcs.customer_id order by parse_date('%d/%m/%Y', hlcs.load_date)) as customer_id_occ_no,
               row_number() over(partition by concat(hlcs.first_name, hlcs.last_name) order by parse_date('%d/%m/%Y', hlcs.load_date)) first_name_last_name_occ
        from homework__loading.customer_stage hlcs
    ),
    base_to_from as (
       select bd.*,
              next_bd.loaded_date as valid_to
       from base_data bd
          left join base_data next_bd
            on bd.customer_id = next_bd.customer_id
              and (bd.customer_id_occ_no) + 1 = next_bd.customer_id_occ_no
    )
select btf.surrogate_key,
       btf.customer_id,
       btf.first_name,
       btf.last_name,
       btf.county,
       btf.postal,
       btf.loaded_date as valid_from,
       btf.valid_to,
       btf.customer_id_occ_no as customer_id_change_no,
       btf.first_name_last_name_occ as person_occ_no       
from base_to_from btf