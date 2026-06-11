import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const navy     = Color(0xFF0A1628);
  static const navy2    = Color(0xFF162845);
  static const navy3    = Color(0xFF1E3A5F);
  static const blue     = Color(0xFF0F6CBD);
  static const blueLt   = Color(0xFFDBEAFE);
  static const bg       = Color(0xFFF7F9FC);
  static const card     = Color(0xFFFFFFFF);
  static const border   = Color(0xFFD9E4F0);
  static const textMain = Color(0xFF0D1B2E);
  static const muted    = Color(0xFF536780);

  // Risk palette
  static const Map<String, Map<String, Color>> risk = {
    'Low (but other risks)': {'bg': Color(0xFFD1FAE5), 'text': Color(0xFF065F46), 'border': Color(0xFF059669), 'dot': Color(0xFF10B981)},
    'Average':               {'bg': Color(0xFFDBEAFE), 'text': Color(0xFF1E3A8A), 'border': Color(0xFF3B82F6), 'dot': Color(0xFF2563EB)},
    'Increased':             {'bg': Color(0xFFFEF3C7), 'text': Color(0xFF78350F), 'border': Color(0xFFF59E0B), 'dot': Color(0xFFD97706)},
    'High':                  {'bg': Color(0xFFFEE2E2), 'text': Color(0xFF7F1D1D), 'border': Color(0xFFF87171), 'dot': Color(0xFFDC2626)},
    'Very High':             {'bg': Color(0xFFFEE2E2), 'text': Color(0xFF7F1D1D), 'border': Color(0xFFF87171), 'dot': Color(0xFFDC2626)},
    'Extremely High':        {'bg': Color(0xFFFFE4E6), 'text': Color(0xFF881337), 'border': Color(0xFFFB7185), 'dot': Color(0xFFBE123C)},
    'Low':                   {'bg': Color(0xFFD1FAE5), 'text': Color(0xFF065F46), 'border': Color(0xFF059669), 'dot': Color(0xFF10B981)},
    'Elevated':              {'bg': Color(0xFFFEF3C7), 'text': Color(0xFF78350F), 'border': Color(0xFFF59E0B), 'dot': Color(0xFFD97706)},
    '—':                     {'bg': Color(0xFFF1F5F9), 'text': Color(0xFF475569), 'border': Color(0xFFCBD5E1), 'dot': Color(0xFF94A3B8)},
  };

  static Map<String, Color> riskColors(String risk_) =>
      risk[risk_] ?? risk['—']!;

  // Category hero colors
  static const Map<String, Color> categoryHero = {
    'Underweight':     Color(0xFF10B981),
    'Normal weight':   Color(0xFF2563EB),
    'Overweight':      Color(0xFFD97706),
    'Obese':           Color(0xFFDC2626),
    'Obese Class I':   Color(0xFFDC2626),
    'Obese Class II':  Color(0xFFBE123C),
    'Obese Class III': Color(0xFF9F1239),
  };
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      background: AppColors.bg,
    ),
    scaffoldBackgroundColor: AppColors.bg,
    useMaterial3: true,
  );

  return base.copyWith(
    textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.dmSerifDisplay(
        fontSize: 32, fontWeight: FontWeight.w400, color: AppColors.navy,
        letterSpacing: -0.3, height: 1.15,
      ),
      displayMedium: GoogleFonts.dmSerifDisplay(
        fontSize: 24, fontWeight: FontWeight.w400, color: AppColors.navy,
      ),
      titleLarge: GoogleFonts.dmSans(
        fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.navy,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16, color: AppColors.textMain,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14, color: AppColors.textMain,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12, color: AppColors.muted,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 11, fontWeight: FontWeight.w700,
        color: AppColors.muted, letterSpacing: 0.8,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.navy,
      foregroundColor: const Color(0xFFC8D9F0),
      elevation: 0,
      titleTextStyle: GoogleFonts.dmSerifDisplay(
        fontSize: 20, color: const Color(0xFFC8D9F0),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.navy,
      indicatorColor: AppColors.blue.withOpacity(0.3),
      labelTextStyle: MaterialStateProperty.all(
        GoogleFonts.dmSans(fontSize: 11, color: const Color(0xFFC8D9F0)),
      ),
      iconTheme: MaterialStateProperty.all(
        const IconThemeData(color: Color(0xFFC8D9F0)),
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
      ),
      labelStyle: GoogleFonts.dmSans(
        fontSize: 12, fontWeight: FontWeight.w600,
        color: AppColors.muted, letterSpacing: 0.5,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.blue,
        side: const BorderSide(color: AppColors.blue, width: 1.5),
        textStyle: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
