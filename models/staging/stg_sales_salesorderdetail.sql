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
        , unitprice as preco_unitario
        , unitpricediscount as desconto_unitario
from source

)

select * from renamed