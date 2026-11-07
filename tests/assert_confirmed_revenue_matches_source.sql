with source_total as (
    select coalesce(sum(o.total_amount), 0) as revenue
    from {{ source('shop', 'orders') }} as o
    where o.status = 'paid'
      and exists (
          select 1
          from {{ source('shop', 'payments') }} as p
          where p.order_id = o.order_id
            and p.payment_status = 'success'
            and p.amount >= 0
      )
),

mart_total as (
    select coalesce(sum(order_amount), 0) as revenue
    from {{ ref('fct_orders') }}
    where is_confirmed
)

select
    s.revenue as source_revenue,
    m.revenue as mart_revenue
from source_total as s
cross join mart_total as m
where s.revenue is distinct from m.revenue