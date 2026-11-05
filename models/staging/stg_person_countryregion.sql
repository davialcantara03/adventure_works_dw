with 

source as (
    select * from {{ source('adventure_works', 'person_countryregion')}}
),

renamed as (
    select
        countryregioncode as pk_pais_original
        , coalesce(countryregioncode, 'NA') as pk_pais
        , name as nome_pais
from source
)

select * from renamed
