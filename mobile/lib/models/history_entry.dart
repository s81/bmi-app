class HistoryEntry {
  final String id;
  final DateTime recordedAt;
  final int age;
  final String sex;
  final String ethnicity;
  final double heightCm;
  final double weightKg;
  final double? waistCm;
  final double? neckCm;
  final double? hipCm;
  final bool isImperial;
  final double standardBmi;
  final String primaryCategory;
  final String primaryRisk;
  final double? newBmi;
  final double? ponderalIndex;
  final double? bsa;
  final double? whtr;

  const HistoryEntry({
    required this.id,
    required this.recordedAt,
    required this.age,
    required this.sex,
    required this.ethnicity,
    required this.heightCm,
    required this.weightKg,
    this.waistCm,
    this.neckCm,
    this.hipCm,
    required this.isImperial,
    required this.standardBmi,
    required this.primaryCategory,
    required this.primaryRisk,
    this.newBmi,
    this.ponderalIndex,
    this.bsa,
    this.whtr,
  });

  factory HistoryEntry.fromMap(Map<String, dynamic> m) => HistoryEntry(
        id:              m['id'] as String,
        recordedAt:      DateTime.parse(m['recorded_at'] as String).toLocal(),
        age:             m['age'] as int,
        sex:             m['sex'] as String,
        ethnicity:       m['ethnicity'] as String,
        heightCm:        (m['height_cm'] as num).toDouble(),
        weightKg:        (m['weight_kg'] as num).toDouble(),
        waistCm:         (m['waist_cm'] as num?)?.toDouble(),
        neckCm:          (m['neck_cm'] as num?)?.toDouble(),
        hipCm:           (m['hip_cm'] as num?)?.toDouble(),
        isImperial:      m['is_imperial'] as bool? ?? false,
        standardBmi:     (m['standard_bmi'] as num).toDouble(),
        primaryCategory: m['primary_category'] as String,
        primaryRisk:     m['primary_risk'] as String,
        newBmi:          (m['new_bmi'] as num?)?.toDouble(),
        ponderalIndex:   (m['ponderal_index'] as num?)?.toDouble(),
        bsa:             (m['bsa'] as num?)?.toDouble(),
        whtr:            (m['whtr'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toInsertMap(String userId) => {
        'user_id':          userId,
        'age':              age,
        'sex':              sex,
        'ethnicity':        ethnicity,
        'height_cm':        heightCm,
        'weight_kg':        weightKg,
        'waist_cm':         waistCm,
        'neck_cm':          neckCm,
        'hip_cm':           hipCm,
        'is_imperial':      isImperial,
        'standard_bmi':     standardBmi,
        'primary_category': primaryCategory,
        'primary_risk':     primaryRisk,
        'new_bmi':          newBmi,
        'ponderal_index':   ponderalIndex,
        'bsa':              bsa,
        'whtr':             whtr,
      };
}
