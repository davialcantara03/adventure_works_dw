with

produto as (

    select * from {{ ref('stg_production_product') }}

),

subcategoria as (

    select * from {{ ref('stg_production_productsubcategory') }}

),

categoria as (

    select * from {{ ref('stg_production_productcategory') }}

),

juntado as (

    select
        produto.pk_produto
        , produto.nome_produto
        , produto.codigo_produto
        , produto.cor
        , subcategoria.nome_subcategoria
        , categoria.nome_categoria
    from produto
    left join subcategoria
        on produto.fk_subcategoria = subcategoria.pk_subcategoria
    left join categoria
        on subcategoria.fk_categoria = categoria.pk_categoria

)

select * from juntado