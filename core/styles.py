import streamlit as st
from core.bmi import kg_to_lbs

# ── Risk palette ────────────────────────────────────────────────────────────
RISK_PALETTE = {
    "Low (but other risks)": {"bg": "#D1FAE5", "text": "#065F46", "border": "#059669", "dot": "#10B981"},
    "Average":               {"bg": "#DBEAFE", "text": "#1E3A8A", "border": "#3B82F6", "dot": "#2563EB"},
    "Increased":             {"bg": "#FEF3C7", "text": "#78350F", "border": "#F59E0B", "dot": "#D97706"},
    "High":                  {"bg": "#FEE2E2", "text": "#7F1D1D", "border": "#F87171", "dot": "#DC2626"},
    "Very High":             {"bg": "#FEE2E2", "text": "#7F1D1D", "border": "#F87171", "dot": "#DC2626"},
    "Extremely High":        {"bg": "#FFE4E6", "text": "#881337", "border": "#FB7185", "dot": "#BE123C"},
    "Low":                   {"bg": "#D1FAE5", "text": "#065F46", "border": "#059669", "dot": "#10B981"},
    "Elevated":              {"bg": "#FEF3C7", "text": "#78350F", "border": "#F59E0B", "dot": "#D97706"},
    "—":                     {"bg": "#F1F5F9", "text": "#475569", "border": "#CBD5E1", "dot": "#94A3B8"},
}

# ── Category hero colors (for BMI summary card) ────────────────────────────
CATEGORY_HERO = {
    "Underweight":      "#10B981",
    "Normal weight":    "#2563EB",
    "Overweight":       "#D97706",
    "Obese":            "#DC2626",
    "Obese Class I":    "#DC2626",
    "Obese Class II":   "#BE123C",
    "Obese Class III":  "#9F1239",
}

