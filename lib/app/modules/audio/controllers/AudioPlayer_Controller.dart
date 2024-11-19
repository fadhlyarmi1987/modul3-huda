import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioPlayerController extends GetxController {
  AudioPlayer audioPlayer = AudioPlayer();
  RxBool isPlaying = false.obs;
  RxBool isPaused = false.obs;
  RxDouble currentPosition = 0.0.obs;
  RxDouble totalDuration = 100.0.obs;
  RxString sourceType = ''.obs; // 'URL' atau 'Local'
  RxString selectedFile = ''.obs; // Untuk file lokal
  RxString url = ''.obs; // Untuk URL audio

  // Mendapatkan URL audio statis
  String getAudioUrl() {
    return 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
  }

  // Memeriksa izin penyimpanan
  Future<bool> _checkStoragePermission() async {
    var status = await Permission.storage.status;

    if (!status.isGranted) {
      var result = await Permission.storage.request();
      return result.isGranted;
    }

    return true; // Izin sudah diberikan
  }

  // Memutar audio dari URL
  Future<void> playAudioFromUrl(String url) async {
    String audioUrl = getAudioUrl();  // Mengambil URL audio statis

    sourceType.value = 'URL';
    this.url.value = audioUrl;

    await audioPlayer.play(UrlSource(audioUrl));
    isPlaying.value = true;
    isPaused.value = false;
    _listenToAudioPosition();
  }

  // Memilih file audio dari penyimpanan
  Future<void> pickAudioFile() async {
    // Periksa izin penyimpanan terlebih dahulu
    bool hasPermission = await _checkStoragePermission();

    if (hasPermission) {
      // Jika izin diberikan, pilih file audio
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio, // Hanya menampilkan file audio
      );

      if (result != null) {
        String? filePath = result.files.single.path;
        if (filePath != null) {
          selectedFile.value = filePath;
          sourceType.value = 'Local';
          await playAudioFromFile(filePath);
        }
      } else {
        // Jika pengguna batal memilih file
        Get.snackbar(
          "Info",
          "Pemilihan file dibatalkan",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      // Jika izin tidak diberikan
      Get.snackbar(
        "Izin Ditolak",
        "Aplikasi memerlukan izin untuk mengakses penyimpanan.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Memutar audio dari file lokal
  Future<void> playAudioFromFile(String filePath) async {
    await audioPlayer.play(DeviceFileSource(filePath));
    isPlaying.value = true;
    isPaused.value = false;
    _listenToAudioPosition();
  }

  // Pause audio
  Future<void> pauseAudio() async {
    await audioPlayer.pause();
    isPlaying.value = false;
    isPaused.value = true;
  }

  // Resume audio
  Future<void> resumeAudio() async {
    await audioPlayer.resume();
    isPlaying.value = true;
    isPaused.value = false;
  }

  // Stop audio
  Future<void> stopAudio() async {
    await audioPlayer.stop();
    isPlaying.value = false;
    isPaused.value = false;
    currentPosition.value = 0.0;
  }

  // Dengarkan posisi audio
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
}
