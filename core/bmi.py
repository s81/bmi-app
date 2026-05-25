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
