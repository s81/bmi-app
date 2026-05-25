# BMI Calculator Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a professional, scientifically-grounded multi-page Streamlit BMI calculator app with four validated indices, WHO/Asian classification tables, and a full scientific report output.

**Architecture:** Pure Python `core/` layer (zero Streamlit dependency) handles all math and classification logic. Three Streamlit pages (`Calculator`, `Results`, `Methodology`) are thin rendering wrappers. Data flows through `st.session_state` from Calculator to Results.

**Tech Stack:** Python 3.10+, Streamlit, pytest

---

## File Map

| File | Responsibility |
|---|---|
| `requirements.txt` | Project dependencies |
| `app.py` | Streamlit entry point, app config |
| `core/bmi.py` | All index calculations + unit conversion (pure functions) |
| `core/classifications.py` | WHO standard, WHO Asian, Ponderal cutoff tables + classify() functions |
| `pages/1_Calculator.py` | Input form, validation, session state write |
| `pages/2_Results.py` | Full scientific report render, session state read |
| `pages/3_Methodology.py` | Static formulas, tables, references |
| `tests/test_bmi.py` | Unit tests for bmi.py |
| `tests/test_classifications.py` | Unit tests for classifications.py |

---

## Task 1: Project Scaffold

**Files:**
- Create: `requirements.txt`
- Create: `app.py`
- Create: `core/__init__.py`
- Create: `pages/__init__.py` (empty)
- Create: `tests/__init__.py` (empty)

- [ ] **Step 1: Create requirements.txt**

```
streamlit>=1.35.0
pytest>=8.0.0
```

- [ ] **Step 2: Create app.py**

```python
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
```

- [ ] **Step 3: Create empty init files**

```bash
mkdir -p core pages tests
touch core/__init__.py pages/__init__.py tests/__init__.py
```

- [ ] **Step 4: Install dependencies**

```bash
pip install -r requirements.txt
```

Expected: streamlit and pytest install without errors.

- [ ] **Step 5: Verify app launches**

```bash
streamlit run app.py
```

Expected: Browser opens, home page displays with title and info banner.

- [ ] **Step 6: Commit**

```bash
git add requirements.txt app.py core/__init__.py pages/__init__.py tests/__init__.py
git commit -m "feat: scaffold Streamlit multi-page app"
```

---

## Task 2: Unit Conversion (TDD)

**Files:**
- Create: `core/bmi.py` (conversion functions only)
- Create: `tests/test_bmi.py`

- [ ] **Step 1: Write failing tests for unit conversion**

Create `tests/test_bmi.py`:

```python
from core.bmi import lbs_to_kg, kg_to_lbs, inches_to_cm, cm_to_inches


def test_lbs_to_kg():
    assert abs(lbs_to_kg(154.32) - 70.0) < 0.01


def test_kg_to_lbs():
    assert abs(kg_to_lbs(70.0) - 154.32) < 0.1


def test_inches_to_cm():
    assert abs(inches_to_cm(70.0) - 177.8) < 0.1


def test_cm_to_inches():
    assert abs(cm_to_inches(177.8) - 70.0) < 0.1


def test_lbs_to_kg_round_trip():
    original = 80.0
    assert abs(lbs_to_kg(kg_to_lbs(original)) - original) < 0.001


def test_inches_to_cm_round_trip():
    original = 175.0
    assert abs(inches_to_cm(cm_to_inches(original)) - original) < 0.001
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
pytest tests/test_bmi.py -v
```

Expected: `ModuleNotFoundError` or `ImportError` — `core.bmi` doesn't exist yet.

- [ ] **Step 3: Implement conversion functions in core/bmi.py**

```python
def lbs_to_kg(lbs: float) -> float:
    return lbs * 0.453592


def kg_to_lbs(kg: float) -> float:
    return kg / 0.453592


def inches_to_cm(inches: float) -> float:
    return inches * 2.54


def cm_to_inches(cm: float) -> float:
    return cm / 2.54
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
pytest tests/test_bmi.py -v
```

