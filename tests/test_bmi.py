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
