from core.classifications import (
    classify_who_standard,
    classify_who_asian,
    classify_ponderal,
    classify_new_bmi,
    classify_whtr,
    classify_body_fat,
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


# WHtR
def test_whtr_extremely_slim():
    assert classify_whtr(0.35) == ("Extremely Slim", "Low (but other risks)")

def test_whtr_healthy():
    assert classify_whtr(0.45) == ("Healthy", "Average")

def test_whtr_healthy_upper_boundary():
    assert classify_whtr(0.499) == ("Healthy", "Average")

def test_whtr_increased_risk_lower_boundary():
    assert classify_whtr(0.5) == ("Increased Risk", "Increased")

def test_whtr_increased_risk():
    assert classify_whtr(0.55) == ("Increased Risk", "Increased")

def test_whtr_high_risk():
    assert classify_whtr(0.65) == ("High Risk", "High")

def test_whtr_high_risk_lower_boundary():
    assert classify_whtr(0.6) == ("High Risk", "High")


# Body fat — male ACE thresholds
def test_bf_male_essential():
    assert classify_body_fat(4.0, "Male") == ("Essential Fat", "Low (but other risks)")

def test_bf_male_athletic():
    assert classify_body_fat(10.0, "Male") == ("Athletic", "Average")

def test_bf_male_fitness():
    assert classify_body_fat(15.0, "Male") == ("Fitness", "Average")

def test_bf_male_acceptable():
    assert classify_body_fat(20.0, "Male") == ("Acceptable", "Average")

def test_bf_male_obese():
    assert classify_body_fat(28.0, "Male") == ("Obese", "High")

def test_bf_male_athletic_lower_boundary():
    assert classify_body_fat(6.0, "Male") == ("Athletic", "Average")

def test_bf_male_obese_lower_boundary():
    assert classify_body_fat(25.0, "Male") == ("Obese", "High")

# Body fat — female ACE thresholds
def test_bf_female_essential():
    assert classify_body_fat(12.0, "Female") == ("Essential Fat", "Low (but other risks)")

def test_bf_female_athletic():
    assert classify_body_fat(17.0, "Female") == ("Athletic", "Average")

def test_bf_female_fitness():
    assert classify_body_fat(22.0, "Female") == ("Fitness", "Average")

def test_bf_female_acceptable():
    assert classify_body_fat(28.0, "Female") == ("Acceptable", "Average")

def test_bf_female_obese():
    assert classify_body_fat(35.0, "Female") == ("Obese", "High")

def test_bf_other_uses_female_thresholds():
    assert classify_body_fat(17.0, "Other") == ("Athletic", "Average")
    assert classify_body_fat(10.0, "Other") == ("Essential Fat", "Low (but other risks)")


# Risk color
def test_risk_color_normal():
    assert get_risk_color("Average") == "green"

def test_risk_color_increased():
    assert get_risk_color("Increased") == "orange"

def test_risk_color_high():
    assert get_risk_color("High") == "red"