Expected: 6 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add core/bmi.py tests/test_bmi.py
git commit -m "feat: add unit conversion functions with tests"
```

---

## Task 3: BMI Index Calculations (TDD)

**Files:**
- Modify: `core/bmi.py` (add index functions)
- Modify: `tests/test_bmi.py` (add index tests)

- [ ] **Step 1: Write failing tests for all four indices**

Append to `tests/test_bmi.py`:

```python
from core.bmi import calc_standard_bmi, calc_new_bmi, calc_ponderal_index, calc_bsa


def test_standard_bmi_known_value():
    # 70 kg, 1.75 m → 70 / 1.75² = 22.86
    assert abs(calc_standard_bmi(70.0, 1.75) - 22.86) < 0.01


def test_standard_bmi_overweight_boundary():
    # BMI exactly 25.0: weight = 25 * 1.75² = 76.5625 kg
    assert abs(calc_standard_bmi(76.5625, 1.75) - 25.0) < 0.01


def test_new_bmi_known_value():
    # 70 kg, 1.75 m → 1.3 * 70 / 1.75^2.5 = 1.3 * 70 / 4.0509 ≈ 22.47
    assert abs(calc_new_bmi(70.0, 1.75) - 22.47) < 0.1


def test_ponderal_index_known_value():
    # 70 kg, 1.75 m → 70 / 1.75³ = 70 / 5.359 ≈ 13.06
    assert abs(calc_ponderal_index(70.0, 1.75) - 13.06) < 0.1


def test_bsa_known_value():
    # height=175 cm, weight=70 kg → sqrt(175*70/3600) = sqrt(3.4028) ≈ 1.845
    assert abs(calc_bsa(175.0, 70.0) - 1.845) < 0.01


def test_standard_bmi_height_in_meters():
    # Ensure height is expected in meters, not cm
    result = calc_standard_bmi(70.0, 175.0)
    # 70 / 175² = 0.00229 — clearly wrong if height were meters
    assert result < 1.0  # Would be ~0.002, proving meters not cm expected


def test_standard_bmi_height_in_meters_correct():
    # Positive confirmation: 1.75 m gives physiological result
    result = calc_standard_bmi(70.0, 1.75)
    assert 15.0 < result < 35.0
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
pytest tests/test_bmi.py -v -k "bmi or ponderal or bsa"
```

Expected: `ImportError` — functions not yet defined.

- [ ] **Step 3: Implement index functions in core/bmi.py**

Append to `core/bmi.py`:

```python
import math


def calc_standard_bmi(weight_kg: float, height_m: float) -> float:
    return weight_kg / (height_m ** 2)


def calc_new_bmi(weight_kg: float, height_m: float) -> float:
    return 1.3 * weight_kg / (height_m ** 2.5)


def calc_ponderal_index(weight_kg: float, height_m: float) -> float:
    return weight_kg / (height_m ** 3)


def calc_bsa(height_cm: float, weight_kg: float) -> float:
    return math.sqrt(height_cm * weight_kg / 3600)
```

- [ ] **Step 4: Run all tests to verify they pass**

```bash
pytest tests/test_bmi.py -v
```

Expected: All tests PASS.

- [ ] **Step 5: Commit**

```bash
git add core/bmi.py tests/test_bmi.py
git commit -m "feat: add four BMI index calculation functions with tests"
```

---

## Task 4: Classification Tables (TDD)

**Files:**
- Create: `core/classifications.py`
- Create: `tests/test_classifications.py`

- [ ] **Step 1: Write failing tests**

Create `tests/test_classifications.py`:

```python
from core.classifications import (
    classify_who_standard,
    classify_who_asian,
    classify_ponderal,
    classify_new_bmi,
    get_risk_color,
)


# WHO Standard
def test_who_underweight():
    assert classify_who_standard(17.0) == ("Underweight", "Low (but other risks)")

def test_who_normal():
    assert classify_who_standard(22.0) == ("Normal weight", "Average")

