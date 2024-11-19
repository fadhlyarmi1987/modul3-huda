import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool isListening = false;
  String recognizedText = '';

  Future<void> startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      isListening = true;
      _speech.listen(onResult: (result) {
        recognizedText = result.recognizedWords;
      });
    }
  }

  void stopListening() {
    isListening = false;
    _speech.stop();
  }

  Future<bool> checkAvailability() async {
    return await _speech.initialize();
  }
}
