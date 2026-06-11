import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onGetStarted;
  const HomeScreen({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              Text(
                'SCIENTIFIC BMI ANALYSIS',
                style: GoogleFonts.dmSans(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  color: AppColors.muted, letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'Body Mass\nIndex Calculator',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 36, color: AppColors.navy,
                  height: 1.15, letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                'Four validated indices · WHO & Asian cutoffs · Full scientific report',
                style: GoogleFonts.dmSans(
                  fontSize: 15, color: AppColors.muted, height: 1.6,
                ),
              ),

              const SizedBox(height: 24),

              // Feature chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip('Standard BMI (WHO)'),
                  _chip('New BMI — Peterson 2016'),
                  _chip('Ponderal Index'),
                  _chip('BSA — Mosteller'),
                  _chip('Body Fat % (Navy/Deurenberg)'),
                  _chip('Ideal Body Weight (4 formulas)'),
                ],
              ),

              const SizedBox(height: 28),

              // Disclaimer
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: const BorderSide(color: Color(0xFFF97316), width: 4),
                    top: const BorderSide(color: Color(0xFFFED7AA)),
                    right: const BorderSide(color: Color(0xFFFED7AA)),
                    bottom: const BorderSide(color: Color(0xFFFED7AA)),
                  ),
                ),
                child: Text(
                  'ℹ️  This tool is for informational purposes only and does not replace clinical assessment.',
                  style: GoogleFonts.dmSans(
                    fontSize: 13, color: const Color(0xFF7C2D12), height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onGetStarted,
                  child: const Text('Get Started →'),
                ),
              ),

              const SizedBox(height: 48),

              // Stats row
              Row(
                children: [
                  _stat('4', 'Validated\nIndices'),
                  const SizedBox(width: 16),
                  _stat('WHO', 'International\nStandards'),
                  const SizedBox(width: 16),
                  _stat('13', 'Scientific\nReferences'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF3FA),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 12, fontWeight: FontWeight.w600,
          color: AppColors.navy3,
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 28, color: AppColors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 11, color: AppColors.muted, height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
