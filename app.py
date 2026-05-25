import streamlit as st

st.set_page_config(
    page_title="BMI Calculator",
    page_icon="⚕️",
    layout="centered",
    initial_sidebar_state="expanded",
)

st.title("BMI Calculator")
st.markdown(
    "A professional, scientifically-grounded tool for health professionals, "
    "fitness coaches, researchers, and students."
)
st.info(
    "This tool is for informational purposes only and does not replace clinical assessment.",
    icon="ℹ️",
)
st.markdown("Use the sidebar to navigate to the **Calculator**.")
