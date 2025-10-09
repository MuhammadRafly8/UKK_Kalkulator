
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/core/widgets/custom_button.dart';
import 'package:project/shared/providers/calculator_provider.dart';
import 'package:project/history/screens/history_screen.dart';
import 'package:project/settings/screens/settings_screen.dart';

class ScientificCalculatorScreen extends ConsumerWidget {
  const ScientificCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Ilmiah'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Display
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      state.input,
                      style: const TextStyle(fontSize: 20, color: Colors.grey),
                      overflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.output,
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Scientific Keypad (Baris Fungsi) - DIPERBAIKI
            Expanded(
              flex: 1,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _scientificButtons.length,
                itemBuilder: (context, index) {
                  final button = _scientificButtons[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CustomButton(
                      text: button.label,
                      color: Colors.blueGrey,
                      textColor: Colors.white,
                      onPressed: () {
                        String value;
                        switch (button.label) {
                          case '√':
                            value = '√(';
                            break;
                          case 'x²':
                            value = '^2';
                            break;
                          case 'xʸ':
                            value = '^';
                            break;
                          case 'π':
                            value = 'π';
                            break;
                          case 'e':
                            value = 'e';
                            break;
                          case '!':
                            value = '!';
                            break;
                          default:
                            value = '${button.label}(';
                        }
                        ref.read(calculatorProvider.notifier).input(value);
                      },
                    ),
                  );
                },
              ),
            ),

            // Basic Keypad
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: CustomButton(text: 'C', color: Colors.red, textColor: Colors.white, onPressed: () => ref.read(calculatorProvider.notifier).clear())),
                        Expanded(child: CustomButton(text: '⌫', color: Colors.orange, textColor: Colors.white, onPressed: () => ref.read(calculatorProvider.notifier).backspace())),
                        Expanded(child: CustomButton(text: '÷', color: Colors.orange, textColor: Colors.white, onPressed: () => ref.read(calculatorProvider.notifier).input('÷'))),
                        Expanded(child: CustomButton(text: '×', color: Colors.orange, textColor: Colors.white, onPressed: () => ref.read(calculatorProvider.notifier).input('×'))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: CustomButton(text: '7', onPressed: () => ref.read(calculatorProvider.notifier).input('7'))),
                        Expanded(child: CustomButton(text: '8', onPressed: () => ref.read(calculatorProvider.notifier).input('8'))),
                        Expanded(child: CustomButton(text: '9', onPressed: () => ref.read(calculatorProvider.notifier).input('9'))),
                        Expanded(child: CustomButton(text: '−', color: Colors.orange, textColor: Colors.white, onPressed: () => ref.read(calculatorProvider.notifier).input('−'))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: CustomButton(text: '4', onPressed: () => ref.read(calculatorProvider.notifier).input('4'))),
                        Expanded(child: CustomButton(text: '5', onPressed: () => ref.read(calculatorProvider.notifier).input('5'))),
                        Expanded(child: CustomButton(text: '6', onPressed: () => ref.read(calculatorProvider.notifier).input('6'))),
                        Expanded(child: CustomButton(text: '+', color: Colors.orange, textColor: Colors.white, onPressed: () => ref.read(calculatorProvider.notifier).input('+'))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: CustomButton(text: '1', onPressed: () => ref.read(calculatorProvider.notifier).input('1'))),
                        Expanded(child: CustomButton(text: '2', onPressed: () => ref.read(calculatorProvider.notifier).input('2'))),
                        Expanded(child: CustomButton(text: '3', onPressed: () => ref.read(calculatorProvider.notifier).input('3'))),
                        Expanded(
                          child: CustomButton(
                            text: '=',
                            color: Colors.blue,
                            textColor: Colors.white,
                            onPressed: () => ref.read(calculatorProvider.notifier).input('='),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomButton(text: '0', onPressed: () => ref.read(calculatorProvider.notifier).input('0')),
                        ),
                        Expanded(child: CustomButton(text: '.', onPressed: () => ref.read(calculatorProvider.notifier).input('.'))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<_SciButton> _scientificButtons = [
  _SciButton('sin'),
  _SciButton('cos'),
  _SciButton('tan'),
  _SciButton('√'),
  _SciButton('x²'),
  _SciButton('xʸ'),
  _SciButton('π'),
  _SciButton('e'),
  _SciButton('log'),
  _SciButton('ln'),
  _SciButton('!'),
  _SciButton('('),
  _SciButton(')'),
];

class _SciButton {
  final String label;
  const _SciButton(this.label);
}