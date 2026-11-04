with 

source as (
    select * from {{ source('adventure_works', 'person_address')}}
),

renamed as (
    select 
        addressid as pk_endereco
        , city as cidade
        , stateprovinceid as fk_estado
        , postalcode as codigo_postal
    from source
)

select * from renamed