_CSS = """
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display:ital@0;1&family=JetBrains+Mono:wght@400;500;600&family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500;9..40,600;9..40,700&display=swap" rel="stylesheet">
<style>
/* ── Variables ─────────────────────────────────────────────────────────── */
:root {
  --navy:      #0A1628;
  --navy2:     #162845;
  --navy3:     #1E3A5F;
  --blue:      #0F6CBD;
  --blue-lt:   #DBEAFE;
  --bg:        #F7F9FC;
  --card:      #FFFFFF;
  --border:    #D9E4F0;
  --text:      #0D1B2E;
  --muted:     #536780;
  --ff-display: 'DM Serif Display', Georgia, serif;
  --ff-body:    'DM Sans', system-ui, sans-serif;
  --ff-mono:    'JetBrains Mono', 'Courier New', monospace;
  --shadow-sm:  0 1px 3px rgba(10,22,40,.07), 0 1px 2px rgba(10,22,40,.05);
  --shadow-md:  0 4px 12px rgba(10,22,40,.10), 0 2px 4px rgba(10,22,40,.06);
}

/* ── Base ──────────────────────────────────────────────────────────────── */
html, body, [data-testid="stAppViewContainer"] {
    background-color: var(--bg) !important;
    font-family: var(--ff-body) !important;
}
[data-testid="stMainBlockContainer"] {
    padding-top: 2.5rem !important;
    padding-bottom: 4rem !important;
    max-width: 820px !important;
}
p, li, span { font-family: var(--ff-body) !important; }

/* ── Top header bar ────────────────────────────────────────────────────── */
[data-testid="stHeader"] {
    background: var(--bg) !important;
    border-bottom: 1px solid var(--border) !important;
}
[data-testid="stDecoration"] { display: none !important; }

/* ── Sidebar ───────────────────────────────────────────────────────────── */
[data-testid="stSidebar"] {
    background: linear-gradient(180deg, var(--navy) 0%, var(--navy2) 100%) !important;
    border-right: 1px solid rgba(255,255,255,0.06) !important;
}
[data-testid="stSidebar"] * { color: #C8D9F0 !important; }
[data-testid="stSidebar"] p { font-size: 0.82rem !important; }
[data-testid="stSidebarNavLink"] {
    border-radius: 0 8px 8px 0 !important;
    margin-right: 0.75rem !important;
    padding: 0.45rem 1rem !important;
    font-family: var(--ff-body) !important;
    font-size: 0.875rem !important;
    font-weight: 500 !important;
    transition: background 0.15s ease !important;
}
[data-testid="stSidebarNavLink"]:hover {
    background: rgba(15,108,189,0.2) !important;
}
[data-testid="stSidebarNavLink"][aria-current="page"] {
    background: rgba(15,108,189,0.28) !important;
    border-left: 3px solid var(--blue) !important;
    font-weight: 600 !important;
}

/* ── Headings ──────────────────────────────────────────────────────────── */
h1 {
    font-family: var(--ff-display) !important;
    font-size: 2.2rem !important;
    font-weight: 400 !important;
    color: var(--navy) !important;
    letter-spacing: -0.01em !important;
    line-height: 1.15 !important;
    margin-bottom: 0.2rem !important;
}
h2 {
    font-family: var(--ff-display) !important;
    font-size: 1.55rem !important;
    font-weight: 400 !important;
    color: var(--navy) !important;
    margin-top: 2rem !important;
}
h3 {
    font-family: var(--ff-body) !important;
    font-size: 0.72rem !important;
    font-weight: 700 !important;
    color: var(--muted) !important;
    text-transform: uppercase !important;
    letter-spacing: 0.1em !important;
    margin-bottom: 0.5rem !important;
}

/* ── Divider ───────────────────────────────────────────────────────────── */
hr {
    border: none !important;
    border-top: 1px solid var(--border) !important;
    margin: 1.75rem 0 !important;
}

/* ── Metric cards ──────────────────────────────────────────────────────── */
[data-testid="stMetric"] {
    background: var(--card) !important;
    border: 1px solid var(--border) !important;
    border-radius: 12px !important;
    padding: 1.25rem 1.5rem !important;
    box-shadow: var(--shadow-sm) !important;
}
[data-testid="stMetricLabel"] p {
    font-family: var(--ff-body) !important;
    font-size: 0.68rem !important;
    font-weight: 700 !important;
    text-transform: uppercase !important;
    letter-spacing: 0.1em !important;
    color: var(--muted) !important;
}
[data-testid="stMetricValue"] {
    font-family: var(--ff-mono) !important;
    font-size: 2.2rem !important;
    font-weight: 600 !important;
    color: var(--navy) !important;
    letter-spacing: -0.02em !important;
    line-height: 1.1 !important;
}

/* ── Tables ────────────────────────────────────────────────────────────── */
[data-testid="stTable"] table {
    border-collapse: collapse !important;
    width: 100% !important;
    border-radius: 10px !important;
    overflow: hidden !important;
    box-shadow: var(--shadow-sm) !important;
}
[data-testid="stTable"] th {
    background: var(--navy) !important;
    color: #8BB8E8 !important;
    font-family: var(--ff-body) !important;
    font-size: 0.68rem !important;
    font-weight: 700 !important;
    text-transform: uppercase !important;
    letter-spacing: 0.1em !important;
    padding: 0.75rem 1.1rem !important;
    border: none !important;
    white-space: nowrap !important;
}
[data-testid="stTable"] td {
    padding: 0.75rem 1.1rem !important;
    border-bottom: 1px solid var(--border) !important;
    border-left: none !important;
    border-right: none !important;
    color: var(--text) !important;
    font-family: var(--ff-body) !important;
    font-size: 0.9rem !important;
    background: var(--card) !important;
}
[data-testid="stTable"] td:nth-child(2) {
    font-family: var(--ff-mono) !important;
    font-size: 0.85rem !important;
    color: var(--navy3) !important;
}
[data-testid="stTable"] tr:last-child td { border-bottom: none !important; }
[data-testid="stTable"] tr:hover td { background: var(--bg) !important; }

/* ── Buttons ───────────────────────────────────────────────────────────── */
.stButton > button {
    font-family: var(--ff-body) !important;
    font-size: 0.92rem !important;
    font-weight: 600 !important;
    border-radius: 8px !important;
    padding: 0.55rem 1.75rem !important;
    transition: all 0.15s ease !important;
    letter-spacing: 0.01em !important;
}
.stButton > button[kind="primary"] {
    background: var(--blue) !important;
    color: #fff !important;
    border: none !important;
    box-shadow: 0 1px 3px rgba(15,108,189,.3) !important;
}
.stButton > button[kind="primary"]:hover {
    background: #0A5AA8 !important;
    box-shadow: var(--shadow-md) !important;
    transform: translateY(-1px) !important;
}
.stButton > button[kind="primary"]:disabled {
    background: #94A3B8 !important;
    box-shadow: none !important;
    transform: none !important;
}
.stButton > button[kind="secondary"] {
    background: transparent !important;
    color: var(--blue) !important;
    border: 1.5px solid var(--blue) !important;
}
.stButton > button[kind="secondary"]:hover {
    background: var(--blue-lt) !important;
}

/* ── Number / text inputs ──────────────────────────────────────────────── */
[data-testid="stNumberInput"] input,
[data-testid="stTextInput"] input {
    border: 1.5px solid var(--border) !important;
    border-radius: 8px !important;
    font-family: var(--ff-mono) !important;
    font-size: 1rem !important;
    font-weight: 500 !important;
    color: var(--text) !important;
    background: var(--card) !important;
    padding: 0.5rem 0.75rem !important;
    transition: border-color 0.15s ease, box-shadow 0.15s ease !important;
}
[data-testid="stNumberInput"] input:focus,
[data-testid="stTextInput"] input:focus {
    border-color: var(--blue) !important;
    box-shadow: 0 0 0 3px rgba(15,108,189,.15) !important;
    outline: none !important;
}

/* ── Selectbox ─────────────────────────────────────────────────────────── */
[data-testid="stSelectbox"] > div > div {
    border: 1.5px solid var(--border) !important;
    border-radius: 8px !important;
    background: var(--card) !important;
}

/* ── Radio ─────────────────────────────────────────────────────────────── */
[data-testid="stRadio"] > label {
    font-family: var(--ff-body) !important;
    font-size: 0.68rem !important;
    font-weight: 700 !important;
    text-transform: uppercase !important;
    letter-spacing: 0.1em !important;
    color: var(--muted) !important;
}

/* ── Widget labels ─────────────────────────────────────────────────────── */
[data-testid="stWidgetLabel"] p,
label p {
    font-family: var(--ff-body) !important;
    font-size: 0.78rem !important;
    font-weight: 600 !important;
    text-transform: uppercase !important;
    letter-spacing: 0.08em !important;
    color: var(--muted) !important;
}

/* ── Alert / info boxes ────────────────────────────────────────────────── */
[data-testid="stAlert"] {
    border-radius: 10px !important;
    border-left-width: 4px !important;
    font-size: 0.88rem !important;
    font-family: var(--ff-body) !important;
}

/* ── Caption ───────────────────────────────────────────────────────────── */
[data-testid="stCaptionContainer"] p,
.stCaption p {
    font-size: 0.76rem !important;
    color: var(--muted) !important;
    letter-spacing: 0.01em !important;
    font-family: var(--ff-body) !important;
}

/* ── Scrollbar ─────────────────────────────────────────────────────────── */
::-webkit-scrollbar { width: 5px; height: 5px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb { background: var(--border); border-radius: 3px; }
::-webkit-scrollbar-thumb:hover { background: var(--muted); }

/* ── Mobile ────────────────────────────────────────────────────────────── */
@media (max-width: 640px) {
  [data-testid="stMainBlockContainer"] {
    padding-top: 1.25rem !important;
    padding-left: 0.75rem !important;
    padding-right: 0.75rem !important;
  }
  h1 { font-size: 1.75rem !important; line-height: 1.2 !important; }
  .bmi-hero { flex-direction: column !important; }
  .bmi-hero-num { font-size: 3rem !important; }
  .bmi-hero-right { text-align: left !important; }
}
</style>
"""