def test_who_normal_upper_boundary():
    assert classify_who_standard(24.9) == ("Normal weight", "Average")

def test_who_overweight_lower_boundary():
    assert classify_who_standard(25.0) == ("Overweight", "Increased")

def test_who_obese_i():
    assert classify_who_standard(32.0) == ("Obese Class I", "High")

def test_who_obese_ii():
    assert classify_who_standard(37.0) == ("Obese Class II", "Very High")

def test_who_obese_iii():
    assert classify_who_standard(42.0) == ("Obese Class III", "Extremely High")


# WHO Asian
def test_asian_normal_upper_boundary():
    assert classify_who_asian(22.9) == ("Normal weight", "Average")

def test_asian_overweight_lower_boundary():
    assert classify_who_asian(23.0) == ("Overweight", "Increased")

def test_asian_obese_lower_boundary():
    assert classify_who_asian(27.5) == ("Obese", "High")


# Ethnicity branching — same BMI, different result
def test_ethnicity_branching():
    bmi = 24.0
    who_result = classify_who_standard(bmi)
    asian_result = classify_who_asian(bmi)
    assert who_result[0] == "Normal weight"
    assert asian_result[0] == "Overweight"


# Ponderal Index
def test_ponderal_underweight():
    assert classify_ponderal(10.0)[0] == "Underweight"

def test_ponderal_normal():
    assert classify_ponderal(12.0)[0] == "Normal"

def test_ponderal_overweight():
    assert classify_ponderal(15.0)[0] == "Overweight"


# New BMI uses WHO Standard thresholds
def test_new_bmi_classification_delegates_to_who_standard():
    assert classify_new_bmi(22.0) == classify_who_standard(22.0)
    assert classify_new_bmi(25.0) == classify_who_standard(25.0)


# Risk color
def test_risk_color_normal():
    assert get_risk_color("Average") == "green"

def test_risk_color_increased():
    assert get_risk_color("Increased") == "orange"

def test_risk_color_high():
    assert get_risk_color("High") == "red"
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
pytest tests/test_classifications.py -v
```

Expected: `ImportError` — module doesn't exist yet.

- [ ] **Step 3: Implement classifications.py**

Create `core/classifications.py`:

```python
def classify_who_standard(bmi: float) -> tuple[str, str]:
    if bmi < 18.5:
        return ("Underweight", "Low (but other risks)")
    elif bmi < 25.0:
        return ("Normal weight", "Average")
    elif bmi < 30.0:
        return ("Overweight", "Increased")
    elif bmi < 35.0:
        return ("Obese Class I", "High")
    elif bmi < 40.0:
        return ("Obese Class II", "Very High")
    else:
        return ("Obese Class III", "Extremely High")


def classify_who_asian(bmi: float) -> tuple[str, str]:
    if bmi < 18.5:
        return ("Underweight", "Low (but other risks)")
    elif bmi < 23.0:
        return ("Normal weight", "Average")
    elif bmi < 27.5:
        return ("Overweight", "Increased")
    else:
        return ("Obese", "High")


def classify_ponderal(pi: float) -> tuple[str, str]:
    if pi < 11.0:
        return ("Underweight", "Low")
    elif pi <= 14.0:
        return ("Normal", "Average")
    else:
        return ("Overweight", "Elevated")


def classify_new_bmi(new_bmi: float) -> tuple[str, str]:
    return classify_who_standard(new_bmi)


def get_risk_color(risk: str) -> str:
    mapping = {
        "Low (but other risks)": "blue",
        "Average": "green",
        "Increased": "orange",
        "High": "red",
        "Very High": "red",
        "Extremely High": "red",
        "Low": "blue",
        "Elevated": "orange",
    }
    return mapping.get(risk, "gray")
