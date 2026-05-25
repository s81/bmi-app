import streamlit as st
from core.bmi import lbs_to_kg, inches_to_cm

st.set_page_config(page_title="Calculator — BMI", page_icon="⚕️", layout="centered")

st.title("BMI Calculator")
st.caption(
    "This tool is for informational purposes only and does not replace clinical assessment."
)

# --- Unit system ---
unit = st.radio("Unit system", ["Metric (kg, cm)", "Imperial (lbs, in)"], horizontal=True)
imperial = unit.startswith("Imperial")

# --- Inputs ---
col1, col2 = st.columns(2)

with col1:
    age = st.number_input("Age (years)", min_value=2, max_value=120, value=30, step=1)
    sex = st.selectbox("Sex", ["Male", "Female", "Other"])

with col2:
    ethnicity = st.selectbox(
        "Ethnicity",
        ["General population", "Asian (East/South)", "Other"],
        help=(
            "WHO recommends lower BMI thresholds for East and South Asian populations. "
            "At the same BMI, Asian individuals have higher body fat percentage and "
            "greater cardiometabolic risk. (WHO Lancet 2004)"
        ),
    )

if imperial:
    height_raw = st.number_input("Height (inches)", min_value=20.0, max_value=118.0, value=69.0, step=0.5)
    weight_raw = st.number_input("Weight (lbs)", min_value=4.0, max_value=1543.0, value=154.0, step=0.5)
else:
    height_raw = st.number_input("Height (cm)", min_value=50.0, max_value=300.0, value=175.0, step=0.5)
    weight_raw = st.number_input("Weight (kg)", min_value=2.0, max_value=700.0, value=70.0, step=0.5)

# --- Validation and conversion ---
errors = []

if imperial:
    height_cm = inches_to_cm(height_raw)
    weight_kg = lbs_to_kg(weight_raw)
else:
    height_cm = height_raw
    weight_kg = weight_raw

if not (50.0 <= height_cm <= 300.0):
    errors.append(f"Height {height_cm:.1f} cm is outside physiological range (50–300 cm).")
if not (2.0 <= weight_kg <= 700.0):
    errors.append(f"Weight {weight_kg:.1f} kg is outside physiological range (2–700 kg).")

for err in errors:
    st.error(err)

# --- Submit ---
if st.button("Calculate →", type="primary", disabled=bool(errors)):
    st.session_state["bmi_inputs"] = {
        "age": age,
        "sex": sex,
        "ethnicity": ethnicity,
        "height_cm": height_cm,
        "weight_kg": weight_kg,
        "height_display": f"{height_raw} {'in' if imperial else 'cm'}",
        "weight_display": f"{weight_raw} {'lbs' if imperial else 'kg'}",
    }
    st.switch_page("pages/2_Results.py")
