import 'package:get/get.dart';
import '../controller/SpeechToTextController.dart';

class SpeechToTexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpeechToTextController>(() => SpeechToTextController());
  }
}
