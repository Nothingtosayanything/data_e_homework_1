with first_step as (
    select *
    from {{ ref('int_orders_with_payments') }}
),
orders_with_previous as (
    select
        order_id,
        lag(order_id) over (
            partition by customer_id
            order by first_paid_at, order_id
        ) as parent_order,
        customer_id,
        first_paid_at,
        ordered_at,
        order_date,
        order_status,
        sum(is_confirmed::int) over (partition by customer_id) as confirmed_orders_count,
        sum(order_amount) over (partition by customer_id) as confirmed_revenue
    from first_step
    where is_confirmed
)
select
    ssc.*,
    ord.order_id as first_confirmed_order_id,
    ord.first_paid_at as first_confirmed_at,
    coalesce(ord.confirmed_orders_count, 0) as confirmed_orders_count,
    coalesce(ord.confirmed_revenue, 0) as confirmed_revenue,
    coalesce(ord.confirmed_orders_count, 0) > 0 as is_buyer
from {{ ref('stg_shop__customers') }} as ssc
left join orders_with_previous as ord
    on ssc.customer_id = ord.customer_id
   and ord.parent_order is null