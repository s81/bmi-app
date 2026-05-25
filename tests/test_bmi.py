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
    assert result < 1.0


def test_standard_bmi_height_in_meters_correct():
    # Positive confirmation: 1.75 m gives physiological result
    result = calc_standard_bmi(70.0, 1.75)
    assert 15.0 < result < 35.0
