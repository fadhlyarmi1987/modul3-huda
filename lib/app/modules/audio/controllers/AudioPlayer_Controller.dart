import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class AudioPlayerController extends GetxController {
  AudioPlayer audioPlayer = AudioPlayer();
  RxBool isPlaying = false.obs;
  RxDouble currentPosition = 0.0.obs; 
  RxDouble totalDuration = 0.0.obs;
  RxBool isPaused = false.obs;
  RxString currentFile = ''.obs;

  // Memulai pemutaran audio dari URL
  Future<void> playAudioFromUrl(String url) async {
    currentFile.value = url;
    await audioPlayer.play(UrlSource(url));
    isPlaying.value = true;
    isPaused.value = false;
    _listenToAudioPosition();
  }

  // Pause pemutaran audio
  Future<void> pauseAudio() async {
    await audioPlayer.pause();
    isPlaying.value = false;
    isPaused.value = true;
  }

  // Resume pemutaran audio
  Future<void> resumeAudio() async {
    await audioPlayer.resume();
    isPlaying.value = true;
    isPaused.value = false;
  }

  // Menghentikan pemutaran audio
  Future<void> stopAudio() async {
    await audioPlayer.stop();
    isPlaying.value = false;
    isPaused.value = false;
    currentPosition.value = 0.0;
  }

  // Seek ke posisi tertentu
  Future<void> seekAudio(Duration position) async {
    await audioPlayer.seek(position);
    currentPosition.value = position.inSeconds.toDouble();
  }

  // Fungsi untuk mendengarkan posisi audio
  void _listenToAudioPosition() {
    audioPlayer.onDurationChanged.listen((Duration d) {
      totalDuration.value = d.inSeconds.toDouble();
    });

    audioPlayer.onPositionChanged.listen((Duration p) {
      currentPosition.value = p.inSeconds.toDouble();
    });

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        isPlaying.value = false;
        currentPosition.value = 0.0;
      }
    });
  }

  String getAudioUrl() {
    return 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
  }
}
