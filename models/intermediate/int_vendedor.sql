with 

vendedor as (
    select * from {{ ref('stg_sales_salesperson')}}
),

pessoa as (
    select * from {{ ref('stg_person_person')}}
),

juntado as (
    select
        vendedor.pk_vendedor
        , vendedor.fk_territorio
        , vendedor.meta_vendas
        , pessoa.nome_completo
        , pessoa.tipo_pessoa
    from vendedor
    left join pessoa
        on vendedor.pk_vendedor = pessoa.pk_pessoa
)

select * from juntado