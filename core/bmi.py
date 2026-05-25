import math


def lbs_to_kg(lbs: float) -> float:
    return lbs * 0.453592


def kg_to_lbs(kg: float) -> float:
    return kg / 0.453592


def inches_to_cm(inches: float) -> float:
    return inches * 2.54


def cm_to_inches(cm: float) -> float:
    return cm / 2.54


def calc_standard_bmi(weight_kg: float, height_m: float) -> float:
    return weight_kg / (height_m ** 2)


def calc_new_bmi(weight_kg: float, height_m: float) -> float:
    return 1.3 * weight_kg / (height_m ** 2.5)


def calc_ponderal_index(weight_kg: float, height_m: float) -> float:
    return weight_kg / (height_m ** 3)


def calc_bsa(height_cm: float, weight_kg: float) -> float:
    return math.sqrt(height_cm * weight_kg / 3600)


def calc_whtr(waist_cm: float, height_cm: float) -> float:
    return waist_cm / height_cm


def _inches_over_5ft(height_cm: float) -> float:
    return max(0.0, height_cm / 2.54 - 60.0)


def calc_ibw_hamwi(height_cm: float, sex: str) -> float:
    x = _inches_over_5ft(height_cm)
    if sex == "Male":
        return 48.0 + 2.7 * x
    elif sex == "Female":
        return 45.5 + 2.2 * x
    else:
        return (48.0 + 2.7 * x + 45.5 + 2.2 * x) / 2


def calc_ibw_devine(height_cm: float, sex: str) -> float:
    x = _inches_over_5ft(height_cm)
    if sex == "Male":
        return 50.0 + 2.3 * x
    elif sex == "Female":
        return 45.5 + 2.3 * x
    else:
        return (50.0 + 2.3 * x + 45.5 + 2.3 * x) / 2


def calc_ibw_robinson(height_cm: float, sex: str) -> float:
    x = _inches_over_5ft(height_cm)
    if sex == "Male":
        return 52.0 + 1.9 * x
    elif sex == "Female":
        return 49.0 + 1.7 * x
    else:
        return (52.0 + 1.9 * x + 49.0 + 1.7 * x) / 2


def calc_ibw_miller(height_cm: float, sex: str) -> float:
    x = _inches_over_5ft(height_cm)
    if sex == "Male":
        return 56.2 + 1.41 * x
    elif sex == "Female":
        return 53.1 + 1.36 * x
    else:
        return (56.2 + 1.41 * x + 53.1 + 1.36 * x) / 2
