import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class RiskChip extends StatelessWidget {
  final String risk;
  const RiskChip(this.risk, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.riskColors(risk);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors['bg'],
        border: Border.all(color: colors['border']!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6, height: 6,
            decoration: BoxDecoration(
              color: colors['dot'],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            risk,
            style: GoogleFonts.dmSans(
              fontSize: 11, fontWeight: FontWeight.w600,
              color: colors['text'],
            ),
          ),
        ],
      ),
    );
  }
}
