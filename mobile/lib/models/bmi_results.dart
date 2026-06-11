class BfRow {
  final String method;
  final double bfPct;
  final String category;
  final String risk;
  const BfRow(this.method, this.bfPct, this.category, this.risk);
}

class IbwRow {
  final String formula;
  final String year;
  final double ibwKg;
  const IbwRow(this.formula, this.year, this.ibwKg);
}

class IndexRow {
  final String name;
  final String value;
  final String unit;
  final String category;
  final String risk;
  const IndexRow(this.name, this.value, this.unit, this.category, this.risk);
}

class BmiResults {
  final double standardBmi;
  final double newBmi;
  final double pi;
  final double bsa;
  final String primaryCategory;
  final String primaryRisk;
  final String newBmiCategory;
  final String newBmiRisk;
  final String piCategory;
  final String piRisk;
  final double? whtr;
  final String whtrCategory;
  final String whtrRisk;
  final List<BfRow> bfRows;
  final List<IbwRow> ibwRows;
  final double ibwAvg;

  const BmiResults({
    required this.standardBmi,
    required this.newBmi,
    required this.pi,
    required this.bsa,
    required this.primaryCategory,
    required this.primaryRisk,
    required this.newBmiCategory,
    required this.newBmiRisk,
    required this.piCategory,
    required this.piRisk,
    this.whtr,
    required this.whtrCategory,
    required this.whtrRisk,
    required this.bfRows,
    required this.ibwRows,
    required this.ibwAvg,
  });

  List<IndexRow> get indexRows => [
        IndexRow('Standard BMI', standardBmi.toStringAsFixed(2), 'kg/m²', primaryCategory, primaryRisk),
        IndexRow('New BMI (Peterson)', newBmi.toStringAsFixed(2), 'kg/m²', newBmiCategory, newBmiRisk),
        IndexRow('Ponderal Index', pi.toStringAsFixed(2), 'kg/m³', piCategory, piRisk),
        IndexRow('BSA (Mosteller)', bsa.toStringAsFixed(3), 'm²', '—', '—'),
        if (whtr != null)
          IndexRow('Waist-to-Height', whtr!.toStringAsFixed(3), '', whtrCategory, whtrRisk),
      ];
}
