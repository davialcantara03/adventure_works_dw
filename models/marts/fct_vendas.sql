with

itens as (
    select * from {{ ref('int_pedido_item') }}
),

final as (
    select
        pk_pedido_item
        , fk_pedido
        , fk_produto
        , fk_cliente
        , fk_vendedor
        , fk_territorio
        , fk_cartao
        , fk_endereco_entrega
        , fk_oferta
        , data_pedido
        , status
        , quantidade
        , preco_unitario
        , desconto_unitario
        , total_bruto_linha
        , total_liquido_linha
    from itens
)

select * from final