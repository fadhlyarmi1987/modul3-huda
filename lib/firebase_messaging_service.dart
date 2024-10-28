import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // Minta izin untuk notifikasi, pada saat pertama kali aplikasi diinstall dan dibuka akan langsung muncul permission
    await _firebaseMessaging.requestPermission();

    // Ini unntuk menampilkan token yang akan muncul pada console
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Mengatur handler untuk notifikasi saat aplikasi dalam foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mengirim pesan notifikasi pada saat foreground(aplikasi terbuka): ${message.data}');
      // Tampilkan snackbar
      Get.snackbar(
        message.notification?.title ?? 'No title', // Ganti 'New Notification' dengan title
        message.notification?.body ?? 'No body',
        messageText: Text(message.notification?.body ?? 'No body'),
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        isDismissible: true,
      );
    });

    // Mengatur handler untuk notifikasi saat aplikasi dalam background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notif Diklik ${message.data}');
      // Tampilkan snackbar atau navigasi ke halaman tertentu
      Get.snackbar(
        message.notification?.title ?? 'No title', // Ganti 'New Notification' dengan title
        message.notification?.body ?? 'No body',
        messageText: Text(message.notification?.body ?? 'No body'),
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        isDismissible: true,
      );
    });

    // Untuk menangani notifikasi saat aplikasi terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('Notification opened from terminated state: ${initialMessage.data}');
      // Tampilkan snackbar
      Get.snackbar(
        'Notification Opened',
        initialMessage.notification?.title ?? 'No title',
        messageText: Text(initialMessage.notification?.body ?? 'No body'),
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        isDismissible: true,
      );
    }
  }
}