def inject_css():
    st.html(_CSS)


def risk_chip(risk: str) -> str:
    p = RISK_PALETTE.get(risk, RISK_PALETTE["—"])
    return (
        f'<span style="display:inline-flex;align-items:center;gap:5px;'
        f'background:{p["bg"]};color:{p["text"]};border:1px solid {p["border"]};'
        f'border-radius:20px;padding:3px 10px 3px 8px;font-size:0.78rem;'
        f'font-weight:600;font-family:\'DM Sans\',sans-serif;white-space:nowrap;">'
        f'<span aria-hidden="true" style="width:6px;height:6px;border-radius:50%;'
        f'background:{p["dot"]};flex-shrink:0;"></span>{risk}</span>'
    )


def bmi_hero_html(
    bmi_val: float,
    category: str,
    risk: str,
    age: int,
    sex: str,
    ethnicity: str,
    height_display: str,
    weight_display: str,
) -> str:
    cat_color = CATEGORY_HERO.get(category, "#0F6CBD")
    p = RISK_PALETTE.get(risk, RISK_PALETTE["—"])
    return f"""
<div class="bmi-hero" role="region" aria-label="BMI Results Summary" style="
    background: linear-gradient(135deg, #0A1628 0%, #1E3A5F 100%);
    border-radius: 16px;
    padding: 2rem 2.5rem;
    margin: 1.25rem 0 1.75rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1.5rem;
    box-shadow: 0 8px 32px rgba(10,22,40,.22), 0 2px 8px rgba(10,22,40,.12);
    flex-wrap: wrap;
">
    <div>
        <p style="color:#8BB8E8;font-size:0.68rem;text-transform:uppercase;
            letter-spacing:0.12em;margin:0 0 0.4rem;
            font-family:'DM Sans',sans-serif;font-weight:700;">Standard BMI</p>
        <p class="bmi-hero-num" style="color:#FFFFFF;font-size:4rem;
            font-family:'JetBrains Mono','Courier New',monospace;
            font-weight:600;margin:0;line-height:1;letter-spacing:-0.02em;">{bmi_val:.2f}</p>
        <p style="color:#536780;font-size:0.78rem;margin:0.3rem 0 0;
            font-family:'DM Sans',sans-serif;">kg / m²</p>
    </div>
    <div class="bmi-hero-right" style="text-align:right;">
        <p style="color:{cat_color};font-size:1.9rem;
            font-family:'DM Serif Display',Georgia,serif;
            font-weight:400;margin:0 0 0.4rem;line-height:1.1;">{category}</p>
        <span style="display:inline-flex;align-items:center;gap:5px;
            background:{p["bg"]};color:{p["text"]};border:1px solid {p["border"]};
            border-radius:20px;padding:4px 12px 4px 9px;font-size:0.8rem;
            font-weight:600;font-family:'DM Sans',sans-serif;">
            <span aria-hidden="true" style="width:7px;height:7px;border-radius:50%;
                background:{p["dot"]};flex-shrink:0;"></span>
            Health risk: {risk}
        </span>
    </div>
</div>
<div style="
    background:#FFFFFF;border:1px solid #D9E4F0;border-radius:10px;
    padding:0.75rem 1.25rem;margin-bottom:1.5rem;
    display:flex;gap:2rem;flex-wrap:wrap;
    box-shadow:0 1px 3px rgba(10,22,40,.06);
">
    <span style="font-size:0.78rem;color:#536780;font-family:'DM Sans',sans-serif;">
        <b style="color:#0D1B2E;">Age</b> &nbsp;{age}
    </span>
    <span style="font-size:0.78rem;color:#536780;font-family:'DM Sans',sans-serif;">
        <b style="color:#0D1B2E;">Sex</b> &nbsp;{sex}
    </span>
    <span style="font-size:0.78rem;color:#536780;font-family:'DM Sans',sans-serif;">
        <b style="color:#0D1B2E;">Ethnicity</b> &nbsp;{ethnicity}
    </span>
    <span style="font-size:0.78rem;color:#536780;font-family:'DM Sans',sans-serif;">
        <b style="color:#0D1B2E;">Height</b> &nbsp;{height_display}
    </span>
    <span style="font-size:0.78rem;color:#536780;font-family:'DM Sans',sans-serif;">
        <b style="color:#0D1B2E;">Weight</b> &nbsp;{weight_display}
    </span>
</div>
"""


