import streamlit as st
from core.bmi import calc_standard_bmi, calc_new_bmi, calc_ponderal_index, calc_bsa
from core.classifications import (
    classify_who_standard,
    classify_who_asian,
    classify_ponderal,
    classify_new_bmi,
    get_risk_color,
)

st.set_page_config(page_title="Results — BMI", page_icon="⚕️", layout="centered")

st.caption(
    "This tool is for informational purposes only and does not replace clinical assessment."
)

# --- Session state guard ---
if "bmi_inputs" not in st.session_state:
    st.warning("No data found. Please complete the Calculator first.")
    if st.button("Go to Calculator"):
        st.switch_page("pages/1_Calculator.py")
    st.stop()

inputs = st.session_state["bmi_inputs"]
weight_kg = inputs["weight_kg"]
height_m = inputs["height_cm"] / 100.0
height_cm = inputs["height_cm"]
is_asian = inputs["ethnicity"] == "Asian (East/South)"

# --- Calculations ---
standard_bmi = calc_standard_bmi(weight_kg, height_m)
new_bmi = calc_new_bmi(weight_kg, height_m)
pi = calc_ponderal_index(weight_kg, height_m)
bsa = calc_bsa(height_cm, weight_kg)

classify_fn = classify_who_asian if is_asian else classify_who_standard
primary_category, primary_risk = classify_fn(standard_bmi)
pi_category, pi_risk = classify_ponderal(pi)
new_bmi_category, new_bmi_risk = classify_new_bmi(new_bmi)

color = get_risk_color(primary_risk)

# --- Section 1: Summary card ---
st.title("Results")
st.markdown(f"**Age:** {inputs['age']} | **Sex:** {inputs['sex']} | **Ethnicity:** {inputs['ethnicity']}")
st.markdown(f"**Height:** {inputs['height_display']} | **Weight:** {inputs['weight_display']}")
st.divider()

col1, col2 = st.columns([1, 2])
with col1:
    st.metric("Standard BMI", f"{standard_bmi:.2f}")
with col2:
    st.markdown(f"### :{color}[{primary_category}]")
    st.markdown(f"**Health risk:** {primary_risk}")

st.divider()

# --- Section 2: All indices table ---
st.subheader("All Indices")

table_data = {
    "Index": ["Standard BMI", "New BMI (Peterson)", "Ponderal Index", "BSA (Mosteller)"],
    "Value": [
        f"{standard_bmi:.2f} kg/m²",
        f"{new_bmi:.2f} kg/m²",
        f"{pi:.2f} kg/m³",
        f"{bsa:.3f} m²",
    ],
    "Classification": [
        primary_category,
        new_bmi_category,
        pi_category,
        "—",
    ],
    "Health Risk": [
        primary_risk,
        new_bmi_risk,
        pi_risk,
        "—",
    ],
}
st.table(table_data)

# --- Section 3: Ethnicity note ---
if is_asian:
    st.info(
        "**Asian cutoffs applied.** WHO recommends lower BMI thresholds for East and South Asian "
        "populations due to higher body fat percentage and cardiometabolic risk at equivalent BMI. "
        "Overweight threshold: 23.0 (vs 25.0); Obese threshold: 27.5 (vs 30.0). "
        "Source: WHO Expert Consultation, *The Lancet*, 2004.",
        icon="ℹ️",
    )

# --- Section 4: Risk interpretation ---
st.subheader("Risk Interpretation")

risk_text = {
    "Low (but other risks)": (
        "Underweight individuals may face increased risk of malnutrition, bone density loss, "
        "immune suppression, and cardiovascular complications. Clinical evaluation is recommended. [1]"
    ),
    "Average": (
        "BMI in the normal range is associated with the lowest all-cause mortality risk in large "
        "population studies. Maintaining weight through balanced nutrition and physical activity is advised. [1]"
    ),
    "Increased": (
        "Overweight is associated with increased risk of type 2 diabetes, hypertension, dyslipidemia, "
        "and coronary heart disease. Lifestyle interventions are clinically recommended. [1]"
    ),
    "High": (
        "Obese Class I carries high risk for metabolic syndrome, sleep apnea, osteoarthritis, and "
        "cardiovascular disease. Medical assessment and structured weight management are recommended. [1]"
    ),
    "Very High": (
        "Obese Class II is associated with very high risk of all obesity-related comorbidities. "
        "Pharmacological or surgical interventions may be appropriate alongside lifestyle changes. [1]"
    ),
    "Extremely High": (
        "Obese Class III (severe obesity) carries extremely high risk of premature mortality. "
        "Bariatric evaluation is typically indicated. Urgent clinical assessment recommended. [1]"
    ),
    "Low": (
        "Ponderal Index in the low range may indicate underweight relative to stature. "
        "Clinical context is required for interpretation. [3]"
    ),
    "Elevated": (
        "Elevated Ponderal Index may indicate excess weight relative to stature. "
        "Clinical context is required for interpretation. [3]"
    ),
}

st.markdown(risk_text.get(primary_risk, "Interpretation not available for this risk level."))

st.markdown(
    """
**References**
1. World Health Organization. (1995). *Physical Status: The Use and Interpretation of Anthropometry*. WHO Technical Report Series 854.
2. Peterson, C.M., et al. (2016). *A new formula for computing body mass index*. Obesity.
3. Rohrer, F. (1921). *Der Index der Körperfülle als Maß des Ernährungszustandes*. München.
4. Mosteller, R.D. (1987). *Simplified calculation of body surface area*. NEJM, 317(17), 1098.
5. WHO Expert Consultation. (2004). *Appropriate BMI for Asian populations*. The Lancet, 363, 157–163.
"""
)

st.divider()
if st.button("← Recalculate"):
    st.switch_page("pages/1_Calculator.py")
