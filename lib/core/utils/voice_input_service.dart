
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceInputService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool get isAvailable => _speech.isAvailable;
  bool get isListening => _speech.isListening;

  Future<bool> initialize() async {
    return await _speech.initialize(
      onError: (error) {},
      onStatus: (status) {},
    );
  }

  void listen(void Function(String text) onResult) {
    _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
      listenFor: const Duration(seconds: 5),
      pauseFor: const Duration(seconds: 2),
      localeId: 'id-ID', // Bahasa Indonesia
    );
  }

  void stop() {
    _speech.stop();
  }

  // Konversi teks ucapan ke ekspresi kalkulator
  String convertSpokenText(String spokenText) {
    String result = spokenText.toLowerCase();

    // Angka
    result = result.replaceAll('nol', '0');
    result = result.replaceAll('satu', '1');
    result = result.replaceAll('dua', '2');
    result = result.replaceAll('tiga', '3');
    result = result.replaceAll('empat', '4');
    result = result.replaceAll('lima', '5');
    result = result.replaceAll('enam', '6');
    result = result.replaceAll('tujuh', '7');
    result = result.replaceAll('delapan', '8');
    result = result.replaceAll('sembilan', '9');
    result = result.replaceAll('sepuluh', '10');
    result = result.replaceAll('sebelas', '11');
    result = result.replaceAll('dua belas', '12');
    result = result.replaceAll('tiga belas', '13');
    result = result.replaceAll('empat belas', '14');
    result = result.replaceAll('lima belas', '15');
    result = result.replaceAll('enam belas', '16');
    result = result.replaceAll('tujuh belas', '17');
    result = result.replaceAll('delapan belas', '18');
    result = result.replaceAll('sembilan belas', '19');
    result = result.replaceAll('dua puluh', '20');
    result = result.replaceAll('tiga puluh', '30');
    result = result.replaceAll('empat puluh', '40');
    result = result.replaceAll('lima puluh', '50');
    result = result.replaceAll('enam puluh', '60');
    result = result.replaceAll('tujuh puluh', '70');
    result = result.replaceAll('delapan puluh', '80');
    result = result.replaceAll('sembilan puluh', '90');
    result = result.replaceAll('seratus', '100');

    // Operator
    result = result.replaceAll('tambah', '+');
    result = result.replaceAll('kurang', '−');
    result = result.replaceAll('kali', '×');
    result = result.replaceAll('dibagi', '÷');
    result = result.replaceAll('per', '÷');
    result = result.replaceAll('pangkat', '^');
    result = result.replaceAll('akar', '√(');
    result = result.replaceAll('sama dengan', '=');

    // Bersihkan kata tidak perlu
    result = result.replaceAll('kalkulator', '');
    result = result.replaceAll('hitung', '');
    result = result.replaceAll('berapa', '');
    result = result.replaceAll('?', '');
    result = result.replaceAll('.', '');
    result = result.replaceAll(',', '');

    // Hapus spasi berlebih
    result = result.trim().replaceAll(RegExp(r'\s+'), ' ');

    return result;
  }
}