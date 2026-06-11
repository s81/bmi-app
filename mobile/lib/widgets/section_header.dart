import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String label;
  const SectionHeader(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.dmSans(
          fontSize: 11, fontWeight: FontWeight.w700,
          color: AppColors.muted, letterSpacing: 0.9,
        ),
      ),
    );
  }
}
