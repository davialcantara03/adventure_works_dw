with

source as (
    select * from {{ source('adventure_works', 'person_person') }}
),

renamed as (
    select
        businessentityid as pk_pessoa
        , persontype as tipo_pessoa
        , firstname as primeiro_nome
        , lastname as sobrenome
        , concat(firstname, ' ', lastname) as nome_completo
    from source

)

select * from renamed