with

source as (
    select * from {{ source('adventure_works', 'sales_store') }}
),

renamed as (
    select
        businessentityid as pk_loja
        , name as nome_loja
    from source
)

select * from renamed