def indices_table_html(
    standard_bmi: float,
    new_bmi: float,
    pi: float,
    bsa: float,
    primary_category: str,
    primary_risk: str,
    new_bmi_category: str,
    new_bmi_risk: str,
    pi_category: str,
    pi_risk: str,
    whtr: float | None = None,
    whtr_category: str = "—",
    whtr_risk: str = "—",
) -> str:
    rows = [
        ("Standard BMI",       f"{standard_bmi:.2f}", "kg/m²", primary_category,  primary_risk),
        ("New BMI (Peterson)",  f"{new_bmi:.2f}",      "kg/m²", new_bmi_category,  new_bmi_risk),
        ("Ponderal Index",      f"{pi:.2f}",           "kg/m³", pi_category,        pi_risk),
        ("BSA (Mosteller)",     f"{bsa:.3f}",          "m²",    "—",                "—"),
    ]
    if whtr is not None:
        rows.append(("Waist-to-Height Ratio", f"{whtr:.3f}", "", whtr_category, whtr_risk))
    tbody = ""
    for i, (name, val, unit, cat, risk) in enumerate(rows):
        bg = "background:#FAFCFF" if i % 2 else "background:#FFFFFF"
        tbody += f"""
        <tr style="{bg};border-bottom:1px solid #D9E4F0;">
            <td style="padding:0.8rem 1.1rem;font-family:'DM Sans',sans-serif;
                font-size:0.9rem;color:#0D1B2E;font-weight:500;">{name}</td>
            <td style="padding:0.8rem 1.1rem;">
                <span style="font-family:'JetBrains Mono',monospace;font-size:0.88rem;
                    font-weight:600;color:#1E3A5F;">{val}</span>
                <span style="font-size:0.72rem;color:#536780;margin-left:3px;">{unit}</span>
            </td>
            <td style="padding:0.8rem 1.1rem;font-family:'DM Sans',sans-serif;
                font-size:0.88rem;color:#536780;">{cat}</td>
            <td style="padding:0.8rem 1.1rem;">{risk_chip(risk)}</td>
        </tr>"""
    return f"""
<div role="region" aria-label="All Indices" style="overflow-x:auto;-webkit-overflow-scrolling:touch;margin:0.5rem 0 1.5rem;">
<div style="border-radius:12px;overflow:hidden;min-width:480px;
    box-shadow:0 1px 3px rgba(10,22,40,.08),0 1px 2px rgba(10,22,40,.05);">
<table style="width:100%;border-collapse:collapse;">
    <thead>
        <tr style="background:#0A1628;">
            <th scope="col" style="padding:0.7rem 1.1rem;text-align:left;color:#8BB8E8;
                font-family:'DM Sans',sans-serif;font-size:0.65rem;
                font-weight:700;text-transform:uppercase;letter-spacing:0.1em;
                border:none;">Index</th>
            <th scope="col" style="padding:0.7rem 1.1rem;text-align:left;color:#8BB8E8;
                font-family:'DM Sans',sans-serif;font-size:0.65rem;
                font-weight:700;text-transform:uppercase;letter-spacing:0.1em;
                border:none;">Value</th>
            <th scope="col" style="padding:0.7rem 1.1rem;text-align:left;color:#8BB8E8;
                font-family:'DM Sans',sans-serif;font-size:0.65rem;
                font-weight:700;text-transform:uppercase;letter-spacing:0.1em;
                border:none;">Classification</th>
            <th scope="col" style="padding:0.7rem 1.1rem;text-align:left;color:#8BB8E8;
                font-family:'DM Sans',sans-serif;font-size:0.65rem;
                font-weight:700;text-transform:uppercase;letter-spacing:0.1em;
                border:none;">Health Risk</th>
        </tr>
    </thead>
    <tbody>{tbody}</tbody>
</table>
</div>
</div>"""


