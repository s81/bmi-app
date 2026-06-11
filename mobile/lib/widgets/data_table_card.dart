import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'risk_chip.dart';

/// Generic styled table card matching the web app's design.
class DataTableCard extends StatelessWidget {
  final List<String> headers;
  final List<List<Widget>> rows;

  const DataTableCard({super.key, required this.headers, required this.rows});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          // Header row
          Container(
            color: AppColors.navy,
            child: Row(
              children: headers
                  .map((h) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            h.toUpperCase(),
                            style: GoogleFonts.dmSans(
                              fontSize: 10, fontWeight: FontWeight.w700,
                              color: const Color(0xFF8BB8E8), letterSpacing: 0.7,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          // Data rows
          ...rows.asMap().entries.map((entry) {
            final i = entry.key;
            final row = entry.value;
            return Container(
              color: i.isOdd ? const Color(0xFFFAFCFF) : AppColors.card,
              child: Row(
                children: row
                    .map((cell) => Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: AppColors.border, width: 0.5),
                              ),
                            ),
                            child: cell,
                          ),
                        ))
                    .toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Convenience row builders ──────────────────────────────────────────────────

Widget monoText(String text) => Text(
      text,
      style: GoogleFonts.jetBrainsMono(
        fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy3,
      ),
    );

Widget bodyText(String text) => Text(
      text,
      style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMain),
    );

Widget mutedText(String text) => Text(
      text,
      style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
    );

Widget riskCell(String risk) => RiskChip(risk);

Widget deltaPctChip(double weightKg, double ibwKg) {
  final pct = (weightKg - ibwKg) / ibwKg * 100;
  final sign = pct >= 0 ? '+' : '';
  Color bg, fg;
  if (pct > 20) {
    bg = const Color(0xFFFEE2E2); fg = const Color(0xFF7F1D1D);
  } else if (pct > 5) {
    bg = const Color(0xFFFEF3C7); fg = const Color(0xFF78350F);
  } else if (pct >= -5) {
    bg = const Color(0xFFDBEAFE); fg = const Color(0xFF1E3A8A);
  } else {
    bg = const Color(0xFFD1FAE5); fg = const Color(0xFF065F46);
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: bg, borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      '$sign${pct.toStringAsFixed(1)}%',
      style: GoogleFonts.dmSans(
          fontSize: 12, fontWeight: FontWeight.w600, color: fg),
    ),
  );
}
