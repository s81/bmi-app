import streamlit as st

st.set_page_config(page_title="Methodology — BMI", page_icon="⚕️", layout="centered")

st.title("Methodology")
st.caption(
    "This tool is for informational purposes only and does not replace clinical assessment."
)

# --- Formulas ---
st.header("Formulas")

st.subheader("Standard BMI (WHO, 1995)")
st.latex(r"\text{BMI} = \frac{\text{weight (kg)}}{\text{height (m)}^2}")
st.markdown("The foundational index proposed by WHO for population-level obesity screening. [1]")

st.subheader("New BMI — Peterson Formula (2016)")
st.latex(r"\text{New BMI} = \frac{1.3 \times \text{weight (kg)}}{\text{height (m)}^{2.5}}")
st.markdown(
    "Corrects the standard formula's bias against tall individuals by raising the height exponent "
    "from 2 to 2.5. Uses the same WHO classification thresholds. [2]"
)

st.subheader("Ponderal Index (Rohrer, 1921)")
st.latex(r"\text{PI} = \frac{\text{weight (kg)}}{\text{height (m)}^3}")
st.markdown(
    "An alternative slenderness measure, less sensitive to height than BMI. "
    "Normal range: 11–14 kg/m³. [3]"
)

st.subheader("Body Surface Area — Mosteller Formula (1987)")
st.latex(r"\text{BSA} = \sqrt{\frac{\text{height (cm)} \times \text{weight (kg)}}{3600}}")
st.markdown(
    "Used clinically for drug dosing, cardiac output, and renal function normalization. "
    "Reported in m². [4]"
)

st.divider()

# --- Classification Tables ---
st.header("Classification Tables")

st.subheader("WHO Standard BMI")
st.table({
    "BMI Range (kg/m²)": ["< 18.5", "18.5 – 24.9", "25.0 – 29.9", "30.0 – 34.9", "35.0 – 39.9", "≥ 40.0"],
    "Category": ["Underweight", "Normal weight", "Overweight", "Obese Class I", "Obese Class II", "Obese Class III"],
    "Health Risk": ["Low (but other risks)", "Average", "Increased", "High", "Very High", "Extremely High"],
})

st.subheader("WHO Asian Cutoffs (East/South Asian Populations)")
st.markdown(
    "Recommended by WHO for East and South Asian populations due to higher cardiometabolic risk "
    "at equivalent BMI values compared to European populations. [5]"
)
st.table({
    "BMI Range (kg/m²)": ["< 18.5", "18.5 – 22.9", "23.0 – 27.4", "≥ 27.5"],
    "Category": ["Underweight", "Normal weight", "Overweight", "Obese"],
    "Health Risk": ["Low (but other risks)", "Average", "Increased", "High"],
})

st.subheader("Ponderal Index")
st.table({
    "PI Range (kg/m³)": ["< 11", "11 – 14", "> 14"],
    "Category": ["Underweight", "Normal", "Overweight"],
})

st.divider()

# --- References ---
st.header("References")
st.markdown(
    """
1. World Health Organization. (1995). *Physical Status: The Use and Interpretation of Anthropometry*. WHO Technical Report Series 854. Geneva: WHO.
2. Peterson, C.M., Thomas, D.M., Blackburn, G.L., & Heymsfield, S.B. (2016). Universal equation for estimating ideal body weight and body weight at any BMI. *The American Journal of Clinical Nutrition*, 103(5), 1197–1203.
3. Rohrer, F. (1921). Der Index der Körperfülle als Maß des Ernährungszustandes. *Münchener Medizinische Wochenschrift*, 68, 580–582.
4. Mosteller, R.D. (1987). Simplified calculation of body-surface area. *New England Journal of Medicine*, 317(17), 1098.
5. WHO Expert Consultation. (2004). Appropriate body-mass index for Asian populations and its implications for policy and intervention strategies. *The Lancet*, 363(9403), 157–163.
"""
)