def bf_table_html(rows: list[tuple[str, float, str, str]]) -> str:
    """rows: [(method_name, bf_pct, category, risk_key), ...]"""
    tbody = ""
    for i, (method, bf_pct, category, risk) in enumerate(rows):
        bg = "background:#FAFCFF" if i % 2 else "background:#FFFFFF"
        tbody += f"""
        <tr style="{bg};border-bottom:1px solid #D9E4F0;">
            <td style="padding:0.8rem 1.1rem;font-family:'DM Sans',sans-serif;
                font-size:0.9rem;color:#0D1B2E;font-weight:500;">{method}</td>
            <td style="padding:0.8rem 1.1rem;">
                <span style="font-family:'JetBrains Mono',monospace;font-size:0.88rem;
                    font-weight:600;color:#1E3A5F;">{bf_pct:.1f}%</span>
            </td>
            <td style="padding:0.8rem 1.1rem;font-family:'DM Sans',sans-serif;
                font-size:0.88rem;color:#536780;">{category}</td>
            <td style="padding:0.8rem 1.1rem;">{risk_chip(risk)}</td>
        </tr>"""
    return f"""
<div style="overflow-x:auto;-webkit-overflow-scrolling:touch;margin:0.5rem 0 1rem;">
<div style="border-radius:12px;overflow:hidden;min-width:400px;
    box-shadow:0 1px 3px rgba(10,22,40,.08),0 1px 2px rgba(10,22,40,.05);">
<table style="width:100%;border-collapse:collapse;">
    <thead>
        <tr style="background:#0A1628;">
            <th scope="col" style="padding:0.7rem 1.1rem;text-align:left;color:#8BB8E8;
                font-family:'DM Sans',sans-serif;font-size:0.65rem;font-weight:700;
                text-transform:uppercase;letter-spacing:0.1em;border:none;">Method</th>
            <th scope="col" style="padding:0.7rem 1.1rem;text-align:left;color:#8BB8E8;
                font-family:'DM Sans',sans-serif;font-size:0.65rem;font-weight:700;
                text-transform:uppercase;letter-spacing:0.1em;border:none;">Body Fat %</th>
            <th scope="col" style="padding:0.7rem 1.1rem;text-align:left;color:#8BB8E8;
                font-family:'DM Sans',sans-serif;font-size:0.65rem;font-weight:700;
                text-transform:uppercase;letter-spacing:0.1em;border:none;">Category</th>
            <th scope="col" style="padding:0.7rem 1.1rem;text-align:left;color:#8BB8E8;
                font-family:'DM Sans',sans-serif;font-size:0.65rem;font-weight:700;
                text-transform:uppercase;letter-spacing:0.1em;border:none;">Risk</th>
        </tr>
    </thead>
    <tbody>{tbody}</tbody>
</table>
</div>
</div>"""


