// lib/shared/providers/history_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/history/models/calculation_history.dart';
import 'package:project/history/services/history_service.dart';
final historyServiceProvider = Provider((ref) => HistoryService());

final historyProvider = FutureProvider<List<CalculationHistory>>((ref) async {
  final service = ref.watch(historyServiceProvider);
  return await service.getHistory();
});