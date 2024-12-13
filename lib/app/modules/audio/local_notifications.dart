import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';

import 'controllers/AudioPlayer_Controller.dart';

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Inisialisasi notifikasi
  static Future<void> init() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Tangani aksi ketika notifikasi dipilih
        if (response.payload != null) {
          handleNotificationAction(response.payload!);
        }
      },
    );
  }

  // Update notifikasi dengan tombol play, pause, stop
  static Future<void> updateNotification(
      String title, String body, AudioPlayerController controller) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'audio_channel', // ID Channel
      'Audio Notifications', // Nama Channel
      channelDescription: 'Channel for audio notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: false,
      actions: [
        AndroidNotificationAction(
          'play_pause', // Action ID for play/pause
          'Play/Pause',
        ),
        AndroidNotificationAction(
          'stop', // Action ID for stop
          'Stop',
        ),
      ],
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // ID notifikasi
      title,
      body,
      platformChannelSpecifics,
      payload: 'audio_playback', // Payload untuk interaksi
    );

    // Update state berdasarkan status audio
    controller.audioPlayer;
  }

  // Menangani aksi dari notifikasi
  static void handleNotificationAction(String action) {
    if (action == 'play_pause') {
      // Play/Pause audio, bisa menggunakan callback untuk handle play/pause
      AudioPlayerController().handleNotificationAction('play_pause');
    } else if (action == 'stop') {
      // Stop audio
      AudioPlayerController().handleNotificationAction('stop');
    }
  }
}
