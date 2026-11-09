with

vendedor as (
    select * from {{ ref('int_vendedor') }}
),

final as (
    select
        pk_vendedor
        , nome_completo
        , fk_territorio
    from vendedor
)

select * from final