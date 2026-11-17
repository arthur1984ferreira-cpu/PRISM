from pathlib import Path

import pandas as pd
from sqlalchemy import create_engine, text

ENGINE = create_engine("postgresql+psycopg2://prism:prism@localhost:5432/prism")
PASTA = Path("data/raw_csv")

TABELAS = {
    "divida_bruta_pib":   ["bcdata_sgs_13762.csv"],
    "divida_bruta_rs":    ["bcdata_sgs_13741.csv"],
    "divida_liquida_pib": ["bcdata_sgs_4513.csv"],
    "pib_12m":            ["bcdata_sgs_4382.csv"],
    "ipca_mensal":        ["bcdata_sgs_433.csv"],
    "selic_meta":         ["bcdata_sgs_432.csv", "bcdata_sgs_432_2.csv", "bcdata_sgs_432_4.csv", "bcdata_sgs_432_3.csv"],
}

with ENGINE.begin() as con:
    con.execute(text("create schema if not exists raw"))

for tabela, arquivos in TABELAS.items():
    for a in arquivos:
        if not (PASTA / a).exists():
            raise FileNotFoundError(f"Falta o arquivo: {PASTA / a}")
    partes = [
        pd.read_csv(PASTA / a, sep=";", dtype=str, encoding="utf-8-sig")
        for a in arquivos
    ]
    df = pd.concat(partes, ignore_index=True).drop_duplicates()
    df.columns = [c.strip().lower() for c in df.columns]
    df["carregado_em"] = pd.Timestamp.now()
    df.to_sql(tabela, ENGINE, schema="raw", if_exists="replace", index=False)
    print(f"raw.{tabela}: {len(df)} linhas")
