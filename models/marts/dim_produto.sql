with

produto as (
    select * from {{ ref('int_produto') }}
),

final as (
    select
        pk_produto
        , nome_produto
        , codigo_produto
        , cor
        , nome_subcategoria
        , nome_categoria
    from produto
)

select * from final