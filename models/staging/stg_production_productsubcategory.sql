with

source as (
    select * from {{ source('adventure_works', 'production_productsubcategory') }}
),

renamed as (
    select
        productsubcategoryid as pk_subcategoria
        , productcategoryid as fk_categoria
        , name as nome_subcategoria
    from source
)

select * from renamed