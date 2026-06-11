import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class BmiScaleChart extends StatelessWidget {
  final double bmiValue;
  final bool isAsian;

  const BmiScaleChart({
    super.key,
    required this.bmiValue,
    this.isAsian = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isAsian ? 'BMI SCALE — ASIAN CUTOFFS (WHO 2004)' : 'BMI SCALE — WHO STANDARD',
            style: GoogleFonts.dmSans(
              fontSize: 10, fontWeight: FontWeight.w700,
              color: AppColors.muted, letterSpacing: 0.9,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 72,
            child: CustomPaint(
              painter: _BmiScalePainter(bmiValue: bmiValue, isAsian: isAsian),
              size: Size.infinite,
            ),
          ),
        ],
      ),
    );
  }
}

class _BmiScalePainter extends CustomPainter {
  final double bmiValue;
  final bool isAsian;

  const _BmiScalePainter({required this.bmiValue, required this.isAsian});

  static const _scaleLo = 10.0;
  static const _scaleHi = 45.0;

  double _toPx(double v, double width) =>
      (v - _scaleLo) / (_scaleHi - _scaleLo) * width;

  @override
  void paint(Canvas canvas, Size size) {
    final barH = 22.0;
    final barY = 20.0;
    final barW = size.width;

    final bands = isAsian
        ? [
            (10.0, 18.5, const Color(0xFF10B981), 'Underweight'),
            (18.5, 23.0, const Color(0xFF2563EB), 'Normal'),
            (23.0, 27.5, const Color(0xFFD97706), 'Overweight'),
            (27.5, 45.0, const Color(0xFFDC2626), 'Obese'),
          ]
        : [
            (10.0, 18.5, const Color(0xFF10B981), 'Underweight'),
            (18.5, 25.0, const Color(0xFF2563EB), 'Normal'),
            (25.0, 30.0, const Color(0xFFD97706), 'Overweight'),
            (30.0, 35.0, const Color(0xFFDC2626), 'Obese I'),
            (35.0, 40.0, const Color(0xFFBE123C), 'Obese II'),
            (40.0, 45.0, const Color(0xFF9F1239), 'Obese III'),
          ];

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, barY, barW, barH),
      const Radius.circular(6),
    );
    canvas.clipRRect(rrect);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (final (lo, hi, color, label) in bands) {
      final x1 = _toPx(lo, barW);
      final x2 = _toPx(hi, barW);
      canvas.drawRect(
        Rect.fromLTWH(x1, barY, x2 - x1, barH),
        Paint()..color = color,
      );

      if (x2 - x1 >= 32) {
        textPainter.text = TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 8.5, fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        );
        textPainter.layout();
        final tx = x1 + (x2 - x1) / 2 - textPainter.width / 2;
        final ty = barY + barH / 2 - textPainter.height / 2 + 2;
        textPainter.paint(canvas, Offset(tx, ty));
      }
    }

    canvas.restore();

    // Tick marks
    final ticks = isAsian ? [18.5, 23.0, 27.5] : [18.5, 25.0, 30.0, 35.0, 40.0];
    final tickPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.5;

    for (final v in ticks) {
      final tx = _toPx(v, barW);
      canvas.drawLine(Offset(tx, barY + barH), Offset(tx, barY + barH + 5), tickPaint);

      textPainter.text = TextSpan(
        text: v.toString(),
        style: const TextStyle(fontSize: 9, color: Color(0xFF536780)),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(tx - textPainter.width / 2, barY + barH + 6));
    }

    // Marker
    final mx = _toPx(bmiValue.clamp(_scaleLo + 0.1, _scaleHi - 0.1), barW);
    canvas.drawLine(
      Offset(mx, barY),
      Offset(mx, barY + barH),
      Paint()
        ..color = Colors.white.withOpacity(0.85)
        ..strokeWidth = 2,
    );

    // Triangle pointer above bar
    final triPath = Path()
      ..moveTo(mx, barY - 2)
      ..lineTo(mx - 6, barY - 14)
      ..lineTo(mx + 6, barY - 14)
      ..close();
    canvas.drawPath(triPath, Paint()..color = AppColors.navy);

    // BMI value label
    textPainter.text = TextSpan(
      text: bmiValue.toStringAsFixed(2),
      style: const TextStyle(
        fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.navy,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(mx - textPainter.width / 2, barY - 24));
  }

  @override
  bool shouldRepaint(_BmiScalePainter old) =>
      old.bmiValue != bmiValue || old.isAsian != isAsian;
}
