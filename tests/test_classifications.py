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
