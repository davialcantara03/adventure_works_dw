with 

cartao as (
    select * from {{ ref('stg_sales_creditcard') }}
),

final as (
    select
        pk_cartao
        , tipo_cartao
    from cartao
)

select * from final