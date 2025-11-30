
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/core/utils/voice_input_service.dart';
import 'package:project/shared/providers/calculator_provider.dart';

class VoiceState {
  final bool isListening;
  final bool isAvailable;

  VoiceState({this.isListening = false, this.isAvailable = false});
}

final voiceProvider = StateNotifierProvider<VoiceNotifier, VoiceState>((ref) {
  return VoiceNotifier(VoiceInputService());
});

class VoiceNotifier extends StateNotifier<VoiceState> {
  final VoiceInputService _service;

  VoiceNotifier(this._service) : super(VoiceState()) {
    _init();
  }

  Future<void> _init() async {
    final available = await _service.initialize();
    state = VoiceState(isAvailable: available, isListening: false);
  }

  void toggleListening(WidgetRef ref) async {
    if (!state.isAvailable) return;

    if (state.isListening) {
      _service.stop();
      state = VoiceState(isAvailable: true, isListening: false);
    } else {
      state = VoiceState(isAvailable: true, isListening: true);
      _service.listen((text) {
        // Konversi teks ucapan ke ekspresi
        final expression = _service.convertSpokenText(text);
        if (expression.isNotEmpty) {
          // Input ke kalkulator
          ref.read(calculatorProvider.notifier).input(expression);
          // Jika berakhir dengan '=', hentikan
          if (expression.endsWith('=')) {
            _service.stop();
            state = VoiceState(isAvailable: true, isListening: false);
          }
        }
      });
    }
  }
}