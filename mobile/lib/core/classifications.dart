typedef Classification = (String category, String risk);

Classification classifyWhoStandard(double bmi) {
  if (bmi < 18.5) return ('Underweight', 'Low (but other risks)');
  if (bmi < 25.0) return ('Normal weight', 'Average');
  if (bmi < 30.0) return ('Overweight', 'Increased');
  if (bmi < 35.0) return ('Obese Class I', 'High');
  if (bmi < 40.0) return ('Obese Class II', 'Very High');
  return ('Obese Class III', 'Extremely High');
}

Classification classifyWhoAsian(double bmi) {
  if (bmi < 18.5) return ('Underweight', 'Low (but other risks)');
  if (bmi < 23.0) return ('Normal weight', 'Average');
  if (bmi < 27.5) return ('Overweight', 'Increased');
  return ('Obese', 'High');
}

Classification classifyPonderal(double pi) {
  if (pi < 11.0) return ('Underweight', 'Low');
  if (pi <= 14.0) return ('Normal', 'Average');
  return ('Overweight', 'Elevated');
}

Classification classifyNewBmi(double newBmi) => classifyWhoStandard(newBmi);

Classification classifyWhtr(double whtr) {
  if (whtr < 0.4) return ('Extremely Slim', 'Low (but other risks)');
  if (whtr < 0.5) return ('Healthy', 'Average');
  if (whtr < 0.6) return ('Increased Risk', 'Increased');
  return ('High Risk', 'High');
}

Classification classifyBodyFat(double bfPct, String sex) {
  if (sex == 'Male') {
    if (bfPct < 6)  return ('Essential Fat', 'Low (but other risks)');
    if (bfPct < 14) return ('Athletic', 'Average');
    if (bfPct < 18) return ('Fitness', 'Average');
    if (bfPct < 25) return ('Acceptable', 'Average');
    return ('Obese', 'High');
  } else {
    if (bfPct < 14) return ('Essential Fat', 'Low (but other risks)');
    if (bfPct < 21) return ('Athletic', 'Average');
    if (bfPct < 25) return ('Fitness', 'Average');
    if (bfPct < 32) return ('Acceptable', 'Average');
    return ('Obese', 'High');
  }
}
