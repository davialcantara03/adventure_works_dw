with 

source as (
    select * from {{ source('adventure_works', 'sales_salesperson')}}
),

renamed as (
    select 
        businessentityid as pk_vendedor
        , territoryid as pk_territorio
        , salesquota as meta_vendas
        , bonus as valor_bonus
    from source
)

select * from renamed
