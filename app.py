from flask import Flask, render_template, request, session, redirect, url_for
import os

from core.bmi import (
    lbs_to_kg, inches_to_cm,
    calc_standard_bmi, calc_new_bmi, calc_ponderal_index, calc_bsa,
    calc_whtr, calc_ibw_hamwi, calc_ibw_devine, calc_ibw_robinson, calc_ibw_miller,
    calc_bf_navy_male, calc_bf_navy_female, calc_bf_deurenberg,
)
from core.classifications import (
    classify_who_standard, classify_who_asian, classify_ponderal,
    classify_new_bmi, classify_whtr, classify_body_fat,
)
from core.styles import (
    bmi_hero_html, bmi_scale_html, indices_table_html,
    ibw_table_html, bf_table_html, section_label,
    formula_card_open, formula_card_close, RISK_PALETTE,
)

app = Flask(__name__)
app.secret_key = os.environ.get("SECRET_KEY", "bmi-dev-secret-change-in-prod")

app.jinja_env.globals["section_label"] = section_label
app.jinja_env.globals["formula_card_open"] = formula_card_open
app.jinja_env.globals["formula_card_close"] = formula_card_close


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/calculator", methods=["GET", "POST"])
def calculator():
    errors = []
    form = {}
    if request.method == "POST":
        try:
            unit = request.form.get("unit", "metric")
            imperial = unit == "imperial"
            age = int(request.form.get("age", 30))
            sex = request.form.get("sex", "Male")
            ethnicity = request.form.get("ethnicity", "General population")
            height_raw = float(request.form.get("height", 0))
            weight_raw = float(request.form.get("weight", 0))
            waist_raw = float(request.form.get("waist", 0))
            neck_raw = float(request.form.get("neck", 0))
            hip_raw = float(request.form.get("hip", 0))

            height_cm = inches_to_cm(height_raw) if imperial else height_raw
            weight_kg = lbs_to_kg(weight_raw) if imperial else weight_raw
            waist_cm = inches_to_cm(waist_raw) if imperial else waist_raw
            neck_cm = inches_to_cm(neck_raw) if imperial else neck_raw
            hip_cm = inches_to_cm(hip_raw) if imperial else hip_raw

            if not (50.0 <= height_cm <= 300.0):
                errors.append(f"Height {height_cm:.1f} cm is outside physiological range (50–300 cm).")
            if not (2.0 <= weight_kg <= 700.0):
                errors.append(f"Weight {weight_kg:.1f} kg is outside physiological range (2–700 kg).")

            if not errors:
                session["bmi_inputs"] = {
                    "age": age,
                    "sex": sex,
                    "ethnicity": ethnicity,
                    "height_cm": height_cm,
                    "weight_kg": weight_kg,
                    "height_display": f"{height_raw} {'in' if imperial else 'cm'}",
                    "weight_display": f"{weight_raw} {'lbs' if imperial else 'kg'}",
                    "waist_cm": waist_cm if waist_raw > 0 else None,
                    "waist_display": f"{waist_raw} {'in' if imperial else 'cm'}" if waist_raw > 0 else None,
                    "neck_cm": neck_cm if neck_raw > 0 else None,
                    "hip_cm": hip_cm if hip_raw > 0 else None,
                }
                return redirect(url_for("results"))

            form = request.form.to_dict()
        except (ValueError, TypeError) as exc:
            errors.append(f"Invalid input: {exc}")
            form = request.form.to_dict()

    return render_template("calculator.html", errors=errors, form=form)


