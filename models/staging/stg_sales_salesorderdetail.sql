with

source as (

    select * from {{ source('adventure_works', 'sales_salesorderdetail') }}

),

renamed as (
    select
        salesorderdetailid as pk_pedido_item
        , salesorderid as fk_pedido
        , productid as fk_produto
        , specialofferid as fk_oferta
        , cast(orderqty as integer) as quantidade
        , cast(unitprice as decimal(18, 2)) as preco_unitario
        , cast(unitpricediscount as decimal(18, 2)) as desconto_unitario

from source

)

select * from renamed