```

- [ ] **Step 4: Run all tests**

```bash
pytest tests/ -v
```

Expected: All tests PASS.

- [ ] **Step 5: Commit**

```bash
git add core/classifications.py tests/test_classifications.py
git commit -m "feat: add classification tables with WHO standard, Asian cutoffs, and Ponderal Index"
```

---

## Task 5: Calculator Page

**Files:**
- Create: `pages/1_Calculator.py`

- [ ] **Step 1: Create the Calculator page**

Create `pages/1_Calculator.py`:

```python
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
```

- [ ] **Step 2: Verify the page renders without errors**

```bash
streamlit run app.py
```

Navigate to Calculator in the sidebar. Verify:
- Unit toggle switches labels
- Ethnicity dropdown has tooltip (hover over `?`)
- "Calculate →" button is present
- Entering an out-of-range value shows an error and disables the button

- [ ] **Step 3: Commit**

```bash
git add pages/1_Calculator.py
git commit -m "feat: add Calculator input page with validation and session state"
```

---

## Task 6: Results Page

**Files:**
- Create: `pages/2_Results.py`

- [ ] **Step 1: Create the Results page**

Create `pages/2_Results.py`:

```python
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
```

- [ ] **Step 2: Verify the Results page renders correctly**

```bash
streamlit run app.py
```

1. Go to Calculator, enter values (e.g., 70 kg, 175 cm, General population), click "Calculate →"
2. Verify: Summary card shows BMI value and color-coded category
3. Verify: All indices table shows four rows with values
4. Verify: Risk interpretation paragraph is present with references
5. Go to Calculator, switch to Asian ethnicity, recalculate
6. Verify: Ethnicity note appears; overweight threshold kicks in at BMI 23

- [ ] **Step 3: Commit**

```bash
git add pages/2_Results.py
git commit -m "feat: add Results page with full scientific report"
```

---

## Task 7: Methodology Page

**Files:**
- Create: `pages/3_Methodology.py`

- [ ] **Step 1: Create the Methodology page**

Create `pages/3_Methodology.py`:

```python
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
```

- [ ] **Step 2: Verify the Methodology page**

```bash
streamlit run app.py
```

Navigate to Methodology. Verify:
- All four formulas render as proper LaTeX
- Two classification tables render (WHO Standard + Asian)
- Full reference list is visible

- [ ] **Step 3: Run full test suite**

```bash
pytest tests/ -v
```

Expected: All tests PASS.

- [ ] **Step 4: Commit**

```bash
git add pages/3_Methodology.py
git commit -m "feat: add Methodology page with LaTeX formulas, classification tables, and references"
```

---

## Task 8: End-to-End Smoke Test

**No new files** — manual verification of the golden path and edge cases.

- [ ] **Step 1: Golden path — metric, general population**

```
Height: 175 cm, Weight: 70 kg, Age: 30, Sex: Male, Ethnicity: General population
```
Expected BMI: 22.86 — "Normal weight", green badge.

- [ ] **Step 2: Golden path — imperial, Asian ethnicity**

```
Height: 68 in (172.7 cm), Weight: 143 lbs (64.9 kg), Age: 40, Sex: Female, Ethnicity: Asian (East/South)
```
Expected BMI: ~21.7 — Standard WHO: "Normal weight", Asian cutoffs: "Normal weight" (< 23).
Verify ethnicity note appears.

- [ ] **Step 3: Overweight boundary — Asian vs General**

```
Height: 170 cm, Weight: 66.6 kg → BMI ≈ 23.0
```
- General population: "Normal weight" (23.0 < 25.0)
- Asian: "Overweight" (23.0 ≥ 23.0)

Verify ethnicity branching works correctly.

- [ ] **Step 4: Session state guard**

Navigate directly to `http://localhost:8501/Results` without submitting the Calculator.
Expected: Warning message + "Go to Calculator" button appears. No crash.

- [ ] **Step 5: Out-of-bounds validation**

Enter height = 10 cm (below 50 cm minimum).
Expected: Error message shown, "Calculate →" button disabled.

- [ ] **Step 6: Final commit**

```bash
git add .
git commit -m "chore: complete BMI calculator step 1 implementation"
```
