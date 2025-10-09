
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/history/models/calculation_history.dart';

class HistoryService {
  static const String _historyKey = 'calculation_history_list';

  Future<void> saveEntry(String expression, String result) async {
    if (expression.isEmpty || result == 'Error') return;

    final prefs = await SharedPreferences.getInstance();
    final List<String>? existing = prefs.getStringList(_historyKey);
    final List<Map<String, dynamic>> historyList = existing?.map((e) => Map<String, dynamic>.from(jsonDecode(e))).toList() ?? [];

    // Tambahkan entri baru di awal
    final newEntry = CalculationHistory(
      expression: expression,
      result: result,
      timestamp: DateTime.now(),
    ).toMap();

    historyList.insert(0, newEntry);

    // Batasi hanya 50 entri terakhir
    if (historyList.length > 50) {
      historyList.removeRange(50, historyList.length);
    }

    // Simpan kembali
    final encodedList = historyList.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList(_historyKey, encodedList);
  }

  Future<List<CalculationHistory>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encodedList = prefs.getStringList(_historyKey);
    if (encodedList == null || encodedList.isEmpty) return [];

    return encodedList
        .map((e) => CalculationHistory.fromMap(jsonDecode(e)))
        .toList();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}