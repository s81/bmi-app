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


from core.bmi import (
    calc_standard_bmi, calc_new_bmi, calc_ponderal_index, calc_bsa,
    calc_whtr,
    calc_ibw_hamwi, calc_ibw_devine, calc_ibw_robinson, calc_ibw_miller,
)


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


def test_whtr_known_value():
    # waist 80 cm, height 175 cm → 80 / 175 = 0.457
    assert abs(calc_whtr(80.0, 175.0) - 0.457) < 0.001


def test_whtr_boundary_at_half():
    # waist exactly half of height → WHtR = 0.5
    assert abs(calc_whtr(87.5, 175.0) - 0.5) < 0.001


def test_whtr_uses_cm_not_meters():
    # Both inputs must be in cm; mixing units would give nonsensical result
    result = calc_whtr(80.0, 175.0)
    assert 0.1 < result < 1.0


# ── IBW ──────────────────────────────────────────────────────────────────────
# Reference: male 175 cm → 68.898 in → 8.898 in over 5 ft
def test_ibw_hamwi_male():
    assert abs(calc_ibw_hamwi(175.0, "Male") - 72.02) < 0.1

def test_ibw_devine_male():
    assert abs(calc_ibw_devine(175.0, "Male") - 70.47) < 0.1

def test_ibw_robinson_male():
    assert abs(calc_ibw_robinson(175.0, "Male") - 68.91) < 0.1

def test_ibw_miller_male():
    assert abs(calc_ibw_miller(175.0, "Male") - 68.75) < 0.1

# Reference: female 160 cm → 62.992 in → 2.992 in over 5 ft
def test_ibw_hamwi_female():
    assert abs(calc_ibw_hamwi(160.0, "Female") - 52.08) < 0.1

def test_ibw_devine_female():
    assert abs(calc_ibw_devine(160.0, "Female") - 52.38) < 0.1

def test_ibw_robinson_female():
    assert abs(calc_ibw_robinson(160.0, "Female") - 54.09) < 0.1

def test_ibw_miller_female():
    assert abs(calc_ibw_miller(160.0, "Female") - 57.17) < 0.1

def test_ibw_under_5ft_clamp():
    # 150 cm is below 5 ft — result must equal the base (no negative extrapolation)
    assert calc_ibw_hamwi(150.0, "Male") == 48.0
    assert calc_ibw_hamwi(150.0, "Female") == 45.5

def test_ibw_other_sex_is_average():
    male   = calc_ibw_hamwi(175.0, "Male")
    female = calc_ibw_hamwi(175.0, "Female")
    other  = calc_ibw_hamwi(175.0, "Other")
    assert abs(other - (male + female) / 2) < 0.001
