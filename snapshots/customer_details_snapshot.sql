{% snapshot customer_data_snapshot_timestamp %}
    -- dbt snapshot --select customer_data_snapshot_timestamp
    {{
        config(
          target_database='cw-dbt-homework',
          target_schema='homework',
          unique_key='customer_id',

          strategy='timestamp',          
          updated_at='loaded_date',
        )
    }}

    select * 
    from homework__loading.customer_to_process
    where loaded_date = (
                          select min(loaded_date)
                          from homework__loading.customer_to_process
                          where loaded_date > (
                                                select coalesce(max(dbt_valid_from), '1900-01-01')
                                                from homework.customer_data_snapshot_timestamp
                                              )
                        )

{% endsnapshot %}