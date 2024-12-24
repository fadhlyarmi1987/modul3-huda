import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechController extends GetxController {
  late final stt.SpeechToText _speech;
  var _isListening = false.obs;
  var _searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _speech = stt.SpeechToText();
  }

  // Memulai pendengaran suara
  void startListening() async {
    if (!_isListening.value) {
      bool available = await _speech.initialize();
      if (available) {
        await _speech.listen(onResult: (result) {
          _searchQuery.value = result.recognizedWords;
        });
        _isListening.value = true;
      }
    }
  }

  // Menghentikan pendengaran suara
  void stopListening() async {
    await _speech.stop();
    _isListening.value = false;
  }

  bool get isListening => _isListening.value;
  String get searchQuery => _searchQuery.value;
}