def ibw_table_html(
    weight_kg: float,
    hamwi_kg: float,
    devine_kg: float,
    robinson_kg: float,
    miller_kg: float,
    is_imperial: bool = False,
    sex: str = "Male",
) -> str:
    def _fmt(kg: float) -> str:
        if is_imperial:
            return f"{kg_to_lbs(kg):.1f} lbs"
        return f"{kg:.1f} kg"

    def _delta_chip(ibw_kg: float) -> str:
        pct = (weight_kg - ibw_kg) / ibw_kg * 100
        sign = "+" if pct >= 0 else ""
        if pct > 20:
            bg, fg = "#FEE2E2", "#7F1D1D"
        elif pct > 5:
            bg, fg = "#FEF3C7", "#78350F"
        elif pct >= -5:
            bg, fg = "#DBEAFE", "#1E3A8A"
        else:
            bg, fg = "#D1FAE5", "#065F46"
        return (
            f'<span style="background:{bg};color:{fg};border-radius:4px;'
            f'padding:2px 8px;font-size:0.8rem;font-weight:600;'
            f'font-family:\'DM Sans\',sans-serif;">{sign}{pct:.1f}%</span>'
        )

    avg_kg = (hamwi_kg + devine_kg + robinson_kg + miller_kg) / 4
    avg_pct = (weight_kg - avg_kg) / avg_kg * 100
    avg_sign = "+" if avg_pct >= 0 else ""
    direction = "above" if avg_pct >= 0 else "below"

    if avg_pct > 20:
        sum_bg, sum_border, sum_text = "#FEE2E2", "#F87171", "#7F1D1D"
    elif avg_pct > 5:
        sum_bg, sum_border, sum_text = "#FEF3C7", "#F59E0B", "#78350F"
    elif avg_pct >= -5:
        sum_bg, sum_border, sum_text = "#DBEAFE", "#3B82F6", "#1E3A8A"
    else:
        sum_bg, sum_border, sum_text = "#D1FAE5", "#059669", "#065F46"

    sex_note = " (averaged across male/female formulas)" if sex == "Other" else ""
    short_height_note = ""

    formulas = [
        ("Hamwi", "1964", hamwi_kg),
        ("Devine", "1974", devine_kg),
        ("Robinson", "1983", robinson_kg),
        ("Miller", "1983", miller_kg),
    ]
    tbody = ""
    for i, (name, year, ibw_kg) in enumerate(formulas):
        bg = "background:#FAFCFF" if i % 2 else "background:#FFFFFF"
        tbody += f"""
        <tr style="{bg};border-bottom:1px solid #D9E4F0;">
            <td style="padding:0.8rem 1.1rem;font-family:'DM Sans',sans-serif;
                font-size:0.9rem;color:#0D1B2E;font-weight:500;">{name}
                <span style="font-size:0.72rem;color:#536780;margin-left:4px;">({year})</span>
            </td>
            <td style="padding:0.8rem 1.1rem;">
                <span style="font-family:'JetBrains Mono',monospace;font-size:0.88rem;
                    font-weight:600;color:#1E3A5F;">{_fmt(ibw_kg)}</span>
            </td>
            <td style="padding:0.8rem 1.1rem;">{_delta_chip(ibw_kg)}</td>
        </tr>"""

    return f"""
<div style="overflow-x:auto;-webkit-overflow-scrolling:touch;margin:0.5rem 0 0.75rem;">
<div style="border-radius:12px;overflow:hidden;min-width:360px;
    box-shadow:0 1px 3px rgba(10,22,40,.08),0 1px 2px rgba(10,22,40,.05);">
<table style="width:100%;border-collapse:collapse;">
    <thead>
        <tr style="background:#0A1628;">
            <th scope="col" style="padding:0.7rem 1.1rem;text-align:left;color:#8BB8E8;
                font-family:'DM Sans',sans-serif;font-size:0.65rem;font-weight:700;
                text-transform:uppercase;letter-spacing:0.1em;border:none;">Formula</th>
            <th scope="col" style="padding:0.7rem 1.1rem;text-align:left;color:#8BB8E8;
                font-family:'DM Sans',sans-serif;font-size:0.65rem;font-weight:700;
                text-transform:uppercase;letter-spacing:0.1em;border:none;">IBW</th>
            <th scope="col" style="padding:0.7rem 1.1rem;text-align:left;color:#8BB8E8;
                font-family:'DM Sans',sans-serif;font-size:0.65rem;font-weight:700;
                text-transform:uppercase;letter-spacing:0.1em;border:none;">% from Actual</th>
        </tr>
    </thead>
    <tbody>{tbody}</tbody>
</table>
</div>
</div>
<div style="background:{sum_bg};border:1px solid {sum_border};border-left:4px solid {sum_border};
    border-radius:10px;padding:0.85rem 1.25rem;font-size:0.88rem;color:{sum_text};
    font-family:'DM Sans',sans-serif;line-height:1.6;margin-bottom:0.5rem;">
    <b>Average IBW across all formulas: {_fmt(avg_kg)}</b>{sex_note}.
    Your actual weight is <b>{avg_sign}{avg_pct:.1f}%</b> {direction} the average IBW. [10–13]
</div>"""


