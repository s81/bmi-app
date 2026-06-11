import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';

class MethodologyScreen extends StatelessWidget {
  const MethodologyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Methodology', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 4),
            Text(
              'For informational purposes only — not a clinical assessment.',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SectionHeader('Validated Indices'),

            _formulaCard(
              'Standard BMI',
              'WHO, 1995',
              'BMI = weight (kg) / height² (m)',
              'The foundational index proposed by WHO for population-level obesity screening. '
              'Defined as body weight divided by the square of height. [1]',
            ),
            _formulaCard(
              'New BMI — Peterson Formula',
              'Peterson et al., 2016',
              'New BMI = 1.3 × weight (kg) / height²·⁵ (m)',
              "Corrects the standard formula's systematic bias against tall individuals "
              'by raising the height exponent from 2 to 2.5. [2]',
            ),
            _formulaCard(
              'Ponderal Index',
              'Rohrer, 1921',
              'PI = weight (kg) / height³ (m)',
              'An alternative slenderness measure less sensitive to height variation than BMI. '
              'Normal range: 11–14 kg/m³. [3]',
            ),
            _formulaCard(
              'Body Surface Area — Mosteller',
              'Mosteller, 1987',
              'BSA = √( height (cm) × weight (kg) / 3600 )',
              'Used clinically for chemotherapy dosing and cardiac output normalisation. '
              'Reported in m². [4]',
            ),
            _formulaCard(
              'Waist-to-Height Ratio',
              'Ashwell & Gibson, 2016',
              'WHtR = waist (cm) / height (cm)',
              'Stronger predictor of cardiometabolic risk than BMI alone. '
              'Evidence-based target: WHtR < 0.5. [6]',
            ),
            _formulaCard(
              'IBW — Hamwi Formula',
              'Hamwi, 1964',
              'Male:   IBW = 48.0 + 2.7 × (h_in − 60)\n'
              'Female: IBW = 45.5 + 2.2 × (h_in − 60)',
              'Original IBW formula developed for insulin dosing in diabetes. Height in inches above 5 ft. [10]',
            ),
            _formulaCard(
              'IBW — Devine Formula',
              'Devine, 1974',
              'Male:   IBW = 50.0 + 2.3 × (h_in − 60)\n'
              'Female: IBW = 45.5 + 2.3 × (h_in − 60)',
              'Most widely used IBW formula in clinical practice. Standard reference in pharmacokinetics. [11]',
            ),
            _formulaCard(
              'Body Fat % — U.S. Navy',
              'Hodgdon & Beckett, 1984',
              '%BF = 495 / (1.0324 − 0.19077·log₁₀(W−N) + 0.15456·log₁₀(H)) − 450',
              'W = waist, N = neck, H = height (all cm). Validated on U.S. military. Accuracy ±3–4%. [7]',
            ),
            _formulaCard(
              'Body Fat % — Deurenberg',
              'Deurenberg et al., 1991',
              '%BF = 1.20 × BMI + 0.23 × age − 10.8 × S − 5.4',
              'S = 1 for male, 0 for female. Requires only BMI and age. SEE ≈ 4.1%. [8]',
            ),

            const Divider(height: 32),

            const SectionHeader('Classification Tables'),

            _classTable(
              'WHO Standard',
              ['BMI (kg/m²)', 'Category', 'Risk'],
              [
                ['< 18.5',      'Underweight',     'Low (but other risks)'],
                ['18.5 – 24.9', 'Normal weight',   'Average'],
                ['25.0 – 29.9', 'Overweight',      'Increased'],
                ['30.0 – 34.9', 'Obese Class I',   'High'],
                ['35.0 – 39.9', 'Obese Class II',  'Very High'],
                ['≥ 40.0',      'Obese Class III', 'Extremely High'],
              ],
            ),

            const SizedBox(height: 16),
            _classTable(
              'WHO Asian Cutoffs',
              ['BMI (kg/m²)', 'Category', 'Risk'],
              [
                ['< 18.5',      'Underweight',  'Low (but other risks)'],
                ['18.5 – 22.9', 'Normal weight','Average'],
                ['23.0 – 27.4', 'Overweight',   'Increased'],
                ['≥ 27.5',      'Obese',        'High'],
              ],
              subtitle: 'Recommended for East and South Asian populations. [5]',
            ),

            const SizedBox(height: 16),
            _classTable(
              'Ponderal Index',
              ['PI (kg/m³)', 'Category'],
              [
                ['< 11',   'Underweight'],
                ['11 – 14','Normal'],
                ['> 14',   'Overweight'],
              ],
              hasRisk: false,
            ),

            const SizedBox(height: 16),
            _classTable(
              'Waist-to-Height Ratio',
              ['WHtR', 'Category', 'Risk'],
              [
                ['< 0.40',       'Extremely Slim', 'Low (but other risks)'],
                ['0.40 – 0.499', 'Healthy',        'Average'],
                ['0.50 – 0.599', 'Increased Risk', 'Increased'],
                ['≥ 0.60',       'High Risk',      'High'],
              ],
              subtitle: 'Applicable across all ethnicities. [6]',
            ),
          ],
        ),
      ),
    );
  }

  Widget _formulaCard(String title, String citation, String formula, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withOpacity(0.06),
            blurRadius: 4, offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: AppColors.navy),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF3FA),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  citation,
                  style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5FB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              formula,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13, color: AppColors.navy3,
                fontWeight: FontWeight.w500, height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _classTable(
    String title,
    List<String> headers,
    List<List<String>> rows, {
    String? subtitle,
    bool hasRisk = true,
  }) {
    const riskBgs = {
      'Low (but other risks)': Color(0xFFD1FAE5),
      'Average':               Color(0xFFDBEAFE),
      'Increased':             Color(0xFFFEF3C7),
      'High':                  Color(0xFFFEE2E2),
      'Very High':             Color(0xFFFEE2E2),
      'Extremely High':        Color(0xFFFFE4E6),
    };
    const riskFgs = {
      'Low (but other risks)': Color(0xFF065F46),
      'Average':               Color(0xFF1E3A8A),
      'Increased':             Color(0xFF78350F),
      'High':                  Color(0xFF7F1D1D),
      'Very High':             Color(0xFF7F1D1D),
      'Extremely High':        Color(0xFF881337),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: AppColors.navy)),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
        ],
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Table(
            border: TableBorder(
              horizontalInside: const BorderSide(color: AppColors.border, width: 0.5),
            ),
            children: [
              TableRow(
                decoration: const BoxDecoration(color: AppColors.navy),
                children: headers.map((h) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(h.toUpperCase(),
                    style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700,
                      color: const Color(0xFF8BB8E8), letterSpacing: 0.7)),
                )).toList(),
              ),
              ...rows.asMap().entries.map((e) {
                final i = e.key;
                final row = e.value;
                return TableRow(
                  decoration: BoxDecoration(color: i.isOdd ? const Color(0xFFFAFCFF) : AppColors.card),
                  children: row.asMap().entries.map((ce) {
                    final ci = ce.key;
                    final cell = ce.value;
                    final isRisk = hasRisk && ci == row.length - 1;
                    if (isRisk) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: riskBgs[cell] ?? const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(cell,
                            style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600,
                              color: riskFgs[cell] ?? AppColors.muted)),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text(cell,
                        style: ci == 0
                          ? GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy3)
                          : GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMain)),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
