import streamlit as st
from core.styles import inject_css, section_label, formula_card_open, formula_card_close

st.set_page_config(page_title="Methodology — BMI", page_icon="⚕️", layout="centered")
inject_css()

st.title("Methodology")
st.caption("This tool is for informational purposes only and does not replace clinical assessment.")

# ── Formulas ──────────────────────────────────────────────────────────────────
st.html(section_label("Validated Indices"))

st.html(formula_card_open("Standard BMI", "WHO, 1995"))
st.latex(r"\text{BMI} = \frac{\text{weight (kg)}}{\text{height (m)}^2}")
st.html(
    formula_card_close(
        "The foundational index proposed by WHO for population-level obesity screening. "
        "Defined as body weight divided by the square of height. [1]"
    ))

st.html(formula_card_open("New BMI — Peterson Formula", "Peterson et al., 2016"))
st.latex(r"\text{New BMI} = \frac{1.3 \times \text{weight (kg)}}{\text{height (m)}^{2.5}}")
st.html(
    formula_card_close(
        "Corrects the standard formula's systematic bias against tall individuals "
        "by raising the height exponent from 2 to 2.5. "
        "Uses the same WHO classification thresholds as Standard BMI. [2]"
    ))

st.html(formula_card_open("Ponderal Index", "Rohrer, 1921"))
st.latex(r"\text{PI} = \frac{\text{weight (kg)}}{\text{height (m)}^3}")
st.html(
    formula_card_close(
        "An alternative slenderness measure that is less sensitive to height variation than BMI. "
        "Normal physiological range: 11–14 kg/m³. [3]"
    ))

st.html(formula_card_open("Body Surface Area — Mosteller Formula", "Mosteller, 1987"))
st.latex(r"\text{BSA} = \sqrt{\frac{\text{height (cm)} \times \text{weight (kg)}}{3600}}")
st.html(
    formula_card_close(
        "Used clinically for chemotherapy dosing, cardiac output normalisation, "
        "and renal function assessment. Reported in m². [4]"
    ))

st.divider()

# ── Classification Tables ─────────────────────────────────────────────────────
st.html(section_label("Classification Tables"))

def styled_table(headers, rows, risk_col=None):
    risk_colors = {
        "Low (but other risks)": "#065F46",
        "Average":               "#1E3A8A",
        "Increased":             "#78350F",
        "High":                  "#7F1D1D",
        "Very High":             "#7F1D1D",
        "Extremely High":        "#881337",
    }
    risk_bgs = {
        "Low (but other risks)": "#D1FAE5",
        "Average":               "#DBEAFE",
        "Increased":             "#FEF3C7",
        "High":                  "#FEE2E2",
        "Very High":             "#FEE2E2",
        "Extremely High":        "#FFE4E6",
    }
    th_cells = "".join(
        f'<th scope="col" style="padding:0.7rem 1rem;text-align:left;color:#8BB8E8;'
        f'font-family:\'DM Sans\',sans-serif;font-size:0.65rem;font-weight:700;'
        f'text-transform:uppercase;letter-spacing:0.1em;border:none;">{h}</th>'
        for h in headers
    )
    tbody = ""
    for i, row in enumerate(rows):
        bg = "#FAFCFF" if i % 2 else "#FFFFFF"
        cells = ""
        for j, cell in enumerate(row):
            is_risk = risk_col is not None and j == risk_col
            if is_risk and cell in risk_colors:
                cells += (
                    f'<td style="padding:0.75rem 1rem;border-bottom:1px solid #D9E4F0;">'
                    f'<span style="background:{risk_bgs[cell]};color:{risk_colors[cell]};'
                    f'border-radius:4px;padding:2px 8px;font-size:0.8rem;font-weight:600;'
                    f'font-family:\'DM Sans\',sans-serif;">{cell}</span></td>'
                )
            else:
                mono = j == 0
                ff   = "'JetBrains Mono',monospace" if mono else "'DM Sans',sans-serif"
                fs   = "0.85rem" if mono else "0.9rem"
                fc   = "#1E3A5F" if mono else "#0D1B2E"
                fw   = "600" if mono else "400"
                cells += (
                    f'<td style="padding:0.75rem 1rem;border-bottom:1px solid #D9E4F0;'
                    f'font-family:{ff};font-size:{fs};color:{fc};font-weight:{fw};">'
                    f'{cell}</td>'
                )
        tbody += f'<tr style="background:{bg};">{cells}</tr>'
    return (
        f'<div style="border-radius:12px;overflow:hidden;margin:0 0 1.5rem;'
        f'box-shadow:0 1px 3px rgba(10,22,40,.08);">'
        f'<table style="width:100%;border-collapse:collapse;">'
        f'<thead><tr style="background:#0A1628;">{th_cells}</tr></thead>'
        f'<tbody>{tbody}</tbody></table></div>'
    )