def bmi_scale_html(bmi_val: float, is_asian: bool = False) -> str:
    """Horizontal SVG gauge showing where bmi_val falls across WHO categories."""
    BAR_X, BAR_Y, BAR_W, BAR_H = 20.0, 50.0, 560.0, 26.0
    SCALE_LO, SCALE_HI = 10.0, 45.0
    SCALE_RANGE = SCALE_HI - SCALE_LO

    def to_px(v: float) -> float:
        return BAR_X + (v - SCALE_LO) / SCALE_RANGE * BAR_W

    if is_asian:
        bands = [
            (10.0, 18.5, "#10B981", "Underweight"),
            (18.5, 23.0, "#2563EB", "Normal"),
            (23.0, 27.5, "#D97706", "Overweight"),
            (27.5, 45.0, "#DC2626", "Obese"),
        ]
        ticks = [18.5, 23.0, 27.5]
        title_text = "BMI Scale — Asian Cutoffs (WHO 2004)"
    else:
        bands = [
            (10.0, 18.5, "#10B981", "Underweight"),
            (18.5, 25.0, "#2563EB", "Normal"),
            (25.0, 30.0, "#D97706", "Overweight"),
            (30.0, 35.0, "#DC2626", "Obese I"),
            (35.0, 40.0, "#BE123C", "Obese II"),
            (40.0, 45.0, "#9F1239", "Obese III"),
        ]
        ticks = [18.5, 25.0, 30.0, 35.0, 40.0]
        title_text = "BMI Scale — WHO Standard"

    # Colored band rects (rendered inside clipPath for rounded corners)
    rects_svg = ""
    labels_svg = ""
    for lo, hi, color, label in bands:
        x1 = to_px(lo)
        x2 = to_px(hi)
        w = x2 - x1
        mid_x = (x1 + x2) / 2.0
        mid_y = BAR_Y + BAR_H / 2.0 + 4.0
        rects_svg += (
            f'<rect x="{x1:.1f}" y="{BAR_Y:.0f}" '
            f'width="{w:.1f}" height="{BAR_H:.0f}" fill="{color}"/>'
        )
        if w >= 32:
            labels_svg += (
                f'<text x="{mid_x:.1f}" y="{mid_y:.1f}" text-anchor="middle" '
                f'font-family="DM Sans,sans-serif" font-size="8.5" font-weight="600" '
                f'fill="rgba(255,255,255,0.93)" pointer-events="none">{label}</text>'
            )

    # Tick marks and boundary value labels below bar
    bar_bot = BAR_Y + BAR_H
    tick_y2 = bar_bot + 6.0
    lbl_y = bar_bot + 18.0
    ticks_svg = ""
    for v in ticks:
        tx = to_px(v)
        ticks_svg += (
            f'<line x1="{tx:.1f}" y1="{bar_bot:.0f}" x2="{tx:.1f}" y2="{tick_y2:.0f}" '
            f'stroke="#CBD5E1" stroke-width="1.5"/>'
            f'<text x="{tx:.1f}" y="{lbl_y:.0f}" text-anchor="middle" '
            f'font-family="DM Sans,sans-serif" font-size="9" fill="#536780">{v}</text>'
        )
    ticks_svg += (
        f'<text x="{BAR_X:.0f}" y="{lbl_y:.0f}" text-anchor="middle" '
        f'font-family="DM Sans,sans-serif" font-size="9" fill="#94A3B8">10</text>'
        f'<text x="{BAR_X + BAR_W:.0f}" y="{lbl_y:.0f}" text-anchor="middle" '
        f'font-family="DM Sans,sans-serif" font-size="9" fill="#94A3B8">45+</text>'
    )

    # Marker: white vertical line + downward triangle + value label
    mx = to_px(max(10.1, min(44.9, bmi_val)))
    tri_tip_y = BAR_Y - 2.0
    tri_base_y = BAR_Y - 14.0
    tri_l = mx - 6.0
    tri_r = mx + 6.0
    val_y = tri_base_y - 4.0
    marker_svg = (
        f'<line x1="{mx:.1f}" y1="{BAR_Y:.0f}" x2="{mx:.1f}" y2="{bar_bot:.0f}" '
        f'stroke="rgba(255,255,255,0.85)" stroke-width="2"/>'
        f'<polygon points="{mx:.1f},{tri_tip_y:.0f} {tri_l:.1f},{tri_base_y:.0f} {tri_r:.1f},{tri_base_y:.0f}" '
        f'fill="#0A1628"/>'
        f'<text x="{mx:.1f}" y="{val_y:.0f}" text-anchor="middle" '
        f'font-family="JetBrains Mono,monospace" font-size="11" font-weight="600" '
        f'fill="#0A1628">{bmi_val:.2f}</text>'
    )

    clip = (
        f'<defs><clipPath id="bmi-scale-clip">'
        f'<rect x="{BAR_X:.0f}" y="{BAR_Y:.0f}" '
        f'width="{BAR_W:.0f}" height="{BAR_H:.0f}" rx="6" ry="6"/>'
        f'</clipPath></defs>'
    )
    aria = f"BMI scale chart. Your BMI of {bmi_val:.2f} is marked on the scale."

    return f"""<div style="background:#FFFFFF;border:1px solid #D9E4F0;border-radius:12px;
    padding:1.25rem 1.5rem 0.75rem;margin:0 0 1.5rem;
    box-shadow:0 1px 3px rgba(10,22,40,.06);">
  <p style="font-family:'DM Sans',sans-serif;font-size:0.68rem;font-weight:700;
      text-transform:uppercase;letter-spacing:0.1em;color:#536780;margin:0 0 0.75rem;">{title_text}</p>
  <svg viewBox="0 0 600 100" width="100%" xmlns="http://www.w3.org/2000/svg"
       role="img" aria-label="{aria}">
    {clip}
    <g clip-path="url(#bmi-scale-clip)">{rects_svg}</g>
    {labels_svg}
    {ticks_svg}
    {marker_svg}
  </svg>
</div>"""


