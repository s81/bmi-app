import 'dart:math';

// ── Unit conversions ─────────────────────────────────────────────────────────

double lbsToKg(double lbs) => lbs * 0.453592;
double kgToLbs(double kg) => kg / 0.453592;
double inchesToCm(double inches) => inches * 2.54;
double cmToInches(double cm) => cm / 2.54;

// ── Indices ───────────────────────────────────────────────────────────────────

double calcStandardBmi(double weightKg, double heightM) =>
    weightKg / (heightM * heightM);

double calcNewBmi(double weightKg, double heightM) =>
    1.3 * weightKg / pow(heightM, 2.5);

double calcPonderalIndex(double weightKg, double heightM) =>
    weightKg / pow(heightM, 3);

double calcBsa(double heightCm, double weightKg) =>
    sqrt(heightCm * weightKg / 3600);

double calcWhtr(double waistCm, double heightCm) => waistCm / heightCm;

// ── Body fat ──────────────────────────────────────────────────────────────────

double? calcBfNavyMale(double heightCm, double waistCm, double neckCm) {
  final val = waistCm - neckCm;
  if (val <= 0) return null;
  return 495 / (1.0324 - 0.19077 * log(val) / ln10 + 0.15456 * log(heightCm) / ln10) - 450;
}

double? calcBfNavyFemale(
    double heightCm, double waistCm, double hipCm, double neckCm) {
  final val = waistCm + hipCm - neckCm;
  if (val <= 0) return null;
  return 495 / (1.29579 - 0.35004 * log(val) / ln10 + 0.22100 * log(heightCm) / ln10) - 450;
}

double calcBfDeurenberg(double bmi, double age, String sex) {
  final sexFactor = sex == 'Male' ? 1.0 : (sex == 'Female' ? 0.0 : 0.5);
  return 1.20 * bmi + 0.23 * age - 10.8 * sexFactor - 5.4;
}

// ── Ideal body weight ─────────────────────────────────────────────────────────

double _inchesOver5ft(double heightCm) =>
    max(0.0, heightCm / 2.54 - 60.0);

double calcIbwHamwi(double heightCm, String sex) {
  final x = _inchesOver5ft(heightCm);
  if (sex == 'Male') return 48.0 + 2.7 * x;
  if (sex == 'Female') return 45.5 + 2.2 * x;
  return ((48.0 + 2.7 * x) + (45.5 + 2.2 * x)) / 2;
}

double calcIbwDevine(double heightCm, String sex) {
  final x = _inchesOver5ft(heightCm);
  if (sex == 'Male') return 50.0 + 2.3 * x;
  if (sex == 'Female') return 45.5 + 2.3 * x;
  return ((50.0 + 2.3 * x) + (45.5 + 2.3 * x)) / 2;
}

double calcIbwRobinson(double heightCm, String sex) {
  final x = _inchesOver5ft(heightCm);
  if (sex == 'Male') return 52.0 + 1.9 * x;
  if (sex == 'Female') return 49.0 + 1.7 * x;
  return ((52.0 + 1.9 * x) + (49.0 + 1.7 * x)) / 2;
}

double calcIbwMiller(double heightCm, String sex) {
  final x = _inchesOver5ft(heightCm);
  if (sex == 'Male') return 56.2 + 1.41 * x;
  if (sex == 'Female') return 53.1 + 1.36 * x;
  return ((56.2 + 1.41 * x) + (53.1 + 1.36 * x)) / 2;
}