st.html(
    '<p style="font-family:\'DM Serif Display\',serif;font-size:1.15rem;'
    'color:#0A1628;margin:0.5rem 0 0.5rem;">WHO Standard</p>')
st.html(
    styled_table(
        headers=["BMI Range (kg/m²)", "Category", "Health Risk"],
        rows=[
            ("< 18.5",       "Underweight",      "Low (but other risks)"),
            ("18.5 – 24.9",  "Normal weight",    "Average"),
            ("25.0 – 29.9",  "Overweight",       "Increased"),
            ("30.0 – 34.9",  "Obese Class I",    "High"),
            ("35.0 – 39.9",  "Obese Class II",   "Very High"),
            ("≥ 40.0",       "Obese Class III",  "Extremely High"),
        ],
        risk_col=2,
    ))

st.html(
    '<p style="font-family:\'DM Serif Display\',serif;font-size:1.15rem;'
    'color:#0A1628;margin:0.5rem 0 0.25rem;">WHO Asian Cutoffs</p>'
    '<p style="font-size:0.82rem;color:#536780;font-family:\'DM Sans\',sans-serif;'
    'margin:0 0 0.5rem;line-height:1.5;">Recommended for East and South Asian populations due to higher '
    'cardiometabolic risk at equivalent BMI values compared to European populations. [5]</p>')
st.html(
    styled_table(
        headers=["BMI Range (kg/m²)", "Category", "Health Risk"],
        rows=[
            ("< 18.5",       "Underweight",   "Low (but other risks)"),
            ("18.5 – 22.9",  "Normal weight", "Average"),
            ("23.0 – 27.4",  "Overweight",    "Increased"),
            ("≥ 27.5",       "Obese",         "High"),
        ],
        risk_col=2,
    ))

st.html(
    '<p style="font-family:\'DM Serif Display\',serif;font-size:1.15rem;'
    'color:#0A1628;margin:0.5rem 0 0.5rem;">Ponderal Index</p>')
st.html(
    styled_table(
        headers=["PI Range (kg/m³)", "Category"],
        rows=[
            ("< 11",   "Underweight"),
            ("11 – 14","Normal"),
            ("> 14",   "Overweight"),
        ],
    ))

st.divider()

# ── References ────────────────────────────────────────────────────────────────
st.html(section_label("References"))
st.html(
    """
<ol style="font-size:0.82rem;color:#536780;line-height:1.9;
    font-family:'DM Sans',sans-serif;padding-left:1.25rem;">
  <li>World Health Organization. (1995). <em>Physical Status: The Use and Interpretation of Anthropometry</em>. WHO Technical Report Series 854. Geneva: WHO.</li>
  <li>Peterson, C.M., Thomas, D.M., Blackburn, G.L., &amp; Heymsfield, S.B. (2016). Universal equation for estimating ideal body weight and body weight at any BMI. <em>The American Journal of Clinical Nutrition</em>, 103(5), 1197–1203.</li>
  <li>Rohrer, F. (1921). Der Index der Körperfülle als Maß des Ernährungszustandes. <em>Münchener Medizinische Wochenschrift</em>, 68, 580–582.</li>
  <li>Mosteller, R.D. (1987). Simplified calculation of body-surface area. <em>New England Journal of Medicine</em>, 317(17), 1098.</li>
  <li>WHO Expert Consultation. (2004). Appropriate body-mass index for Asian populations and its implications for policy and intervention strategies. <em>The Lancet</em>, 363(9403), 157–163.</li>
</ol>
""")
