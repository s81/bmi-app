import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/bmi_inputs.dart';
import '../models/bmi_results.dart';
import '../theme/app_theme.dart';
import 'risk_chip.dart';

class BmiHeroCard extends StatelessWidget {
  final BmiInputs inputs;
  final BmiResults results;

  const BmiHeroCard({super.key, required this.inputs, required this.results});

  @override
  Widget build(BuildContext context) {
    final catColor = AppColors.categoryHero[results.primaryCategory] ?? AppColors.blue;

    return Column(
      children: [
        // Hero BMI value card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.navy, AppColors.navy3],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withOpacity(0.22),
                blurRadius: 32, offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: BMI value
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STANDARD BMI',
                      style: GoogleFonts.dmSans(
                        fontSize: 10, fontWeight: FontWeight.w700,
                        color: const Color(0xFF8BB8E8), letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      results.standardBmi.toStringAsFixed(2),
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 52, fontWeight: FontWeight.w600,
                        color: Colors.white, letterSpacing: -1,
                        height: 1,
                      ),
                    ),
                    Text(
                      'kg / m²',
                      style: GoogleFonts.dmSans(
                        fontSize: 12, color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              // Right: Category + risk
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    results.primaryCategory,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 22, color: catColor, height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RiskChip(results.primaryRisk),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Patient details bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withOpacity(0.06),
                blurRadius: 4, offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Wrap(
            spacing: 20,
            runSpacing: 6,
            children: [
              _detail('Age', '${inputs.age}'),
              _detail('Sex', inputs.sex),
              _detail('Height', inputs.heightDisplay),
              _detail('Weight', inputs.weightDisplay),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detail(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label  ',
            style: GoogleFonts.dmSans(
              fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMain,
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
