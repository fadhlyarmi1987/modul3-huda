import 'package:get/get.dart';
import '../controllers/AudioPlayer_Controller.dart';

class AudioplayerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudioPlayerController>(() => AudioPlayerController());
  }
}
