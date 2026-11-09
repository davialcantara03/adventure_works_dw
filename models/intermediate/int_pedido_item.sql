with

item as (
    select * from {{ ref('stg_sales_salesorderdetail')}}
),

cabecalho as (
    select * from {{ ref('stg_sales_salesorderheader')}}
),

juntado as (
    select
        item.pk_pedido_item
        , item.fk_pedido
        , item.fk_produto
        , item.fk_oferta
        , item.quantidade
        , item.preco_unitario
        , item.desconto_unitario
        , cabecalho.pk_pedido
        , cabecalho.fk_cliente
        , cabecalho.fk_vendedor
        , cabecalho.fk_territorio
        , cabecalho.fk_cartao
        , cabecalho.fk_endereco_entrega
        , cabecalho.data_pedido
        , cabecalho.status
        , cabecalho.subtotal
        , cabecalho.frete
        , cabecalho.total_devido
        , item.preco_unitario * item.quantidade as total_bruto_linha
        , item.preco_unitario * item.quantidade * (1 - item.desconto_unitario) as total_liquido_linha
    from item
    left join cabecalho
        on item.fk_pedido = cabecalho.pk_pedido
)

select * from juntado