# PRISM: monitor de risco da dívida pública brasileira

Pipeline ELT que integra séries oficiais do Banco Central, calcula a relação dívida/PIB e indicadores de sustentabilidade fiscal, e classifica o risco em um semáforo. Stack: Python, PostgreSQL, dbt e Streamlit.

## Pergunta central
Dado o nível da dívida, os juros reais e o crescimento da economia, a trajetória da dívida pública brasileira é sustentável, e qual o nível de risco associado?

## Arquitetura
CSV (API SGS/BCB) -> schema `raw` (Postgres) -> dbt `staging` -> `intermediate` -> `marts` -> dashboard (Streamlit)

## Fontes de dados (API SGS do Banco Central)
| Série | Código |
|---|---|
| Dívida bruta do governo geral (% PIB) | 13762 |
| Dívida bruta do governo geral (R$ mi) | 13741 |
| Dívida líquida do setor público (% PIB) | 4513 |
| PIB acumulado em 12 meses (R$ mi) | 4382 |
| IPCA mensal | 433 |
| Meta Selic | 432 |

## Indicadores
- Dívida/PIB e variação em 12 meses (p.p.)
- Juros reais ex-post: `(1 + Selic) / (1 + IPCA 12m) - 1`
- Crescimento real do PIB (PIB nominal 12m deflacionado pelo IPCA 12m)
- Diferencial juros reais menos crescimento
- Primário requerido para estabilizar a dívida: `d * (r - g) / (1 + g)`
- Semáforo (verde, amarelo, vermelho) com cortes configuráveis no seed `risk_thresholds`

## Como rodar
Pré-requisitos: Docker, Python 3.10+ e Git.

```bash
python -m venv .venv
source .venv/Scripts/activate      # Windows (Git Bash). Linux/Mac: source .venv/bin/activate
pip install -r requirements.txt
docker compose up -d
python ingestao/load_raw.py
cd dbt
dbt deps
dbt seed
dbt build
cd ..
streamlit run dashboard/app.py
```
Os CSVs ficam em `data/raw_csv/`. A Selic é diária e a API limita cada consulta a cerca de 10 anos, por isso ela está dividida em 4 arquivos.

## Qualidade dos dados (dbt)
- Testes de `not_null`, `unique`, faixas de valores e valores aceitos.
- Teste de consistência: a série oficial 13762 é recalculada como `13741 / 4382 * 100` (tolerância de 0,1 p.p.).
- Teste que falha se a Selic não estiver atualizada.
- Freshness nas sources e documentação com lineage (`dbt docs generate && dbt docs serve`).

## Resultados
- Cobertura do mart: jan/2007 a set/2026 (237 meses).
- Último mês (set/2026): dívida bruta de 82,95% do PIB, juros reais de 8,77% e crescimento real do PIB de 2,30%.
- Semáforo no último mês: vermelho.

## Limitações
- O crescimento real do PIB é aproximado (PIB nominal deflacionado pelo IPCA, e não pelo deflator do PIB).
- Os juros reais usam a Selic meta e o IPCA dos últimos 12 meses, e não o custo médio efetivo da dívida.
- O primário calculado é o requerido; o primário observado não está incluído.
- Os cortes do semáforo são escolhas metodológicas, não um padrão oficial.
- A série de dívida bruta começa em dez/2006 e o BC revisa dados passados.

## Próximos passos
Simulador de cenários, backtest do semáforo, resultado primário observado, composição da dívida (Tesouro Transparente) e CI com GitHub Actions.
