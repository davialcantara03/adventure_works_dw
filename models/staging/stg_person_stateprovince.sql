with 

source as (
    select * from {{ source('adventure_works', 'person_stateprovince')}}
),

renamed as (
    select 
        stateprovinceid as pk_estado
        , name as nome_estado
        , countryregioncode as fk_pais
        , territoryid as fk_territorio
    from source
)

select * from renamed
