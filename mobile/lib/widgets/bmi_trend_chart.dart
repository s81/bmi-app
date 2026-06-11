import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/history_entry.dart';
import '../theme/app_theme.dart';

class BmiTrendChart extends StatelessWidget {
  final List<HistoryEntry> entries;

  const BmiTrendChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    // Show up to 20 most recent, in chronological order
    final data = entries.take(20).toList().reversed.toList();
    if (data.length < 2) {
      return Container(
        height: 140,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Record at least 2 entries to see your trend',
          style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted),
        ),
      );
    }

    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.standardBmi);
    }).toList();

    final minY = (spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) - 2).clamp(0, 50).toDouble();
    final maxY = (spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) + 2).toDouble();

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              'BMI TREND',
              style: GoogleFonts.dmSans(
                fontSize: 10, fontWeight: FontWeight.w700,
                color: AppColors.muted, letterSpacing: 0.9,
              ),
            ),
          ),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.border,
                    strokeWidth: 0.5,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: 5,
                      getTitlesWidget: (v, _) => Text(
                        v.toStringAsFixed(0),
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 9, color: AppColors.muted,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: (data.length / 4).ceilToDouble().clamp(1, 20),
                      getTitlesWidget: (v, _) {
                        final i = v.toInt();
                        if (i < 0 || i >= data.length) return const SizedBox();
                        return Text(
                          DateFormat('M/d').format(data[i].recordedAt),
                          style: GoogleFonts.dmSans(fontSize: 9, color: AppColors.muted),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                // Reference lines for BMI categories
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(y: 18.5, color: const Color(0xFF10B981).withOpacity(0.5), strokeWidth: 1, dashArray: [4, 4]),
                    HorizontalLine(y: 25.0, color: const Color(0xFFD97706).withOpacity(0.5), strokeWidth: 1, dashArray: [4, 4]),
                    HorizontalLine(y: 30.0, color: const Color(0xFFDC2626).withOpacity(0.5), strokeWidth: 1, dashArray: [4, 4]),
                  ],
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: AppColors.blue,
                    barWidth: 2.5,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (s, pct, bar, idx) => FlDotCirclePainter(
                        radius: 3.5,
                        color: AppColors.card,
                        strokeWidth: 2,
                        strokeColor: AppColors.blue,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.blue.withOpacity(0.15),
                          AppColors.blue.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => AppColors.navy,
                    getTooltipItems: (spots) => spots.map((s) {
                      final entry = data[s.x.toInt()];
                      return LineTooltipItem(
                        '${entry.standardBmi.toStringAsFixed(2)}\n${DateFormat('MMM d, y').format(entry.recordedAt)}',
                        GoogleFonts.jetBrainsMono(
                          fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 6),
            child: Row(
              children: [
                _legend(const Color(0xFF10B981), '18.5'),
                const SizedBox(width: 12),
                _legend(const Color(0xFFD97706), '25.0'),
                const SizedBox(width: 12),
                _legend(const Color(0xFFDC2626), '30.0'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(width: 16, height: 1.5, color: color),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.dmSans(fontSize: 9, color: AppColors.muted)),
      ],
    );
  }
}
