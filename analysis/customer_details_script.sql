{%- set loaded_dates = get_loaded_dates() -%}

{% for loaded_date in loaded_dates %}

  update homework.customer_details hcd
  set valid_to = '{{ loaded_date }}'  
  where exists (
                    select null 
                    from homework.customer_details hcd2
                    where hcd.orig_customer_id = hcd2.orig_customer_id
                )
    and exists (
                  select null
                  from homework__loading.customer_stage hlcs
                  where parse_date('%d/%m/%Y', hlcs.load_date) = '{{ loaded_date }}'
                    and hcd.orig_customer_id = hlcs.customer_id
               )
    and valid_to is null;

  -- For the new data
  insert into homework.customer_details (
      customer_id,
      orig_customer_id,
      first_name,
      last_name,
      county,
      post_code,      
      valid_from
  )
  with max_customer_ids as (
        select coalesce(max(customer_id), 0) as max_customer_id
        from homework.customer_details
      )
  select row_number() over() + max_customer_id as customer_id, 
        hlcs.customer_id as orig_customer_id,
        hlcs.first_name ,
        hlcs.last_name,
        hlcs.county,
        hlcs.postal as post_code,
        parse_date('%d/%m/%Y', hlcs.load_date) as loaded_date
  from homework__loading.customer_stage hlcs,
        max_customer_ids
  where parse_date('%d/%m/%Y', hlcs.load_date) = '{{ loaded_date }}'
    and not exists (
                    select null 
                    from homework.customer_details
                    where orig_customer_id = hlcs.customer_id
    );

{% endfor %}