@app.route("/results")
def results():
    if "bmi_inputs" not in session:
        return redirect(url_for("calculator"))

    inputs = session["bmi_inputs"]
    weight_kg = inputs["weight_kg"]
    height_m = inputs["height_cm"] / 100.0
    height_cm = inputs["height_cm"]
    is_asian = inputs["ethnicity"] == "Asian (East/South)"

    standard_bmi = calc_standard_bmi(weight_kg, height_m)
    new_bmi = calc_new_bmi(weight_kg, height_m)
    pi = calc_ponderal_index(weight_kg, height_m)
    bsa = calc_bsa(height_cm, weight_kg)

    classify_fn = classify_who_asian if is_asian else classify_who_standard
    primary_category, primary_risk = classify_fn(standard_bmi)
    pi_category, pi_risk = classify_ponderal(pi)
    new_bmi_category, new_bmi_risk = classify_new_bmi(new_bmi)

    waist_cm = inputs.get("waist_cm")
    whtr = calc_whtr(waist_cm, height_cm) if waist_cm else None
    whtr_category, whtr_risk = classify_whtr(whtr) if whtr is not None else ("—", "—")

    sex = inputs["sex"]
    is_imperial = "lbs" in inputs["weight_display"]
    neck_cm = inputs.get("neck_cm")
    hip_cm = inputs.get("hip_cm")

    bf_rows = []
    if waist_cm and neck_cm:
        if sex == "Male":
            bf_navy = calc_bf_navy_male(height_cm, waist_cm, neck_cm)
            if bf_navy is not None:
                cat, risk = classify_body_fat(bf_navy, sex)
                bf_rows.append(("U.S. Navy (male formula)", bf_navy, cat, risk))
        elif sex == "Female":
            if hip_cm:
                bf_navy = calc_bf_navy_female(height_cm, waist_cm, hip_cm, neck_cm)
                if bf_navy is not None:
                    cat, risk = classify_body_fat(bf_navy, sex)
                    bf_rows.append(("U.S. Navy (female formula)", bf_navy, cat, risk))
        else:
            bf_m = calc_bf_navy_male(height_cm, waist_cm, neck_cm)
            if bf_m is not None:
                cat, risk = classify_body_fat(bf_m, "Male")
                bf_rows.append(("U.S. Navy (male formula)", bf_m, cat, risk))
            if hip_cm:
                bf_f = calc_bf_navy_female(height_cm, waist_cm, hip_cm, neck_cm)
                if bf_f is not None:
                    cat, risk = classify_body_fat(bf_f, "Female")
                    bf_rows.append(("U.S. Navy (female formula)", bf_f, cat, risk))

    bf_deurenberg = calc_bf_deurenberg(standard_bmi, inputs["age"], sex)
    cat, risk = classify_body_fat(bf_deurenberg, sex)
    bf_rows.append(("Deurenberg (BMI-based)", bf_deurenberg, cat, risk))

    ibw_hamwi = calc_ibw_hamwi(height_cm, sex)
    ibw_devine = calc_ibw_devine(height_cm, sex)
    ibw_robinson = calc_ibw_robinson(height_cm, sex)
    ibw_miller = calc_ibw_miller(height_cm, sex)

    whtr_callout_html = ""
    if whtr is not None:
        target = height_cm / 2
        target_unit = inputs["waist_display"].split(" ")[1]
        target_val = f"{target / 2.54:.1f} in" if target_unit == "in" else f"{target:.1f} cm"
        direction = "above" if whtr >= 0.5 else "below"
        color = "#FEF3C7" if whtr >= 0.5 else "#D1FAE5"
        border = "#F59E0B" if whtr >= 0.5 else "#059669"
        text_color = "#78350F" if whtr >= 0.5 else "#065F46"
        whtr_callout_html = (
            f'<div style="background:{color};border:1px solid {border};border-left:4px solid {border};'
            f"border-radius:10px;padding:0.85rem 1.25rem;font-size:0.88rem;color:{text_color};"
            f"font-family:'DM Sans',sans-serif;line-height:1.6;margin-bottom:0.5rem;\">"
            f"<b>WHtR:</b> Your waist ({inputs['waist_display']}) is {direction} the evidence-based "
            f"target of half your height ({target_val}). "
            "Keeping WHtR below 0.5 is associated with significantly lower cardiometabolic risk "
            "across all ethnicities. [6]</div>"
        )

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
    risk_interp_html = (
        f'<div role="region" aria-label="Risk Interpretation" '
        f'style="background:{p["bg"]};border:1px solid {p["border"]};border-left:4px solid {p["dot"]};'
        f"border-radius:10px;padding:1rem 1.25rem;font-size:0.9rem;color:{p['text']};"
        f"font-family:'DM Sans',sans-serif;line-height:1.65;\">{interp_text}</div>"
    )

    return render_template(
        "results.html",
        hero_html=bmi_hero_html(
            bmi_val=standard_bmi,
            category=primary_category,
            risk=primary_risk,
            age=inputs["age"],
            sex=sex,
            ethnicity=inputs["ethnicity"],
            height_display=inputs["height_display"],
            weight_display=inputs["weight_display"],
        ),
        scale_html=bmi_scale_html(standard_bmi, is_asian=is_asian),
        indices_html=indices_table_html(
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
        ),
        bf_html=bf_table_html(bf_rows),
        ibw_html=ibw_table_html(
            weight_kg=weight_kg,
            hamwi_kg=ibw_hamwi,
            devine_kg=ibw_devine,
            robinson_kg=ibw_robinson,
            miller_kg=ibw_miller,
            is_imperial=is_imperial,
            sex=sex,
        ),
        whtr_callout_html=whtr_callout_html,
        risk_interp_html=risk_interp_html,
        is_asian=is_asian,
        height_cm=height_cm,
        show_navy_hint=not (waist_cm and neck_cm),
    )


@app.route("/methodology")
def methodology():
    return render_template("methodology.html")


if __name__ == "__main__":
    app.run()
