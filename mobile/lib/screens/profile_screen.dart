import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/history_provider.dart';
import '../theme/app_theme.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth    = context.watch<AuthProvider>();
    final history = context.watch<HistoryProvider>();

    if (!auth.isSignedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_outline, size: 56, color: AppColors.muted),
                const SizedBox(height: 16),
                Text('Not signed in',
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 22, color: AppColors.navy)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen())),
                    child: const Text('Sign In'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final entries = history.entries;
    final totalEntries = entries.length;
    final avgBmi = totalEntries > 0
        ? entries.map((e) => e.standardBmi).reduce((a, b) => a + b) / totalEntries
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + name
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.blue.withOpacity(0.15),
                  child: Text(
                    (auth.displayName ?? '?').substring(0, 1).toUpperCase(),
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 28, color: AppColors.blue),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        auth.displayName ?? 'User',
                        style: GoogleFonts.dmSans(
                            fontSize: 18, fontWeight: FontWeight.w600,
                            color: AppColors.navy),
                      ),
                      Text(
                        auth.user?.email ?? '',
                        style: GoogleFonts.dmSans(
                            fontSize: 13, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Stats
            Text('YOUR STATS',
                style: GoogleFonts.dmSans(
                    fontSize: 11, fontWeight: FontWeight.w700,
                    color: AppColors.muted, letterSpacing: 0.9)),
            const SizedBox(height: 10),
            Row(
              children: [
                _statCard('Calculations', '$totalEntries'),
                const SizedBox(width: 12),
                _statCard('Avg BMI', avgBmi != null ? avgBmi.toStringAsFixed(1) : '—'),
              ],
            ),

            const SizedBox(height: 32),

            // Actions
            Text('ACCOUNT',
                style: GoogleFonts.dmSans(
                    fontSize: 11, fontWeight: FontWeight.w700,
                    color: AppColors.muted, letterSpacing: 0.9)),
            const SizedBox(height: 10),

            _tile(
              icon: Icons.delete_sweep_outlined,
              label: 'Clear all history',
              color: const Color(0xFFDC2626),
              onTap: () => _confirmClearHistory(context, history),
            ),
            const SizedBox(height: 8),
            _tile(
              icon: Icons.logout,
              label: 'Sign out',
              color: AppColors.navy,
              onTap: () async {
                history.clear();
                await auth.signOut();
              },
            ),

            const SizedBox(height: 40),
            Center(
              child: Text(
                'BMI Calculator v1.0.0',
                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'For informational purposes only.',
                style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value) {
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
            Text(value,
                style: GoogleFonts.dmSerifDisplay(
                    fontSize: 28, color: AppColors.blue)),
            const SizedBox(height: 4),
            Text(label,
                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(label,
                style: GoogleFonts.dmSans(
                    fontSize: 14, fontWeight: FontWeight.w500, color: color)),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmClearHistory(
      BuildContext context, HistoryProvider history) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear all history?'),
        content: const Text('This permanently deletes all your saved calculations.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete all',
                  style: TextStyle(color: Color(0xFFDC2626)))),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      for (final e in List.from(history.entries)) {
        await history.delete(e.id);
      }
    }
  }
}
