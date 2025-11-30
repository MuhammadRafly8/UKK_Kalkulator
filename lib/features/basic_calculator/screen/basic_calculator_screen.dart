import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/core/widgets/custom_button.dart';
import 'package:project/shared/providers/calculator_provider.dart';
import 'package:project/history/screens/history_screen.dart';
import 'package:project/settings/screens/settings_screen.dart';
import 'package:project/scientific_calculator/screen/scientific_calculator_screen.dart';
import 'package:project/conversion/models/conversion_type.dart';
import 'package:project/conversion/screens/conversion_screen.dart';
import 'package:project/shared/providers/voice_provider.dart';

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
          // 🔊 Ikon Voice Input
          Consumer(
            builder: (context, ref, child) {
              final isListening = ref.watch(voiceProvider).isListening;
              return IconButton(
                icon: Icon(isListening ? Icons.mic : Icons.mic_none),
                color: isListening ? Colors.red : null,
                onPressed: () {
                  ref.read(voiceProvider.notifier).toggleListening(ref);
                },
              );
            },
          ),
          // 📜 Riwayat
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          // ⚙️ Pengaturan
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
            // 🔥 Display - FIXED: Ukuran disesuaikan agar tidak overflow
            Expanded(
              flex: 2,
              child: GestureDetector(
                onLongPress: () {
                  if (state.output != '0' && state.output != 'Error') {
                    _showConversionMenu(context, state.output);
                  }
                },
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(12), // 👈 dari 20 → 12
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        state.input,
                        style: const TextStyle(fontSize: 18, color: Colors.grey), // 👈 dari 24 → 18
                        overflow: TextOverflow.fade,
                      ),
                      const SizedBox(height: 8), // 👈 dari 10 → 8
                      Text(
                        state.output,
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold), // 👈 dari 48 → 36
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Tombol Mode Ilmiah
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScientificCalculatorScreen(),
                      ),
                    );
                  },
                  child: const Text('Mode Ilmiah →'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 🔥 Keypad - Tetap sama, hanya pastikan struktur benar
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  // Baris 1: UNDO, C, ⌫, ÷, ×
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'UNDO',
                            color: Colors.blue,
                            textColor: Colors.white,
                            onPressed: () => ref.read(calculatorProvider.notifier).undo(),
                          ),
                        ),
                        Expanded(
                          child: CustomButton(
                            text: 'C',
                            color: Colors.red,
                            textColor: Colors.white,
                            onPressed: () => ref.read(calculatorProvider.notifier).clear(),
                          ),
                        ),
                        Expanded(
                          child: CustomButton(
                            text: '⌫',
                            color: Colors.orange,
                            textColor: Colors.white,
                            onPressed: () => ref.read(calculatorProvider.notifier).backspace(),
                          ),
                        ),
                        Expanded(
                          child: CustomButton(
                            text: '÷',
                            color: Colors.orange,
                            textColor: Colors.white,
                            onPressed: () => ref.read(calculatorProvider.notifier).input('÷'),
                          ),
                        ),
                        Expanded(
                          child: CustomButton(
                            text: '×',
                            color: Colors.orange,
                            textColor: Colors.white,
                            onPressed: () => ref.read(calculatorProvider.notifier).input('×'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Baris 2: 7, 8, 9, −
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

                  // Baris 3: 4, 5, 6, +
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

                  // Baris 4: 1, 2, 3, =
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

                  // Baris 5: 0 (lebar 2), .
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

  void _showConversionMenu(BuildContext context, String value) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih jenis konversi:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...ConversionType.values.map((type) {
                return ListTile(
                  title: Text(type.label),
                  leading: const Icon(Icons.swap_horiz),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversionScreen(
                          type: type,
                          initialValue: value,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}