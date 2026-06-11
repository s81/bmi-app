import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/bmi.dart';
import '../models/bmi_inputs.dart';
import '../providers/bmi_provider.dart';
import '../providers/history_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';

class CalculatorScreen extends StatefulWidget {
  final VoidCallback onCalculated;
  const CalculatorScreen({super.key, required this.onCalculated});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _imperial = false;

  final _ageCtrl    = TextEditingController(text: '30');
  final _heightCtrl = TextEditingController(text: '175');
  final _weightCtrl = TextEditingController(text: '70');
  final _waistCtrl  = TextEditingController(text: '0');
  final _neckCtrl   = TextEditingController(text: '0');
  final _hipCtrl    = TextEditingController(text: '0');

  String _sex       = 'Male';
  String _ethnicity = 'General population';

  final _sexOptions       = ['Male', 'Female', 'Other'];
  final _ethnicityOptions = ['General population', 'Asian (East/South)', 'Other'];

  @override
  void dispose() {
    for (final c in [_ageCtrl, _heightCtrl, _weightCtrl, _waistCtrl, _neckCtrl, _hipCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  void _onUnitToggle(bool imperial) {
    setState(() {
      final h = double.tryParse(_heightCtrl.text) ?? 0;
      final w = double.tryParse(_weightCtrl.text) ?? 0;
      if (imperial && !_imperial) {
        _heightCtrl.text = (h / 2.54).toStringAsFixed(1);
        _weightCtrl.text = kgToLbs(w).toStringAsFixed(1);
      } else if (!imperial && _imperial) {
        _heightCtrl.text = inchesToCm(h).toStringAsFixed(1);
        _weightCtrl.text = lbsToKg(w).toStringAsFixed(1);
      }
      _imperial = imperial;
    });
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;

    final heightRaw = double.parse(_heightCtrl.text);
    final weightRaw = double.parse(_weightCtrl.text);
    final waistRaw  = double.tryParse(_waistCtrl.text) ?? 0;
    final neckRaw   = double.tryParse(_neckCtrl.text) ?? 0;
    final hipRaw    = double.tryParse(_hipCtrl.text) ?? 0;

    final heightCm = _imperial ? inchesToCm(heightRaw) : heightRaw;
    final weightKg = _imperial ? lbsToKg(weightRaw) : weightRaw;
    final waistCm  = waistRaw > 0 ? (_imperial ? inchesToCm(waistRaw) : waistRaw) : null;
    final neckCm   = neckRaw  > 0 ? (_imperial ? inchesToCm(neckRaw)  : neckRaw)  : null;
    final hipCm    = hipRaw   > 0 ? (_imperial ? inchesToCm(hipRaw)   : hipRaw)   : null;

    final inputs = BmiInputs(
      age: int.parse(_ageCtrl.text),
      sex: _sex,
      ethnicity: _ethnicity,
      heightCm: heightCm,
      weightKg: weightKg,
      waistCm: waistCm,
      neckCm: neckCm,
      hipCm: hipCm,
      imperial: _imperial,
    );

    await context.read<BmiProvider>().calculate(
      inputs,
      history: context.read<HistoryProvider>(),
    );
    if (mounted) widget.onCalculated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calculator',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'For informational purposes only — not a clinical assessment.',
                style: Theme.of(context).textTheme.bodySmall,
              ),

              // ── Unit system ────────────────────────────────────────────
              const SectionHeader('Unit System'),
              _unitToggle(),

              const Divider(height: 28),

              // ── Patient profile ────────────────────────────────────────
              const SectionHeader('Patient Profile'),
              Row(
                children: [
                  Expanded(child: _numberField('Age', _ageCtrl, min: 2, max: 120, isInt: true)),
                  const SizedBox(width: 12),
                  Expanded(child: _dropdown('Sex', _sex, _sexOptions, (v) => setState(() => _sex = v!))),
                ],
              ),
              const SizedBox(height: 12),
              _dropdown('Ethnicity', _ethnicity, _ethnicityOptions, (v) => setState(() => _ethnicity = v!)),
              const SizedBox(height: 4),
              Text(
                'WHO recommends lower BMI thresholds for East and South Asian populations.',
                style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted),
              ),

              const Divider(height: 28),

              // ── Measurements ───────────────────────────────────────────
              const SectionHeader('Measurements'),
              Row(
                children: [
                  Expanded(
                    child: _numberField(
                      _imperial ? 'Height (in)' : 'Height (cm)',
                      _heightCtrl,
                      min: _imperial ? 20 : 50,
                      max: _imperial ? 118 : 300,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _numberField(
                      _imperial ? 'Weight (lbs)' : 'Weight (kg)',
                      _weightCtrl,
                      min: _imperial ? 4 : 2,
                      max: _imperial ? 1543 : 700,
                    ),
                  ),
                ],
              ),

              const Divider(height: 28),

              // ── Circumference (optional) ───────────────────────────────
              const SectionHeader('Circumference Measurements'),
              Text(
                'Optional — waist enables WHtR · waist + neck enables Navy body fat (male) · '
                'waist + neck + hip enables Navy body fat (female)',
                style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted, height: 1.4),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _numberField(_imperial ? 'Waist (in)' : 'Waist (cm)', _waistCtrl, min: 0, max: _imperial ? 100 : 250, required: false)),
                  const SizedBox(width: 12),
                  Expanded(child: _numberField(_imperial ? 'Neck (in)' : 'Neck (cm)', _neckCtrl, min: 0, max: _imperial ? 30 : 80, required: false)),
                ],
              ),
              const SizedBox(height: 12),
              _numberField(_imperial ? 'Hip (in)' : 'Hip (cm)', _hipCtrl, min: 0, max: _imperial ? 100 : 250, required: false),
              Text(
                'Hip is used in the female Navy body fat formula only.',
                style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculate,
                  child: const Text('Calculate →'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _unitToggle() {
    return Row(
      children: [
        _radioBtn('Metric (kg, cm)', !_imperial, () => _onUnitToggle(false)),
        const SizedBox(width: 24),
        _radioBtn('Imperial (lbs, in)', _imperial, () => _onUnitToggle(true)),
      ],
    );
  }

  Widget _radioBtn(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<bool>(
            value: true,
            groupValue: selected,
            onChanged: (_) => onTap(),
            activeColor: AppColors.blue,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Text(label, style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textMain)),
        ],
      ),
    );
  }

  Widget _numberField(
    String label,
    TextEditingController ctrl, {
    double min = 0,
    double max = 9999,
    bool isInt = false,
    bool required = true,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
      style: GoogleFonts.jetBrainsMono(fontSize: 15),
      validator: (v) {
        if (!required && (v == null || v.isEmpty || v == '0')) return null;
        final n = double.tryParse(v ?? '');
        if (n == null) return 'Enter a number';
        if (n < min || n > max) return '$min – $max';
        return null;
      },
    );
  }

  Widget _dropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: options.map((o) => DropdownMenuItem(value: o, child: Text(o, style: GoogleFonts.dmSans(fontSize: 14)))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
      style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textMain),
      dropdownColor: AppColors.card,
    );
  }
}
