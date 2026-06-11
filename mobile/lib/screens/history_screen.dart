import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/history_entry.dart';
import '../providers/auth_provider.dart';
import '../providers/history_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/bmi_trend_chart.dart';
import '../widgets/risk_chip.dart';
import '../widgets/section_header.dart';
import 'auth/login_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthProvider>().isSignedIn) {
        context.read<HistoryProvider>().load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth    = context.watch<AuthProvider>();
    final history = context.watch<HistoryProvider>();

    if (!auth.isSignedIn) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 56, color: AppColors.muted),
                const SizedBox(height: 16),
                Text('Sign in to track your BMI',
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 22, color: AppColors.navy)),
                const SizedBox(height: 8),
                Text('Create a free account to save your\ncalculations and see trends over time.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                        fontSize: 14, color: AppColors.muted, height: 1.5)),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen())),
                    child: const Text('Sign In / Sign Up'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: history.load,
        color: AppColors.blue,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('History',
                              style: Theme.of(context).textTheme.displayMedium),
                        ),
                        if (history.loading)
                          const SizedBox(width: 16, height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.blue)),
                      ],
                    ),
                    Text(
                      'Pull down to refresh',
                      style: GoogleFonts.dmSans(
                          fontSize: 12, color: AppColors.muted),
                    ),
                    const SizedBox(height: 16),

                    // Trend chart
                    if (history.hasEntries) ...[
                      BmiTrendChart(entries: history.entries),
                      const SizedBox(height: 8),
                      _statsRow(history.entries),
                    ],

                    const SectionHeader('All Records'),
                  ],
                ),
              ),
            ),

            if (!history.hasEntries && !history.loading)
              SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bar_chart_outlined,
                            size: 56, color: AppColors.muted),
                        const SizedBox(height: 16),
                        Text('No records yet',
                            style: GoogleFonts.dmSerifDisplay(
                                fontSize: 20, color: AppColors.navy)),
                        const SizedBox(height: 8),
                        Text(
                          'Complete a calculation to automatically save your first entry.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                              fontSize: 13, color: AppColors.muted, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _entryCard(context, history.entries[i], history),
                  childCount: history.entries.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statsRow(List<HistoryEntry> entries) {
    final bmis = entries.map((e) => e.standardBmi).toList();
    final avg  = bmis.reduce((a, b) => a + b) / bmis.length;
    final min  = bmis.reduce((a, b) => a < b ? a : b);
    final max  = bmis.reduce((a, b) => a > b ? a : b);
    return Row(
      children: [
        _statCard('Average', avg.toStringAsFixed(1)),
        const SizedBox(width: 8),
        _statCard('Lowest', min.toStringAsFixed(1)),
        const SizedBox(width: 8),
        _statCard('Highest', max.toStringAsFixed(1)),
        const SizedBox(width: 8),
        _statCard('Entries', '${entries.length}'),
      ],
    );
  }

  Widget _statCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 16, fontWeight: FontWeight.w600,
                    color: AppColors.navy3)),
            const SizedBox(height: 2),
            Text(label,
                style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.muted)),
          ],
        ),
      ),
    );
  }

  Widget _entryCard(BuildContext context, HistoryEntry e, HistoryProvider history) {
    final colors = AppColors.riskColors(e.primaryRisk);
    return Dismissible(
      key: Key(e.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Color(0xFFDC2626)),
      ),
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Delete entry?'),
          content: Text(
              'Remove the record from ${DateFormat('MMM d, y').format(e.recordedAt)}?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete', style: TextStyle(color: Color(0xFFDC2626)))),
          ],
        ),
      ),
      onDismissed: (_) => history.delete(e.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: AppColors.navy.withOpacity(0.04), blurRadius: 3)],
        ),
        child: Row(
          children: [
            // Left: BMI value
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: colors['bg'],
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    e.standardBmi.toStringAsFixed(1),
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 18, fontWeight: FontWeight.w700,
                        color: colors['text']),
                  ),
                  Text('BMI',
                      style: GoogleFonts.dmSans(
                          fontSize: 9, color: colors['text'], fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Middle: details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.primaryCategory,
                    style: GoogleFonts.dmSans(
                        fontSize: 14, fontWeight: FontWeight.w600,
                        color: AppColors.textMain),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${e.weightKg.toStringAsFixed(1)} kg · ${e.heightCm.toStringAsFixed(0)} cm · ${e.sex}',
                    style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
                  ),
                  const SizedBox(height: 4),
                  RiskChip(e.primaryRisk),
                ],
              ),
            ),
            // Right: date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('MMM d').format(e.recordedAt),
                  style: GoogleFonts.dmSans(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: AppColors.navy3),
                ),
                Text(
                  DateFormat('y').format(e.recordedAt),
                  style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
