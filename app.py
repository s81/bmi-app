import streamlit as st
from core.styles import inject_css

st.set_page_config(
    page_title="BMI Calculator",
    page_icon="⚕️",
    layout="centered",
    initial_sidebar_state="expanded",
)

inject_css()

st.html(
    '<p style="font-family:\'DM Sans\',sans-serif;font-size:0.72rem;'
    'font-weight:700;text-transform:uppercase;letter-spacing:0.12em;'
    'color:#536780;margin-bottom:0.25rem;">Scientific BMI Analysis</p>')
st.title("Body Mass Index\nCalculator")

st.html(
    '<p style="color:#536780;font-size:0.95rem;max-width:520px;line-height:1.6;'
    'margin-top:0.25rem;font-family:\'DM Sans\',sans-serif;">'
    "Four validated indices · WHO &amp; Asian cutoffs · Full scientific report"
    "</p>")

st.html(
    """
<div style="display:flex;gap:0.6rem;flex-wrap:wrap;margin:1.5rem 0 2rem;">
    <span style="background:#EEF3FA;color:#1E3A5F;border:1px solid #D9E4F0;
        border-radius:20px;padding:5px 14px;font-size:0.78rem;font-weight:600;
        font-family:'DM Sans',sans-serif;">Standard BMI (WHO)</span>
    <span style="background:#EEF3FA;color:#1E3A5F;border:1px solid #D9E4F0;
        border-radius:20px;padding:5px 14px;font-size:0.78rem;font-weight:600;
        font-family:'DM Sans',sans-serif;">New BMI — Peterson 2016</span>
    <span style="background:#EEF3FA;color:#1E3A5F;border:1px solid #D9E4F0;
        border-radius:20px;padding:5px 14px;font-size:0.78rem;font-weight:600;
        font-family:'DM Sans',sans-serif;">Ponderal Index</span>
    <span style="background:#EEF3FA;color:#1E3A5F;border:1px solid #D9E4F0;
        border-radius:20px;padding:5px 14px;font-size:0.78rem;font-weight:600;
        font-family:'DM Sans',sans-serif;">BSA — Mosteller</span>
</div>
""")

st.html(
    '<div style="background:#FFF7ED;border:1px solid #FED7AA;border-left:4px solid #F97316;'
    'border-radius:8px;padding:0.75rem 1rem;font-size:0.83rem;color:#7C2D12;'
    'font-family:\'DM Sans\',sans-serif;">'
    "&#9432;&nbsp; This tool is for informational purposes only and does not replace clinical assessment."
    "</div>")

st.html(
    '<p style="margin-top:1.5rem;font-size:0.88rem;color:#536780;'
    'font-family:\'DM Sans\',sans-serif;">'
    "Use the sidebar to navigate to the <strong>Calculator</strong>."
    "</p>")
