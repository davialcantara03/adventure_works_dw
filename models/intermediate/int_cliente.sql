with 

cliente as (
    select * from {{ ref('stg_sales_customer')}}
),

pessoa as (
    select * from {{ ref('stg_person_person')}}
),

juntado as (
    select
        cliente.pk_cliente
        , cliente.fk_pessoa
        , cliente.fk_loja
        , cliente.fk_territorio
        , pessoa.pk_pessoa
        , pessoa.tipo_pessoa
        , pessoa.primeiro_nome
        , pessoa.sobrenome
        , pessoa.nome_completo
    from cliente
    left join pessoa
        on cliente.fk_pessoa = pessoa.pk_pessoa
)

select * from juntado