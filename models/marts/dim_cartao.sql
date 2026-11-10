with

cartao as (
    select * from {{ ref('stg_sales_creditcard') }}
),

sem_cartao as (
    select
        cast(-1 as bigint) as pk_cartao
        , 'Sem cartão' as tipo_cartao
),

final as (
    select
        pk_cartao
        , tipo_cartao
    from cartao

    union all

    select
        pk_cartao
        , tipo_cartao
    from sem_cartao
)

select * from final