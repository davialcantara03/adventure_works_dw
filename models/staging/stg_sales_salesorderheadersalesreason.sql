with

source as (
    select * from {{ source('adventure_works', 'sales_salesorderheadersalesreason') }}
),

renamed as (
    select
        salesorderid as fk_pedido
        , salesreasonid as fk_motivo_venda
    from source
)

select * from renamed