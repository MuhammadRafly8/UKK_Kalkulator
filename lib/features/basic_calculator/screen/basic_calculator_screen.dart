
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/core/widgets/custom_button.dart';
import 'package:project/shared/providers/calculator_provider.dart';
import 'package:project/history/screens/history_screen.dart';
import 'package:project/settings/screens/settings_screen.dart';
import 'package:project/scientific_calculator/screen/scientific_calculator_screen.dart';

class BasicCalculatorScreen extends ConsumerWidget {
  const BasicCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Calculator'),
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
        padding: const EdgeInsets.all(16.0),
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
                      style: const TextStyle(fontSize: 24, color: Colors.grey),
                      overflow: TextOverflow.fade,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.output,
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                    ),
                    // Di dalam Column, setelah Display dan sebelum Keypad
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ScientificCalculatorScreen()),
                              );
                            },
                            child: const Text('Mode Ilmiah →'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Keypad
                        Expanded(
                child: Row(
                  children: [
                    // Tombol Undo
                    Expanded(
                      child: CustomButton(
                        text: 'UNDO',
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () => ref.read(calculatorProvider.notifier).undo(),
                      ),
                    ),
                    // Tombol Clear
                    Expanded(
                      child: CustomButton(
                        text: 'C',
                        color: Colors.red,
                        textColor: Colors.white,
                        onPressed: () => ref.read(calculatorProvider.notifier).clear(),
                      ),
                    ),
                    // Tombol Backspace
                    Expanded(
                      child: CustomButton(
                        text: '⌫',
                        color: Colors.orange,
                        textColor: Colors.white,
                        onPressed: () => ref.read(calculatorProvider.notifier).backspace(),
                      ),
                    ),
                    // Tombol Bagi
                    Expanded(
                      child: CustomButton(
                        text: '÷',
                        color: Colors.orange,
                        textColor: Colors.white,
                        onPressed: () => ref.read(calculatorProvider.notifier).input('÷'),
                      ),
                    ),
                    // Tombol Kali
                    Expanded(
                      child: CustomButton(
                        text: '×',
                        color: Colors.orange,
                        textColor: Colors.white,
                        onPressed: () => ref.read(calculatorProvider.notifier).input('×'),
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
                            child: GestureDetector(
                              onTap: () => ref.read(calculatorProvider.notifier).input('='),
                              child: Container(
                                color: Colors.blue,
                                child: const Center(
                                  child: Text(
                                    '=',
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
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