import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  bool _loading    = false;
  bool _obscure    = true;
  String? _error;

  @override
  void dispose() {
    for (final c in [_nameCtrl, _emailCtrl, _passCtrl, _pass2Ctrl]) c.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final err = await context.read<AuthProvider>().signUp(
      _emailCtrl.text.trim(), _passCtrl.text, _nameCtrl.text.trim(),
    );
    if (mounted) {
      if (err == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created! Check your email to confirm.')),
        );
      } else {
        setState(() { _loading = false; _error = err; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create account',
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 28, color: AppColors.navy)),
                const SizedBox(height: 8),
                Text('Start tracking your health journey.',
                    style: GoogleFonts.dmSans(
                        fontSize: 15, color: AppColors.muted)),
                const SizedBox(height: 32),

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
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Display Name'),
                  validator: (v) => (v?.trim().isNotEmpty ?? false) ? null : 'Enter your name',
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pass2Ctrl,
                  obscureText: _obscure,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                  validator: (v) => v == _passCtrl.text ? null : 'Passwords do not match',
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _signUp,
                    child: _loading
                        ? const SizedBox(height: 20, width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Create Account'),
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
