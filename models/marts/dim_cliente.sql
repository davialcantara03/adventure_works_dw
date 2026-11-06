with 

cliente as (
    select * from {{ ref('int_cliente')}}
),

final as (
    select
        pk_cliente
        , nome_completo
        , tipo_pessoa
        , fk_territorio
    from cliente
)

select * from final