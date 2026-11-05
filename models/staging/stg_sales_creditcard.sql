with 

source as (
    select * from {{ source('adventure_works', 'sales_creditcard')}}
),

renamed as (
    select 
        creditcardid as pk_cartao
        , cardtype as tipo_cartao
        , cardnumber as numero_cartao
        , expmonth as mes_expiracao
        , expyear as ano_expiracao
    from source
)

select * from renamed
