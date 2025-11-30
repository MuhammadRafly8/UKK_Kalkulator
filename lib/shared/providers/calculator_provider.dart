// lib/shared/providers/calculator_provider.dart
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
    if (_history.isEmpty ||
        _history.last.input != state.input ||
        _history.last.output != state.output) {
      if (_history.length >= _maxHistory) {
        _history.removeAt(0);
      }
      _history.add(CalculatorState(input: state.input, output: state.output));
    }
  }

  void undo() {
    if (_history.isEmpty) return;
    final previousState = _history.removeLast();
    state = previousState;
  }

  // 🔥 Helper: Tutup kurung yang belum tertutup
  String _autoCloseParentheses(String input) {
    int openCount = 0;
    for (int i = 0; i < input.length; i++) {
      if (input[i] == '(') openCount++;
      else if (input[i] == ')') openCount--;
    }
    while (openCount > 0) {
      input += ')';
      openCount--;
    }
    return input;
  }

  void input(String value) {
    if (state.input.endsWith('=')) {
      if (value == '=') return;
      state = CalculatorState();
    }

    if (value == '=') {
      calculate();
      return;
    }

    if (state.input.isEmpty && '+×÷'.contains(value)) return;

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

    _saveToHistory();

    // 🔥 Bersihkan dan tutup kurung
    String cleanInput = state.input.trim();
    if (cleanInput.endsWith('=')) {
      cleanInput = cleanInput.substring(0, cleanInput.length - 1).trim();
    }
    cleanInput = _autoCloseParentheses(cleanInput);

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

      if (formattedResult != 'Error') {
        HistoryService().saveEntry(state.input, formattedResult);
      }

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

    String cleanInput = state.input.trim();
    if (cleanInput.endsWith('=')) {
      cleanInput = cleanInput.substring(0, cleanInput.length - 1).trim();
    }

    if (cleanInput.isEmpty) {
      state = state.copyWith(output: '0');
      return;
    }

    // 🔥 Tutup kurung otomatis saat evaluasi sementara
    cleanInput = _autoCloseParentheses(cleanInput);

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
      if (!state.input.trim().endsWith('=')) {
        state = state.copyWith(output: 'Error');
      }
    }
  }
}