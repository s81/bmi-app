# BMI Calculator Web App — Design Spec

**Date:** 2026-05-25
**Status:** Approved
**Step:** 1 of N (foundation)

---

## Overview

A professional, scientifically-grounded BMI calculator web app built with Streamlit (Python). Targets health professionals, fitness coaches, researchers, and students. Produces a full scientific report covering multiple validated indices, WHO classification tables, ethnicity-adjusted cutoffs, and cited references.

---

## Target Audience

- Health professionals and fitness coaches (clinical accuracy, risk classification)
- Researchers and students (formulas, methodology, scientific references)

---

## Architecture

```
first-app/
├── app.py                        # Entry point, Streamlit multi-page config
├── pages/
│   ├── 1_Calculator.py           # Input form
│   ├── 2_Results.py              # Full scientific report
│   └── 3_Methodology.py          # Formulas, tables, references (static)
├── core/
│   ├── bmi.py                    # All calculation logic (pure functions, no Streamlit)
│   └── classifications.py        # WHO, Asian, Ponderal, New BMI cutoff tables
├── tests/
│   ├── test_bmi.py
│   └── test_classifications.py
└── requirements.txt
```

**Key principle:** `core/` has zero Streamlit dependency. All math is pure Python — independently testable and reusable (e.g., if an API layer is added in a future step). Pages are thin wrappers that call `core/` and render results.

**Data flow:**
1. User fills form on Calculator page → values stored in `st.session_state`
2. User clicks "Calculate →" → navigates to Results page
3. Results page reads session state, calls `core/bmi.py`, renders full report
4. Methodology page is static — no state needed, always accessible

---

## Calculations & Science

### Indices

| Index | Formula | Source |
|---|---|---|
| Standard BMI | weight(kg) / height(m)² | WHO, 1995 |
| New BMI (Peterson) | 1.3 × weight(kg) / height(m)^2.5 | Peterson et al., 2016 |
| Ponderal Index | weight(kg) / height(m)³ | Rohrer, 1921 |
| BSA (Mosteller) | √(height(cm) × weight(kg) / 3600) | Mosteller, 1987 |

### Classification Tables

**WHO Standard BMI:**
| Range | Category |
|---|---|
| < 18.5 | Underweight |
| 18.5 – 24.9 | Normal weight |
| 25.0 – 29.9 | Overweight |
| 30.0 – 34.9 | Obese Class I |
| 35.0 – 39.9 | Obese Class II |
| ≥ 40.0 | Obese Class III |

**WHO Asian Cutoffs (East/South Asian ethnicity):**
| Range | Category |
|---|---|
| < 18.5 | Underweight |
| 18.5 – 22.9 | Normal weight |
| 23.0 – 27.4 | Overweight |
| ≥ 27.5 | Obese |

**Ponderal Index:**
| Range | Category |
|---|---|
| < 11 | Underweight |
| 11 – 14 | Normal |
| > 14 | Overweight |

**New BMI:** Uses same WHO Standard thresholds (formula corrects for height bias, same scale).

### Notes on Age and Sex

Age and Sex are collected on the Calculator page but are **not used in any formula in this step**. They are stored in session state for future use (e.g., pediatric BMI-for-age percentiles, sex-specific body fat estimation). In this step they appear on the Results page as context fields only.

### Unit Handling

Imperial-to-metric conversion happens once at the input boundary. All internal calculations use metric (kg, meters). No dual-path logic in the math.

### Ethnicity Options

- General population (WHO standard cutoffs)
- Asian — East/South (WHO Asian cutoffs)
- Other (defaults to WHO standard)

A tooltip on the ethnicity field explains why cutoffs differ clinically.

---

## Pages & UI

### Page 1: Calculator

- Unit toggle: Metric / Imperial (switches input labels dynamically)
- Inputs: Age, Sex (Male / Female / Other), Ethnicity (General / Asian / Other), Height, Weight
- "Calculate →" button — validates inputs before proceeding
- Inline validation with `st.error()` for out-of-bounds values

### Page 2: Results

Four sections rendered in order:

1. **Summary card** — BMI value (large), WHO category, color-coded risk badge (green / yellow / orange / red)
2. **All indices table** — Standard BMI, New BMI, Ponderal Index, BSA — each with value, classification, and risk level
3. **Ethnicity note** — shown only when Asian cutoffs apply; explains clinical difference with cited source
4. **Risk interpretation** — brief paragraph per WHO health risk tier (metabolic, cardiovascular) with numbered citations

### Page 3: Methodology

- Static page (no calculations)
- Formula display using `st.latex`
- Classification cutoff tables with sources
- Numbered reference list

### Shared

Every page displays a disclaimer: *"This tool is for informational purposes only and does not replace clinical assessment."*

---

## Error Handling

### Input Validation

| Field | Bounds |
|---|---|
| Height (metric) | 50 – 300 cm |
| Height (imperial) | 20 – 118 in |
| Weight (metric) | 2 – 700 kg |
| Weight (imperial) | 4 – 1543 lbs |
| Age | 2 – 120 |

- All fields required before "Calculate" is enabled
- Out-of-bounds values show inline `st.error()` with human-readable message
- Imperial values converted then re-validated after conversion

### Session State Safety

- Results page checks for required session keys on load
- If keys are missing (user landed directly on Results URL), redirect to Calculator with a message
- No calculation runs with incomplete data

---

## Testing

Tests cover `core/` only (pure functions, no Streamlit dependency). Runnable with `pytest`.

**`tests/test_bmi.py`:**
- Each formula verified against known published values
- Boundary tests at exact cutoff thresholds (e.g., BMI = 25.0 → Overweight, not Normal)
- Imperial round-trip conversion tests (kg → lbs → kg, cm → inches → cm)

**`tests/test_classifications.py`:**
- Ethnicity branching: same inputs, different ethnicity → different classification
- All cutoff boundaries for WHO standard and Asian tables

---

## References

1. World Health Organization. (1995). *Physical Status: The Use and Interpretation of Anthropometry*. WHO Technical Report Series 854.
2. Peterson, C.M., et al. (2016). *A new formula for computing body mass index with a lower risk of inaccuracies*. Obesity.
3. Rohrer, F. (1921). *Der Index der Körperfülle als Maß des Ernährungszustandes*. Münchener Medizinische Wochenschrift.
4. Mosteller, R.D. (1987). *Simplified calculation of body surface area*. NEJM, 317(17), 1098.
5. WHO Expert Consultation. (2004). *Appropriate body-mass index for Asian populations*. The Lancet, 363(9403), 157–163.
