import pandas as pd
import streamlit as st
from sqlalchemy import create_engine

st.set_page_config(page_title="Prism", layout="wide")

engine = create_engine("postgresql+psycopg2://prism:prism@localhost:5432/prism")
df = pd.read_sql("select * from analytics_marts.mart_risco_divida order by mes", engine)
df["mes"] = pd.to_datetime(df["mes"])

st.title("Prism: monitor de risco da dívida pública")
ult = df.iloc[-1]
icone = {"verde": "🟢", "amarelo": "🟡", "vermelho": "🔴"}

c1, c2, c3 = st.columns(3)
c1.metric("Dívida bruta/PIB", f"{ult.divida_bruta_pct_pib:.1f}%",
          f"{ult.var_divida_12m_pp:+.1f} p.p. em 12m")
c2.metric("Juros reais", f"{ult.juros_reais_pct:.1f}%")
c3.metric("Semáforo", f"{icone[ult.semaforo]} {ult.semaforo}")
st.caption(f"Dados até {ult.mes:%m/%Y}")

st.subheader("Dívida bruta e líquida (% do PIB)")
st.line_chart(df.set_index("mes")[["divida_bruta_pct_pib", "divida_liquida_pct_pib"]])

st.subheader("Juros reais e crescimento real do PIB (%)")
st.line_chart(df.set_index("mes")[["juros_reais_pct", "cresc_pib_real_pct"]])

st.subheader("Primário requerido para estabilizar a dívida (% do PIB)")
st.line_chart(df.set_index("mes")["primario_requerido_pct_pib"])

st.subheader("Score de risco (0 a 6)")
st.bar_chart(df.set_index("mes")["score_risco"])
