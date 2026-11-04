with

source as (
    select * from {{ source('adventure_works', 'production_product') }}
),

renamed as (
    select
        productid as pk_produto
        , name as nome_produto
        , product_numer as codigo_produto
        , color as cor 
        , productsubcategoryid as fk_subcategoria
    from source

)

select * from renamed