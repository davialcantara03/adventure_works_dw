with total as (
    select round(sum(total_bruto_linha), 2) as vendas_brutas_2011
    from {{ ref('fct_vendas') }}
    where year(data_pedido) = 2011
)

select *
from total
where vendas_brutas_2011 != 12646112.16