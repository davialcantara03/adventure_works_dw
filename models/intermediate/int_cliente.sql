with

cliente as (
    select * from {{ ref('stg_sales_customer') }}
),

pessoa as (
    select * from {{ ref('stg_person_person') }}
),

loja as (
    select * from {{ ref('stg_sales_store') }}
),

juntado as (
    select
        cliente.pk_cliente
        , cliente.fk_pessoa
        , cliente.fk_loja
        , cliente.fk_territorio
        , pessoa.pk_pessoa
        , pessoa.primeiro_nome
        , pessoa.sobrenome
        , coalesce(pessoa.nome_completo, loja.nome_loja) as nome_completo
        , coalesce(
            pessoa.tipo_pessoa
            , case when cliente.fk_loja is not null then 'LJ' end
        ) as tipo_pessoa
    from cliente
    left join pessoa
        on cliente.fk_pessoa = pessoa.pk_pessoa
    left join loja
        on cliente.fk_loja = loja.pk_loja
)

select * from juntado