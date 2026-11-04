with

source as (
    select * from {{ source('adventure_works', 'sales_customer') }}
),

renamed as (
    select
        customerid as pk_cliente
        , personid as fk_pessoa
        , storeid as fk_loja
        , territoryid as fk_territorio
    from source
)

select * from renamed