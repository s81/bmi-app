import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final _client = Supabase.instance.client;

  User? get user => _client.auth.currentUser;
  bool get isSignedIn => user != null;
  String? get displayName => user?.email?.split('@').first;

  AuthProvider() {
    _client.auth.onAuthStateChange.listen((_) => notifyListeners());
  }

  Future<String?> signUp(String email, String password, String name) async {
    try {
      await _client.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': name},
      );
      // Update profile display name
      if (_client.auth.currentUser != null) {
        await _client
            .from('profiles')
            .update({'display_name': name})
            .eq('id', _client.auth.currentUser!.id);
      }
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return null;
    } on AuthException catch (e) {
      return e.message;
    }
  }
}
