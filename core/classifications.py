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


def classify_whtr(whtr: float) -> tuple[str, str]:
    if whtr < 0.4:
        return ("Extremely Slim", "Low (but other risks)")
    elif whtr < 0.5:
        return ("Healthy", "Average")
    elif whtr < 0.6:
        return ("Increased Risk", "Increased")
    else:
        return ("High Risk", "High")


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
