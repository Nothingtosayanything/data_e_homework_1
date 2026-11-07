with item_totals as (
    select order_id, sum(line_amount) as items_amount
    from {{ ref('fct_order_items') }}
    group by order_id
)

select
    o.order_id,
    o.order_amount,
    i.items_amount
from {{ ref('fct_orders') }} as o
left join item_totals as i on i.order_id = o.order_id
where o.order_amount is distinct from i.items_amount