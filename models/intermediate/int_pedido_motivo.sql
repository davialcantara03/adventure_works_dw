with

ponte as (
    select * from {{ ref('stg_sales_salesorderheadersalesreason' )}}
),

motivo as (
    select * from {{ ref('stg_sales_salesreason')}}
),

juntado as (
    select
        ponte.fk_pedido
        , ponte.fk_motivo_venda
        , motivo.nome_motivo
    from ponte
    left join motivo
        on ponte.fk_motivo_venda = motivo.pk_motivo_venda
)

select * from juntado