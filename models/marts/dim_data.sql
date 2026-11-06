with

datas as (
    select distinct
        cast(data_pedido as date) as data_pedido
    from {{ ref('stg_sales_salesorderheader') }}
    where data_pedido is not null
),

final as (
    select
        data_pedido as pk_data
        , data_pedido as data
        , year(data_pedido) as ano
        , month(data_pedido) as mes
        , date_format(data_pedido, 'yyyy-MM') as ano_mes
    from datas
)

select * from final