{{ config(distributed_replicated=true)}}

select
DISTINCT order_date,
extract(year from order_date)::int as year,
extract(month from order_date)::int as month,
extract(day from order_date)::int as day_of_month,
extract(quarter from order_date)::int as quarter,
extract(isodow from order_date)::int as day_of_week,
to_char(order_date, 'FMDay') as day_name,
extract(isodow from order_date) in (6,7) as is_weekend
from {{ ref("stg_shop__orders") }}
order by 2,3,4