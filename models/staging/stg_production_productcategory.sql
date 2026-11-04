with 

source as (
    select * from {{ source('adventure_works', 'production_productcategory')}}
),

renamed as (
    select 
        productcategoryid as pk_categoria
        , name as nome_categoria
    from source
)

select * from renamed
