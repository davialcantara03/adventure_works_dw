with 

motivo as (
    select * from {{ ref('stg_sales_salesreason')}}
),

final as (
    select
        pk_motivo_venda
        , nome_motivo
        , tipo_motivo
    from motivo
)

select * from final