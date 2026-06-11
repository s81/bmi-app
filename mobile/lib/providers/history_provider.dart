import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/history_entry.dart';
import '../models/bmi_inputs.dart';
import '../models/bmi_results.dart';
import 'auth_provider.dart';

class HistoryProvider extends ChangeNotifier {
  final _client = Supabase.instance.client;

  List<HistoryEntry> _entries = [];
  bool _loading = false;
  String? _error;

  List<HistoryEntry> get entries => _entries;
  bool get loading => _loading;
  String? get error => _error;
  bool get hasEntries => _entries.isNotEmpty;

  Future<void> load() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      _entries = [];
      notifyListeners();
      return;
    }
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await _client
          .from('bmi_history')
          .select()
          .eq('user_id', userId)
          .order('recorded_at', ascending: false)
          .limit(100);
      _entries = (data as List).map((m) => HistoryEntry.fromMap(m as Map<String, dynamic>)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> save(BmiInputs inputs, BmiResults results) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    final entry = HistoryEntry(
      id:              '',
      recordedAt:      DateTime.now(),
      age:             inputs.age,
      sex:             inputs.sex,
      ethnicity:       inputs.ethnicity,
      heightCm:        inputs.heightCm,
      weightKg:        inputs.weightKg,
      waistCm:         inputs.waistCm,
      neckCm:          inputs.neckCm,
      hipCm:           inputs.hipCm,
      isImperial:      inputs.imperial,
      standardBmi:     results.standardBmi,
      primaryCategory: results.primaryCategory,
      primaryRisk:     results.primaryRisk,
      newBmi:          results.newBmi,
      ponderalIndex:   results.pi,
      bsa:             results.bsa,
      whtr:            results.whtr,
    );

    try {
      final inserted = await _client
          .from('bmi_history')
          .insert(entry.toInsertMap(userId))
          .select()
          .single();
      _entries.insert(0, HistoryEntry.fromMap(inserted));
      notifyListeners();
    } catch (_) {}
  }

  Future<void> delete(String id) async {
    await _client.from('bmi_history').delete().eq('id', id);
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void clear() {
    _entries = [];
    _loading = false;
    _error = null;
    notifyListeners();
  }

  void onAuthChanged(AuthProvider auth) {
    if (auth.isSignedIn) {
      load();
    } else {
      clear();
    }
  }
}
