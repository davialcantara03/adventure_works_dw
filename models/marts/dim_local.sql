with

localidade as (
    select * from {{ ref('int_local') }}
),

final as (
    select
        pk_endereco
        , cidade
        , nome_estado
        , nome_pais
    from localidade
)

select * from final