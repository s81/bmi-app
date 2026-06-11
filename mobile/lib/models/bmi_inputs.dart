class BmiInputs {
  final int age;
  final String sex;
  final String ethnicity;
  final double heightCm;
  final double weightKg;
  final double? waistCm;
  final double? neckCm;
  final double? hipCm;
  final bool imperial;

  const BmiInputs({
    required this.age,
    required this.sex,
    required this.ethnicity,
    required this.heightCm,
    required this.weightKg,
    this.waistCm,
    this.neckCm,
    this.hipCm,
    required this.imperial,
  });

  String get heightDisplay => imperial
      ? '${(heightCm / 2.54).toStringAsFixed(1)} in'
      : '${heightCm.toStringAsFixed(1)} cm';

  String get weightDisplay => imperial
      ? '${(weightKg / 0.453592).toStringAsFixed(1)} lbs'
      : '${weightKg.toStringAsFixed(1)} kg';

  String? get waistDisplay {
    if (waistCm == null) return null;
    return imperial
        ? '${(waistCm! / 2.54).toStringAsFixed(1)} in'
        : '${waistCm!.toStringAsFixed(1)} cm';
  }

  bool get isAsian => ethnicity == 'Asian (East/South)';
}
