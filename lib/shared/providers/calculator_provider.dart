
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:project/history/services/history_service.dart';

class CalculatorState {
  final String input;
  final String output;

  CalculatorState({this.input = '', this.output = '0'});

  CalculatorState copyWith({String? input, String? output}) {
    return CalculatorState(
      input: input ?? this.input,
      output: output ?? this.output,
    );
  }
}

final calculatorProvider = StateNotifierProvider<CalculatorNotifier, CalculatorState>(
  (ref) => CalculatorNotifier(),
);

class CalculatorNotifier extends StateNotifier<CalculatorState> {
    final List<CalculatorState> _history = [];
    static const int _maxHistory = 10;
  CalculatorNotifier() : super(CalculatorState());

  void _saveToHistory() {
    if (_history.length >= _maxHistory) {
      _history.removeAt(0); // hapus yang paling lama
    }
    _history.add(CalculatorState(input: state.input, output: state.output));
  }

  void undo() {
    if (_history.isEmpty) return;
    final previousState = _history.removeLast();
    state = previousState;
  }

  void input(String value) {
    // Jika sebelumnya sudah tekan '=', reset saat input baru (kecuali '=' lagi)
    if (state.input.endsWith('=')) {
      if (value == '=') return;
       _saveToHistory(); // Abaikan tekan '=' berulang
      state = CalculatorState(); // Reset ke kondisi awal
    }

    if (value == '=') {
      calculate();
      return;
    }

    // Cegah operator di awal (kecuali minus)
    if (state.input.isEmpty && '+×÷'.contains(value)) return;

    // Cegah operator berturut-turut
    if (state.input.isNotEmpty &&
        '+−×÷'.contains(state.input[state.input.length - 1]) &&
        '+−×÷'.contains(value)) {
        _saveToHistory();
      final newInput = state.input.substring(0, state.input.length - 1) + value;
      state = state.copyWith(input: newInput);
      _evaluate();
      return;
    }
    _saveToHistory();
    state = state.copyWith(input: state.input + value);
    _evaluate();
  }

  void calculate() {
    if (state.input.isEmpty) return;

    // Konversi ke format math_expressions untuk evaluasi
    String expressionForEval = state.input
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-');

    try {
      Parser p = Parser();
      Expression exp = p.parse(expressionForEval);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);

      String formattedResult = result == result.toInt()
          ? result.toInt().toString()
          : result.toString();

      // Simpan riwayat hanya jika hasil valid
      if (formattedResult != 'Error') {
        HistoryService().saveEntry(state.input, formattedResult);
      }

      // Tampilkan input asli + '=' (misal: "2×3 =")
      state = state.copyWith(
        input: '${state.input} =',
        output: formattedResult,
      );
    } catch (e) {
      state = state.copyWith(output: 'Error');
    }
  }

  void clear() {
    if (state.input.isNotEmpty || state.output != '0') {
    _saveToHistory();
  }
    state = CalculatorState();
  }

  void backspace() {
    if (state.input.isNotEmpty) {
      _saveToHistory();
      // Jika input berakhir dengan '=', hapus seluruhnya
      if (state.input.endsWith('=')) {
        state = CalculatorState();
      } else {
        state = state.copyWith(
          input: state.input.substring(0, state.input.length - 1),
        );
        _evaluate();
      }
    }
  }

  void _evaluate() {
    if (state.input.isEmpty) {
      state = state.copyWith(output: '0');
      return;
    }

    // Hapus '=' di akhir jika ada (untuk evaluasi)
    String cleanInput = state.input.trim();
    if (cleanInput.endsWith('=')) {
      cleanInput = cleanInput.substring(0, cleanInput.length - 1).trim();
    }

    if (cleanInput.isEmpty) {
      state = state.copyWith(output: '0');
      return;
    }

    String expression = cleanInput
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-')
        .replaceAll('√', 'sqrt')
        .replaceAll('π', 'PI')
        .replaceAll('e', 'E')
        .replaceAll('^', '**');

    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);

      String formattedResult = result == result.toInt()
          ? result.toInt().toString()
          : result.toString();

      state = state.copyWith(output: formattedResult);
    } catch (e) {
      // Hanya tampilkan "Error" jika bukan dalam mode hasil (=)
      if (!state.input.trim().endsWith('=')) {
        state = state.copyWith(output: 'Error');
      }
    }
  }
}