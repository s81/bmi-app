import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _emailCtrl  = TextEditingController();
  final _passCtrl   = TextEditingController();
  bool _loading     = false;
  bool _obscure     = true;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final err = await context.read<AuthProvider>().signIn(
      _emailCtrl.text.trim(), _passCtrl.text,
    );
    if (mounted) setState(() { _loading = false; _error = err; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text('Welcome back',
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 32, color: AppColors.navy)),
                const SizedBox(height: 8),
                Text('Sign in to track your BMI over time.',
                    style: GoogleFonts.dmSans(
                        fontSize: 15, color: AppColors.muted)),
                const SizedBox(height: 40),

                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      border: Border.all(color: const Color(0xFFF87171)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_error!,
                        style: GoogleFonts.dmSans(
                            fontSize: 13, color: const Color(0xFF7F1D1D))),
                  ),
                  const SizedBox(height: 20),
                ],

                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) => (v?.contains('@') ?? false) ? null : 'Enter a valid email',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: AppColors.muted),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => (v?.length ?? 0) >= 6 ? null : 'Min 6 characters',
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _signIn,
                    child: _loading
                        ? const SizedBox(height: 20, width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Sign In'),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SignUpScreen())),
                    child: Text(
                      "Don't have an account? Sign up",
                      style: GoogleFonts.dmSans(
                          fontSize: 14, color: AppColors.blue,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                Center(
                  child: TextButton(
                    onPressed: () async {
                      final email = _emailCtrl.text.trim();
                      if (email.isEmpty || !email.contains('@')) {
                        setState(() => _error = 'Enter your email above first');
                        return;
                      }
                      final err = await context.read<AuthProvider>().resetPassword(email);
                      if (mounted) {
                        setState(() => _error = err);
                        if (err == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Password reset email sent')),
                          );
                        }
                      }
                    },
                    child: Text(
                      'Forgot password?',
                      style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
