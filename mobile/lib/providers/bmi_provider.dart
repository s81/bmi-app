import 'package:flutter/foundation.dart';
import '../core/bmi.dart';
import '../core/classifications.dart';
import '../models/bmi_inputs.dart';
import '../models/bmi_results.dart';
import 'history_provider.dart';

class BmiProvider extends ChangeNotifier {
  BmiInputs? _inputs;
  BmiResults? _results;

  BmiInputs? get inputs => _inputs;
  BmiResults? get results => _results;
  bool get hasResults => _results != null;

  Future<void> calculate(BmiInputs inputs, {HistoryProvider? history}) async {
    _inputs = inputs;
    _results = _compute(inputs);
    notifyListeners();
    if (history != null) {
      await history.save(inputs, _results!);
    }
  }

  void clear() {
    _inputs = null;
    _results = null;
    notifyListeners();
  }

  BmiResults _compute(BmiInputs inp) {
    final heightM = inp.heightCm / 100.0;

    final standardBmi = calcStandardBmi(inp.weightKg, heightM);
    final newBmi      = calcNewBmi(inp.weightKg, heightM);
    final pi          = calcPonderalIndex(inp.weightKg, heightM);
    final bsa         = calcBsa(inp.heightCm, inp.weightKg);

    final classify = inp.isAsian ? classifyWhoAsian : classifyWhoStandard;
    final (primaryCat, primaryRisk) = classify(standardBmi);
    final (piCat, piRisk)           = classifyPonderal(pi);
    final (newBmiCat, newBmiRisk)   = classifyNewBmi(newBmi);

    final whtr = inp.waistCm != null
        ? calcWhtr(inp.waistCm!, inp.heightCm)
        : null;
    final (whtrCat, whtrRisk) = whtr != null
        ? classifyWhtr(whtr)
        : ('—', '—');

    // Body fat rows
    final bfRows = <BfRow>[];
    if (inp.waistCm != null && inp.neckCm != null) {
      if (inp.sex == 'Male') {
        final v = calcBfNavyMale(inp.heightCm, inp.waistCm!, inp.neckCm!);
        if (v != null) {
          final (c, r) = classifyBodyFat(v, 'Male');
          bfRows.add(BfRow('U.S. Navy (male)', v, c, r));
        }
      } else if (inp.sex == 'Female') {
        if (inp.hipCm != null) {
          final v = calcBfNavyFemale(inp.heightCm, inp.waistCm!, inp.hipCm!, inp.neckCm!);
          if (v != null) {
            final (c, r) = classifyBodyFat(v, 'Female');
            bfRows.add(BfRow('U.S. Navy (female)', v, c, r));
          }
        }
      } else {
        final vm = calcBfNavyMale(inp.heightCm, inp.waistCm!, inp.neckCm!);
        if (vm != null) {
          final (c, r) = classifyBodyFat(vm, 'Male');
          bfRows.add(BfRow('U.S. Navy (male)', vm, c, r));
        }
        if (inp.hipCm != null) {
          final vf = calcBfNavyFemale(inp.heightCm, inp.waistCm!, inp.hipCm!, inp.neckCm!);
          if (vf != null) {
            final (c, r) = classifyBodyFat(vf, 'Female');
            bfRows.add(BfRow('U.S. Navy (female)', vf, c, r));
          }
        }
      }
    }
    final deurenberg = calcBfDeurenberg(standardBmi, inp.age.toDouble(), inp.sex);
    final (dc, dr) = classifyBodyFat(deurenberg, inp.sex);
    bfRows.add(BfRow('Deurenberg (BMI-based)', deurenberg, dc, dr));

    // IBW rows
    final hamwi    = calcIbwHamwi(inp.heightCm, inp.sex);
    final devine   = calcIbwDevine(inp.heightCm, inp.sex);
    final robinson = calcIbwRobinson(inp.heightCm, inp.sex);
    final miller   = calcIbwMiller(inp.heightCm, inp.sex);
    final ibwAvg   = (hamwi + devine + robinson + miller) / 4;

    return BmiResults(
      standardBmi: standardBmi,
      newBmi: newBmi,
      pi: pi,
      bsa: bsa,
      primaryCategory: primaryCat,
      primaryRisk: primaryRisk,
      newBmiCategory: newBmiCat,
      newBmiRisk: newBmiRisk,
      piCategory: piCat,
      piRisk: piRisk,
      whtr: whtr,
      whtrCategory: whtrCat,
      whtrRisk: whtrRisk,
      bfRows: bfRows,
      ibwRows: [
        IbwRow('Hamwi', '1964', hamwi),
        IbwRow('Devine', '1974', devine),
        IbwRow('Robinson', '1983', robinson),
        IbwRow('Miller', '1983', miller),
      ],
      ibwAvg: ibwAvg,
    );
  }
}
