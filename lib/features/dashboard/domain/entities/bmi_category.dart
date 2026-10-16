/// WHO adult BMI bands.
enum BmiCategory {
  underweight(
    'Underweight',
    'Consider a balanced diet with more calories and consult a nutritionist.',
  ),
  normal(
    'Normal',
    'Great job! Maintain a healthy lifestyle with regular exercise and balanced nutrition.',
  ),
  overweight(
    'Overweight',
    'Incorporate regular physical activity and a balanced diet to achieve a healthy weight.',
  ),
  obese(
    'Obesity',
    'Consult a healthcare professional for a personalized weight management plan.',
  );

  final String label;
  final String suggestion;

  const BmiCategory(this.label, this.suggestion);

  static BmiCategory fromBmi(double bmi) {
    if (bmi < 18.5) return underweight;
    if (bmi < 25) return normal;
    if (bmi < 30) return overweight;
    return obese;
  }
}
