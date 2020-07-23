{% snapshot customer_data_snapshot_timestamp %}

    {{
        config(
          target_schema='homework',
          strategy='timestamp',
          unique_key='customer_id',
          updated_at='load_date',
        )
    }}

    select * from {{ source('homework__loading', 'customer_stage') }}

{% endsnapshot %}