def section_label(text: str) -> str:
    return (
        f'<p role="heading" aria-level="2" style="font-family:\'DM Sans\',sans-serif;font-size:0.68rem;'
        f'font-weight:700;text-transform:uppercase;letter-spacing:0.1em;'
        f'color:#536780;margin:1.5rem 0 0.5rem;">{text}</p>'
    )


def formula_card_open(title: str, citation: str) -> str:
    return f"""
<div style="background:#FFFFFF;border:1px solid #D9E4F0;border-radius:12px;
    padding:1.5rem 1.75rem;margin:0 0 1rem;
    box-shadow:0 1px 3px rgba(10,22,40,.06);">
    <div style="display:flex;justify-content:space-between;align-items:baseline;
        flex-wrap:wrap;gap:0.4rem;margin-bottom:0.75rem;">
        <p role="heading" aria-level="3" style="font-family:'DM Serif Display',serif;font-size:1.2rem;
            color:#0A1628;margin:0;">{title}</p>
        <span style="font-size:0.72rem;color:#536780;font-family:'DM Sans',sans-serif;
            background:#EEF3FA;padding:2px 8px;border-radius:4px;">{citation}</span>
    </div>"""


def formula_card_close(description: str) -> str:
    return f"""
    <p style="font-family:'DM Sans',sans-serif;font-size:0.88rem;
        color:#536780;margin:0.75rem 0 0;line-height:1.6;">{description}</p>
</div>"""
