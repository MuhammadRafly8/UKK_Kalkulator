
class CalculationHistory {
  final String expression; 
  final String result;     
  final DateTime timestamp;

  CalculationHistory({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  // Konversi ke Map (untuk simpan ke shared_preferences)
  Map<String, dynamic> toMap() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  // Buat dari Map
  factory CalculationHistory.fromMap(Map<String, dynamic> map) {
    return CalculationHistory(
      expression: map['expression'],
      result: map['result'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }
}