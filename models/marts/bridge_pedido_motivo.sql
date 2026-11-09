with

ponte as (
    select
        fk_pedido
        , fk_motivo_venda
    from {{ ref('stg_sales_salesorderheadersalesreason') }}
)

select * from ponte