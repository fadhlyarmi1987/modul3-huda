import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationController extends GetxController {
  // Contoh list notifikasi
  var notifications = <String>[].obs;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    setupFCMListeners();
  }

  // Fungsi untuk mengambil notifikasi (dummy data dihapus)
  void fetchNotifications() {
    // Anda bisa mengisi dengan notifikasi sebelumnya jika ada
    // Misalnya, ambil dari database atau penyimpanan lokal
  }

  // Mengatur listener untuk notifikasi FCM
  void setupFCMListeners() {
    // Mendapatkan token FCM
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
    });

    // Listener saat aplikasi dalam foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a new message: ${message.data}');
      
      // Jika ada notifikasi, tambahkan ke list
      if (message.notification != null) {
        String notificationMessage = 
            "${message.notification?.title}: ${message.notification?.body}";
        notifications.add(notificationMessage);
      }
    });

    // Listener saat notifikasi diklik
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: ${message.data}');
      // Tambahkan logika jika perlu saat notifikasi diklik
    });

    // Menangani notifikasi saat aplikasi dalam keadaan terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('Notification opened from terminated state: ${message.data}');
        if (message.notification != null) {
          String notificationMessage = 
              "${message.notification?.title}: ${message.notification?.body}";
          notifications.add(notificationMessage);
        }
      }
    });
  }

  // Fungsi untuk menghapus notifikasi
  void clearNotifications() {
    notifications.clear();
  }
}
