import streamlit as st
from core.bmi import calc_standard_bmi, calc_new_bmi, calc_ponderal_index, calc_bsa, calc_whtr
from core.classifications import (
    classify_who_standard,
    classify_who_asian,
    classify_ponderal,
    classify_new_bmi,
    classify_whtr,
)
from core.styles import (
    inject_css,
    bmi_hero_html,
    indices_table_html,
    section_label,
    RISK_PALETTE,
)

st.set_page_config(page_title="Results — BMI", page_icon="⚕️", layout="centered")
inject_css()

st.caption("This tool is for informational purposes only and does not replace clinical assessment.")

# ── Session state guard ───────────────────────────────────────────────────────
if "bmi_inputs" not in st.session_state:
    st.warning("No data found. Please complete the Calculator first.")
    if st.button("Go to Calculator"):
        st.switch_page("pages/1_Calculator.py")
    st.stop()

inputs = st.session_state["bmi_inputs"]
weight_kg  = inputs["weight_kg"]
height_m   = inputs["height_cm"] / 100.0
height_cm  = inputs["height_cm"]
is_asian   = inputs["ethnicity"] == "Asian (East/South)"

# ── Calculations ──────────────────────────────────────────────────────────────
standard_bmi = calc_standard_bmi(weight_kg, height_m)
new_bmi      = calc_new_bmi(weight_kg, height_m)
pi           = calc_ponderal_index(weight_kg, height_m)
bsa          = calc_bsa(height_cm, weight_kg)

classify_fn                      = classify_who_asian if is_asian else classify_who_standard
primary_category, primary_risk   = classify_fn(standard_bmi)
pi_category,      pi_risk        = classify_ponderal(pi)
new_bmi_category, new_bmi_risk   = classify_new_bmi(new_bmi)

waist_cm = inputs.get("waist_cm")
whtr = calc_whtr(waist_cm, height_cm) if waist_cm else None
whtr_category, whtr_risk = classify_whtr(whtr) if whtr is not None else ("—", "—")

# ── Section 1: Hero card ──────────────────────────────────────────────────────
st.title("Results")
st.html(
    bmi_hero_html(
        bmi_val=standard_bmi,
        category=primary_category,
        risk=primary_risk,
        age=inputs["age"],
        sex=inputs["sex"],
        ethnicity=inputs["ethnicity"],
        height_display=inputs["height_display"],
        weight_display=inputs["weight_display"],
    ))

# ── Section 2: All indices table ──────────────────────────────────────────────
st.html(section_label("All Indices"))
st.html(
    indices_table_html(
        standard_bmi=standard_bmi,
        new_bmi=new_bmi,
        pi=pi,
        bsa=bsa,
        primary_category=primary_category,
        primary_risk=primary_risk,
        new_bmi_category=new_bmi_category,
        new_bmi_risk=new_bmi_risk,
        pi_category=pi_category,
        pi_risk=pi_risk,
        whtr=whtr,
        whtr_category=whtr_category,
        whtr_risk=whtr_risk,
    ))

# ── Section 3: WHtR callout ───────────────────────────────────────────────────
if whtr is not None:
    target = height_cm / 2
    target_display = inputs["waist_display"].split(" ")[1]  # unit label
    if target_display == "in":
        target_val = f"{target / 2.54:.1f} in"
    else:
        target_val = f"{target:.1f} cm"
    direction = "above" if whtr >= 0.5 else "below"
    color = "#FEF3C7" if whtr >= 0.5 else "#D1FAE5"
    border = "#F59E0B" if whtr >= 0.5 else "#059669"
    text_color = "#78350F" if whtr >= 0.5 else "#065F46"
    st.html(
        f'<div style="background:{color};border:1px solid {border};border-left:4px solid {border};'
        f'border-radius:10px;padding:0.85rem 1.25rem;font-size:0.88rem;color:{text_color};'
        f'font-family:\'DM Sans\',sans-serif;line-height:1.6;margin-bottom:0.5rem;">'
        f'<b>WHtR:</b> Your waist ({inputs["waist_display"]}) is {direction} the evidence-based '
        f'target of half your height ({target_val}). '
        f'Keeping WHtR below 0.5 is associated with significantly lower cardiometabolic risk '
        f'across all ethnicities. [6]</div>'
    )

# ── Section 5: Ethnicity note ─────────────────────────────────────────────────
if is_asian:
    st.info(
        "**Asian cutoffs applied.** WHO recommends lower BMI thresholds for East and South Asian "
        "populations due to higher body fat percentage and cardiometabolic risk at equivalent BMI. "
        "Overweight threshold: 23.0 (vs 25.0) · Obese threshold: 27.5 (vs 30.0). "
        "Source: WHO Expert Consultation, *The Lancet*, 2004.",
        icon="ℹ️",
    )

st.divider()

# ── Section 6: Risk interpretation ────────────────────────────────────────────
st.html(section_label("Risk Interpretation"))

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

p = RISK_PALETTE.get(primary_risk, RISK_PALETTE["—"])
interp_text = risk_text.get(primary_risk, "Interpretation not available for this risk level.")
st.html(
    f'<div role="region" aria-label="Risk Interpretation" style="background:{p["bg"]};border:1px solid {p["border"]};border-left:4px solid {p["dot"]};'
    f'border-radius:10px;padding:1rem 1.25rem;font-size:0.9rem;color:{p["text"]};'
    f'font-family:\'DM Sans\',sans-serif;line-height:1.65;">{interp_text}</div>')

st.divider()

# ── References ─────────────────────────────────────────────────────────────────
st.html(section_label("References"))
st.html(
    """
<ol style="font-size:0.82rem;color:#536780;line-height:1.8;
    font-family:'DM Sans',sans-serif;padding-left:1.25rem;">
  <li>World Health Organization. (1995). <em>Physical Status: The Use and Interpretation of Anthropometry</em>. WHO Technical Report Series 854.</li>
  <li>Peterson, C.M., et al. (2016). A new formula for computing body mass index. <em>Obesity</em>.</li>
  <li>Rohrer, F. (1921). Der Index der Körperfülle. <em>Münchener Medizinische Wochenschrift</em>.</li>
  <li>Mosteller, R.D. (1987). Simplified calculation of body surface area. <em>NEJM</em>, 317(17), 1098.</li>
  <li>WHO Expert Consultation. (2004). Appropriate BMI for Asian populations. <em>The Lancet</em>, 363, 157–163.</li>
  <li>Ashwell, M., &amp; Gibson, S. (2016). Waist-to-height ratio as an indicator of 'early health risk'. <em>BMJ Open</em>, 6(3), e010159.</li>
</ol>
""")

st.html("<div style='margin-top:1rem;'></div>")
if st.button("← Recalculate", type="secondary"):
    st.switch_page("pages/1_Calculator.py")
