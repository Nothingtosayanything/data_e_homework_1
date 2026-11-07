{{ config(distributed_replicated=true )}}

select
    customer_id,
    registered_at,
    registration_date,
    city,
    acquisition_channel,
    first_confirmed_order_id,
    first_confirmed_at,
    confirmed_orders_count,
    confirmed_revenue,
    is_buyer
from {{ ref('int_customers') }}