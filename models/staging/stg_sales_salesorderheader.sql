with

source as (
    select * from {{ source('adventure_works', 'sales_salesorderheader') }}
),

renamed as (
    select
        salesorderid as pk_pedido
        , customerid as fk_cliente
        , salespersonid as fk_vendedor
        , territoryid as fk_territorio
        , creditcardid as fk_cartao
        , shiptoaddressid as fk_endereco_entrega
        , cast(orderdate as date) as data_pedido
        , status
        , cast(subtotal as decimal(18, 2)) as subtotal
        , cast(freight as decimal(18, 2)) as frete
        , cast(totaldue as decimal(18, 2)) as total_devido
    from source

)

select * from renamed