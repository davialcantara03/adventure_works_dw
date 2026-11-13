# 📊 Adventure Works: Data Warehouse e Painel de Vendas

> Projeto de **Analytics Engineering** desenvolvido na certificação **Indicium AI (Modern Analytics Stack)**. Cobre modelagem dimensional, transformação com **dbt**, testes de qualidade e painel em **Power BI**.

**Autor:** Davi Alcântara

**Vídeo:** [assistir no YouTube](URL_DO_VIDEO)

**Painel:** [CEA_AW_DAVI_dashboard.pbix](painel/CEA_AW_DAVI_dashboard.pbix)

**Diagrama:** [modelo conceitual](docs/CEA_AW_DAVI_modelo_conceitual.pdf)

---

## 📑 Sumário

1. [Objetivo e resultados](#1-objetivo-e-resultados)
2. [Arquitetura](#2-arquitetura)
3. [Modelo de dados](#3-modelo-de-dados)
4. [Decisões de modelagem e tratamento de dados](#4-decisões-de-modelagem-e-tratamento-de-dados)
5. [Qualidade de dados](#5-qualidade-de-dados)
6. [Painel Power BI](#6-painel-power-bi)
7. [Como reproduzir](#7-como-reproduzir)
8. [Limitações conhecidas](#8-limitações-conhecidas)
9. [Estrutura do repositório](#9-estrutura-do-repositório)

---

## 1. Objetivo e resultados

A Adventure Works precisa de uma base confiável para responder perguntas de vendas. O projeto constrói um **data warehouse** no schema `adventure_works` (Databricks, Unity Catalog), transforma os dados com **dbt** e entrega um **painel interativo** com as seis perguntas de negócio do enunciado.

**Principais resultados:**

- ✅ **14** modelos de staging, **7** dimensões e pontes e **1** tabela fato (`fct_vendas`, com **121.317** linhas)
- ✅ Total bruto de vendas em **2011**: **$ 12.646.112,16**, validado por teste automatizado (valor exigido pelo CEO)
- ✅ Total bruto de **2011 a 2014**: **$ 110.373.889,31**, com **31.465** pedidos e **274.914** unidades

---

## 2. Arquitetura

```
sources (adventure_works)  →  staging (stg_*)  →  intermediate (int_*)  →  marts (dim_*, fct_*, bridge_*)  →  Power BI
```

| Camada | Função |
|---|---|
| **Staging** (`stg_*`) | Um modelo por tabela de origem. Só renomeia e padroniza tipos. |
| **Intermediate** (`int_*`) | Junções e regras de negócio (ex.: `int_cliente`, `int_pedido_item`). |
| **Marts** (`dim_*`, `fct_*`, `bridge_*`) | Modelo estrela, com `fct_vendas` no grão de item de pedido. |

**Ambientes:**
- `dev.dbt_dalcantara_aw`: desenvolvimento
- `dev.prod_adventure_works`: produção, usada pelo painel

---

## 3. Modelo de dados

| Tabela | Grão | Chave primária |
|---|---|---|
| `fct_vendas` | um item de pedido | `pk_pedido_item` |
| `dim_cliente` | um cliente | `pk_cliente` |
| `dim_produto` | um produto | `pk_produto` |
| `dim_vendedor` | um vendedor | `pk_vendedor` |
| `dim_cartao` | um cartão (inclui "Sem cartão") | `pk_cartao` |
| `dim_local` | um endereço de entrega | `pk_endereco` |
| `dim_data` | um dia | `pk_data` |
| `dim_motivo_venda` | um motivo | `pk_motivo_venda` |
| `bridge_pedido_motivo` | um par pedido-motivo | `fk_pedido` + `fk_motivo_venda` |

**Métricas da fato:**

- **`total_bruto_linha`** = `preco_unitario × quantidade`
- **`total_liquido_linha`** = `preco_unitario × quantidade × (1 − desconto)`
- **Pedidos** = contagem distinta de `fk_pedido` (a coluna se repete por item)

---

## 4. Decisões de modelagem e tratamento de dados

Esta seção registra as escolhas que o enunciado não define.

### 4.1 Cliente de loja sem pessoa física
701 clientes têm `storeid` e não têm `personid`. Para eles, `nome_completo` recebe o **nome da loja** (`sales_store`) e `tipo_pessoa = 'LJ'`. Tratado em `int_cliente`.

### 4.2 Namíbia com código de país nulo
Em `person_countryregion`, o registro da Namíbia tem `countryregioncode` nulo na origem.
- O teste `not_null` falha com **1 registro**, e o erro é **mantido de propósito**, para registrar o problema.
- No staging, `coalesce(countryregioncode, 'NA')` gera `pk_pais`, e o valor original fica em `pk_pais_original`.
- **Impacto:** nenhum pedido vinculado a esse país (contagem pelo país do endereço de entrega = 0).

### 4.3 Vendas sem cartão
2.573 itens não têm cartão na origem (`creditcardid` nulo). Em `dim_cartao` foi criada a linha `-1` ("Sem cartão"), e em `fct_vendas` o nulo recebe `-1`, para que nenhuma venda fique sem dimensão.
- **Conferência:** o total geral é o mesmo com e sem essa linha.

### 4.4 Vendedor e nulos da origem
`fk_vendedor` é nulo em pedidos sem vendedor. Os testes de relacionamento ignoram nulos, e a contagem de chaves órfãs é zero.

### 4.5 Ticket médio
Definido como **faturamento bruto menos descontos, dividido pelo número de pedidos**. Como o valor líquido já é o bruto menos o desconto, a medida usa `Valor Líquido ÷ Pedidos`, o que equivale à definição do enunciado.

### 4.6 Pergunta (f) e o motivo "Promotion"
O enunciado cita "Promotion". No modelo, esse é o **tipo de motivo** (`tipo_motivo = 'Promotion'`), que contém um único motivo: "On Promotion". O filtro usa o **tipo**, e não o nome, para não depender de um texto específico.

### 4.7 Ponte pedido-motivo
Um pedido pode ter mais de um motivo, então a relação com a fato é **muitos para muitos**, com filtro **único a partir da ponte**.
> ⚠️ Totais por motivo **não devem ser somados entre si**: um pedido aparece em cada motivo que possui.

### 4.8 Teste de 2011 e total geral
O teste do CEO valida **2011** ($ 12.646.112,16). O total de 2011 a 2014 é de **$ 110.373.889,31**. Os dois valores são consistentes: 2011 é um dos quatro anos somados.

---

## 5. Qualidade de dados

| Tipo de teste | Onde | O que verifica |
|---|---|---|
| `unique` e `not_null` | Chaves das 14 tabelas de origem | Integridade das chaves na fonte |
| `unique` e `not_null` | Chaves de dimensões e fato | Unicidade do grão |
| `relationships` | `fct_vendas` → dimensões | Toda chave da fato existe na dimensão |
| Teste de dados | `tests/teste_vendas_brutas_2011.sql` | Total bruto de 2011 = $ 12.646.112,16 |

> **Exceção documentada:** o `not_null` de `person_countryregion.countryregioncode` falha com 1 registro (Namíbia, ver 4.2). O erro é mantido de propósito.

**Comandos para reproduzir:**

```bash
dbt run
dbt test --select source:*
dbt test
```

**Histórico de correções relevantes:**
- A fórmula de `total_bruto_linha` foi separada da de líquido.
- O `cast` de preço para `decimal(18, 2)` foi removido, porque arredondava cada linha e acumulava diferença de **R$ 6,58** no total de 2011.

---

## 6. Painel Power BI

Três páginas, com filtros sincronizados por página.

| Página | Conteúdo | Perguntas |
|---|---|---|
| **Visão Geral** | Cards de totais, série mensal e top 10 clientes | (a), (c), (e) |
| **Produto e motivo** | Quantidade por produto em promoção e top 5 cidades | (d), (f) |
| **Detalhamento** | Pedidos, quantidade e valor por produto e motivo; ticket médio por produto, mês e local | (a), (b) |

O layout foi planejado no **Figma**, a partir do módulo de UX/UI, com a identidade visual adaptada ao Adventure Works.

**Respostas às perguntas:**
- **(f)** Produto com maior quantidade em promoção: **Water Bottle - 30 oz.**, com **546** unidades.
- **(d)** Top 5 cidades por valor negociado: **Toronto** (lidera), seguida de London, Paris, Seattle e Burnaby. [confirmar valores finais]

---

## 7. Como reproduzir

1. Configure o profile do dbt Cloud com o catálogo `dev` e o SQL warehouse do Databricks.
2. Rode `dbt build`, ou os comandos da seção 5.
3. Abra o `.pbix`, confirme a fonte em `prod_adventure_works` e clique em **Atualizar**.

---

## 8. Limitações conhecidas

- Alguns "clientes" são **lojas**, e não pessoas físicas (ver 4.1).
- A base é um **dataset de treinamento**, e as conclusões valem para o período de 2011 a 2014.
- O painel depende do **SQL warehouse ativo** para atualizar os dados.

---

## 9. Estrutura do repositório

```
adventure_works_dw/
├── dbt_project.yml
├── models/
│   ├── staging/
│   ├── intermediate/
│   └── marts/
│       └── schema/        # documentação e testes dos marts
├── tests/                 # teste de dados do CEO
└── docs/                  # diagrama conceitual em PDF
```

---

## 👤 Autor

**Davi Alcântara** · [www.linkedin(https://www.linkedin.com/in/davi-aguiar/)] · [daviaaguiarcec@gmail.com]
