import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/bmi.dart';
import '../providers/bmi_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/bmi_hero_card.dart';
import '../widgets/bmi_scale_chart.dart';
import '../widgets/data_table_card.dart';
import '../widgets/risk_chip.dart';
import '../widgets/section_header.dart';

class ResultsScreen extends StatelessWidget {
  final VoidCallback onRecalculate;
  const ResultsScreen({super.key, required this.onRecalculate});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BmiProvider>();

    if (!provider.hasResults) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calculate_outlined, size: 64, color: AppColors.muted),
                const SizedBox(height: 16),
                Text(
                  'No results yet',
                  style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: AppColors.navy),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete the Calculator first.',
                  style: GoogleFonts.dmSans(color: AppColors.muted),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onRecalculate,
                  child: const Text('Go to Calculator'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final inputs  = provider.inputs!;
    final results = provider.results!;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Results', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 4),
            Text(
              'For informational purposes only — not a clinical assessment.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            // Hero card
            BmiHeroCard(inputs: inputs, results: results),
            const SizedBox(height: 16),

            // BMI scale
            BmiScaleChart(bmiValue: results.standardBmi, isAsian: inputs.isAsian),
            const SizedBox(height: 8),

            // Asian note
            if (inputs.isAsian) ...[
              const SizedBox(height: 8),
              _infoBox(
                'Asian cutoffs applied. WHO recommends lower BMI thresholds for East and South Asian '
                'populations. Overweight ≥ 23.0 (vs 25.0) · Obese ≥ 27.5 (vs 30.0).',
                color: const Color(0xFFDBEAFE),
                borderColor: const Color(0xFF3B82F6),
                textColor: const Color(0xFF1E3A8A),
              ),
            ],

            // All indices
            const SectionHeader('All Indices'),
            DataTableCard(
              headers: const ['Index', 'Value', 'Risk'],
              rows: results.indexRows.map((r) => [
                bodyText(r.name),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    monoText(r.value),
                    if (r.unit.isNotEmpty) mutedText(r.unit),
                  ],
                ),
                Row(children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mutedText(r.category),
                      const SizedBox(height: 4),
                      RiskChip(r.risk),
                    ],
                  )),
                ]),
              ]).toList(),
            ),

            // WHtR callout
            if (results.whtr != null) ...[
              const SizedBox(height: 12),
              _whtrCallout(inputs, results),
            ],

            const Divider(height: 32),

            // Body composition
            const SectionHeader('Body Composition'),
            DataTableCard(
              headers: const ['Method', 'BF%', 'Risk'],
              rows: results.bfRows.map((r) => [
                bodyText(r.method),
                monoText('${r.bfPct.toStringAsFixed(1)}%'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mutedText(r.category),
                    const SizedBox(height: 4),
                    RiskChip(r.risk),
                  ],
                ),
              ]).toList(),
            ),
            if (inputs.waistCm == null || inputs.neckCm == null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Add waist + neck on Calculator to enable the Navy body fat formula.',
                  style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted),
                ),
              ),

            const Divider(height: 32),

            // IBW
            const SectionHeader('Ideal Body Weight'),
            if (inputs.heightCm < 152.4)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  'Note: IBW formulas validated for adults ≥ 5 ft (152.4 cm). Values are extrapolated.',
                  style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted),
                ),
              ),
            DataTableCard(
              headers: ['Formula', inputs.imperial ? 'IBW (lbs)' : 'IBW (kg)', '% vs Actual'],
              rows: results.ibwRows.map((r) => [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bodyText(r.formula),
                    mutedText(r.year),
                  ],
                ),
                monoText(inputs.imperial
                    ? '${kgToLbs(r.ibwKg).toStringAsFixed(1)} lbs'
                    : '${r.ibwKg.toStringAsFixed(1)} kg'),
                deltaPctChip(inputs.weightKg, r.ibwKg),
              ]).toList(),
            ),
            const SizedBox(height: 10),
            _ibwSummary(inputs, results),

            const Divider(height: 32),

            // Risk interpretation
            const SectionHeader('Risk Interpretation'),
            _riskInterpretation(results.primaryRisk),

            const Divider(height: 32),

            // References
            const SectionHeader('References'),
            _references(),

            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: onRecalculate,
              child: const Text('← Recalculate'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _whtrCallout(dynamic inputs, dynamic results) {
    final whtr = results.whtr as double;
    final target = inputs.heightCm / 2;
    final above = whtr >= 0.5;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: above ? const Color(0xFFFEF3C7) : const Color(0xFFD1FAE5),
        border: Border(
          left: BorderSide(
            color: above ? const Color(0xFFF59E0B) : const Color(0xFF059669),
            width: 4,
          ),
          top: BorderSide(color: above ? const Color(0xFFF59E0B) : const Color(0xFF059669)),
          right: BorderSide(color: above ? const Color(0xFFF59E0B) : const Color(0xFF059669)),
          bottom: BorderSide(color: above ? const Color(0xFFF59E0B) : const Color(0xFF059669)),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: above ? const Color(0xFF78350F) : const Color(0xFF065F46),
            height: 1.5,
          ),
          children: [
            const TextSpan(text: 'WHtR: ', style: TextStyle(fontWeight: FontWeight.w700)),
            TextSpan(
              text: 'Your waist is ${above ? "above" : "below"} the target of half your height '
                  '(${target.toStringAsFixed(1)} cm). '
                  'Keeping WHtR below 0.5 is associated with lower cardiometabolic risk. [6]',
            ),
          ],
        ),
      ),
    );
  }

  Widget _ibwSummary(dynamic inputs, dynamic results) {
    final avg = results.ibwAvg as double;
    final pct = (inputs.weightKg - avg) / avg * 100;
    final above = pct >= 0;
    final sign = above ? '+' : '';
    Color bg, border, text;
    if (pct > 20) {
      bg = const Color(0xFFFEE2E2); border = const Color(0xFFF87171); text = const Color(0xFF7F1D1D);
    } else if (pct > 5) {
      bg = const Color(0xFFFEF3C7); border = const Color(0xFFF59E0B); text = const Color(0xFF78350F);
    } else if (pct >= -5) {
      bg = const Color(0xFFDBEAFE); border = const Color(0xFF3B82F6); text = const Color(0xFF1E3A8A);
    } else {
      bg = const Color(0xFFD1FAE5); border = const Color(0xFF059669); text = const Color(0xFF065F46);
    }
    final avgDisplay = inputs.imperial
        ? '${kgToLbs(avg).toStringAsFixed(1)} lbs'
        : '${avg.toStringAsFixed(1)} kg';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        border: Border(left: BorderSide(color: border, width: 4),
          top: BorderSide(color: border), right: BorderSide(color: border), bottom: BorderSide(color: border)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Average IBW across all formulas: $avgDisplay. '
        'Your actual weight is $sign${pct.toStringAsFixed(1)}% ${above ? "above" : "below"} the average IBW. [10–13]',
        style: GoogleFonts.dmSans(fontSize: 13, color: text, height: 1.5),
      ),
    );
  }

  Widget _riskInterpretation(String risk) {
    const texts = {
      'Low (but other risks)':
          'Underweight individuals may face increased risk of malnutrition, bone density loss, immune suppression, and cardiovascular complications. Clinical evaluation is recommended. [1]',
      'Average':
          'BMI in the normal range is associated with the lowest all-cause mortality risk. Maintaining weight through balanced nutrition and physical activity is advised. [1]',
      'Increased':
          'Overweight is associated with increased risk of type 2 diabetes, hypertension, dyslipidemia, and coronary heart disease. Lifestyle interventions are clinically recommended. [1]',
      'High':
          'Obese Class I carries high risk for metabolic syndrome, sleep apnea, osteoarthritis, and cardiovascular disease. Medical assessment and structured weight management are recommended. [1]',
      'Very High':
          'Obese Class II is associated with very high risk of all obesity-related comorbidities. Pharmacological or surgical interventions may be appropriate. [1]',
      'Extremely High':
          'Obese Class III carries extremely high risk of premature mortality. Bariatric evaluation is typically indicated. Urgent clinical assessment recommended. [1]',
    };
    final colors = AppColors.riskColors(risk);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors['bg'],
        border: Border(
          left: BorderSide(color: colors['dot']!, width: 4),
          top: BorderSide(color: colors['border']!),
          right: BorderSide(color: colors['border']!),
          bottom: BorderSide(color: colors['border']!),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        texts[risk] ?? 'Interpretation not available for this risk level.',
        style: GoogleFonts.dmSans(fontSize: 14, color: colors['text'], height: 1.6),
      ),
    );
  }

  Widget _infoBox(String text, {required Color color, required Color borderColor, required Color textColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.dmSans(fontSize: 13, color: textColor, height: 1.5),
      ),
    );
  }

  Widget _references() {
    const refs = [
      '1. WHO. Physical Status: The Use and Interpretation of Anthropometry. 1995.',
      '2. Peterson et al. New formula for computing BMI. Obesity, 2016.',
      '3. Rohrer, F. Der Index der Körperfülle. 1921.',
      '4. Mosteller, R.D. Simplified calculation of BSA. NEJM, 1987.',
      '5. WHO Expert Consultation. BMI for Asian populations. The Lancet, 2004.',
      '6. Ashwell & Gibson. WHtR as health risk indicator. BMJ Open, 2016.',
      '7. Hodgdon & Beckett. Prediction of body fat — U.S. Navy method. 1984.',
      '8. Deurenberg et al. BMI as a measure of body fatness. BJN, 1991.',
      '9. American Council on Exercise. ACE Personal Trainer Manual. 2020.',
      '10. Hamwi, G.J. Changing dietary concepts. 1964.',
      '11. Devine, B.J. Gentamicin therapy. Drug Intelligence, 1974.',
      '12. Robinson et al. Determination of IBW. AJHP, 1983.',
      '13. Miller et al. Determining ideal body weight. AJHP, 1983.',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: refs
          .map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(r,
                    style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted, height: 1.6)),
              ))
          .toList(),
    );
  }
}
