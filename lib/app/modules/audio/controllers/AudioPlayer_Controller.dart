import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../local_notifications.dart';

class AudioPlayerController extends GetxController {
  AudioPlayer audioPlayer = AudioPlayer(); // Instance AudioPlayer
  RxBool isPlaying = false.obs; // Status audio sedang diputar
  RxBool isPaused = false.obs; // Status audio sedang dijeda
  RxDouble currentPosition = 0.0.obs; // Posisi saat ini dalam detik
  RxDouble totalDuration = 100.0.obs; // Durasi total audio dalam detik
  RxString sourceType = ''.obs; // Sumber audio ('URL' atau 'Local')
  RxString selectedFile = ''.obs; // Path file lokal
  RxString url = ''.obs; // URL audio

  // Inisialisasi audio player dan notifikasi
  @override
  void onInit() {
    super.onInit();
    LocalNotifications.init(); // Inisialisasi notifikasi
  }

  // Mengembalikan URL audio default untuk diputar
  String getAudioUrl() {
    return 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
  }

  // Memeriksa dan meminta izin penyimpanan
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
    String audioUrl = url.isNotEmpty ? url : getAudioUrl();

    sourceType.value = 'URL';
    this.url.value = audioUrl;

    await audioPlayer.play(UrlSource(audioUrl)); // Memutar audio
    isPlaying.value = true;
    isPaused.value = false;
    _listenToAudioPosition(); // Dengarkan perubahan posisi
    _updateNotification(); // Update notifikasi
  }

  // Memilih file audio dari penyimpanan lokal
  Future<void> pickAudioFile() async {
    bool hasPermission = await _checkStoragePermission(); // Periksa izin

    if (hasPermission) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio, // Hanya file audio
      );

      if (result != null) {
        String? filePath = result.files.single.path;
        if (filePath != null) {
          selectedFile.value = filePath;
          sourceType.value = 'Local';
          await playAudioFromFile(filePath);
        }
      } else {
        // Jika pengguna membatalkan pemilihan file
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
    await audioPlayer.play(DeviceFileSource(filePath)); // Memutar file lokal
    isPlaying.value = true;
    isPaused.value = false;
    _listenToAudioPosition(); // Dengarkan perubahan posisi
    _updateNotification(); // Update notifikasi
  }

  // Menjeda audio
  Future<void> pauseAudio() async {
    await audioPlayer.pause();
    isPlaying.value = false;
    isPaused.value = true;
    _updateNotification(); // Update notifikasi
  }

  // Melanjutkan audio
  Future<void> resumeAudio() async {
    await audioPlayer.resume();
    isPlaying.value = true;
    isPaused.value = false;
    _updateNotification(); // Update notifikasi
  }

  // Menghentikan audio
  Future<void> stopAudio() async {
    await audioPlayer.stop();
    isPlaying.value = false;
    isPaused.value = false;
    currentPosition.value = 0.0;
    _updateNotification(); // Update notifikasi
  }

  // Mendengarkan perubahan posisi audio
  void _listenToAudioPosition() {
    audioPlayer.onDurationChanged.listen((Duration duration) {
      totalDuration.value = duration.inSeconds.toDouble(); // Set total durasi
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
      currentPosition.value = position.inSeconds.toDouble(); // Update posisi
    });

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        isPlaying.value = false;
        currentPosition.value = 0.0; // Reset posisi saat audio selesai
        _updateNotification(); // Update notifikasi
      }
    });
  }

  // Memperbarui notifikasi audio
  void _updateNotification() {
    if (isPlaying.value) {
      LocalNotifications.updateNotification(
        'Audio Playing',
        'Click to Pause or Stop',
        this,
      );
    } else if (isPaused.value) {
      LocalNotifications.updateNotification(
        'Audio Paused',
        'Click to Resume or Stop',
        this,
      );
    } else {
      LocalNotifications.updateNotification(
        'Audio Stopped',
        'Click to Play Again',
        this,
      );
    }
  }

  // Menangani aksi dari notifikasi (play/pause/stop)
  void handleNotificationAction(String action) {
    if (action == 'play_pause') {
      if (isPlaying.value) {
        pauseAudio();
      } else {
        resumeAudio();
      }
    } else if (action == 'stop') {
      stopAudio();
    }
  }
}
