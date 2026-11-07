{{ config(distributed_replicated=true) }}

{% set orders = ref('stg_shop__orders') %}
{% set start_date = "(select min(order_date) from " ~ orders ~ ")" %}
{% set end_date = "(select max(order_date) + 1 from " ~ orders ~ ")" %}

with calendar as (
    {{ dbt_utils.date_spine(
        datepart='day',
        start_date=start_date,
        end_date=end_date
    ) }}
),

dates as (
    select date_day::date as order_date
    from calendar
)

select
    order_date,
    extract(year from order_date)::int as year,
    extract(month from order_date)::int as month,
    extract(day from order_date)::int as day_of_month,
    extract(quarter from order_date)::int as quarter,
    extract(isodow from order_date)::int as day_of_week,
    to_char(order_date, 'FMDay') as day_name,
    extract(isodow from order_date) in (6, 7) as is_weekend
from dates