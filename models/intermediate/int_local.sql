with 

endereco as (
    select * from {{ ref('stg_person_address') }}
),

estado as (
    select * from {{ ref('stg_person_stateprovince') }}
),

pais as (
    select * from {{ ref('stg_person_countryregion') }}
),

juntado as (
    select
        endereco.pk_endereco
        , endereco.cidade
        , estado.pk_estado
        , estado.nome_estado
        , pais.pk_pais
        , pais.nome_pais
    from endereco
    left join estado
        on endereco.fk_estado = estado.pk_estado
    left join pais 
        on estado.fk_pais = pais.pk_pais
)

select * from juntado