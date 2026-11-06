
select
    cat.category_id,
    cat.parent_category_id,
    cat.category_name,
    parent.category_name as parent_category_name,
    coalesce(
        tp.category_name,
        parent.category_name,
        cat.category_name
    ) as root_category_name
from {{ ref('stg_shop__product_categories') }} as cat
left join {{ ref('stg_shop__product_categories') }} as parent
    on parent.category_id = cat.parent_category_id
left join {{ ref('stg_shop__product_categories') }} as tp
    on tp.category_id = parent.parent_category_id