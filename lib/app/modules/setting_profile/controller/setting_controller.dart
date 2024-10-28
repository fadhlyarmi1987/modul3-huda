import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingController extends GetxController {
  var username = ''.obs; // Inisialisasi dengan string kosong
  var notificationsEnabled = false.obs; // Status notifikasi

  @override
  void onInit() {
    super.onInit();
    // Ambil username dari GetStorage saat controller diinisialisasi
    final storedUsername = GetStorage().read('username');
    if (storedUsername != null) {
      username.value = storedUsername; // Set username jika ada
    }
  }

  // Fungsi untuk mengubah status notifikasi
  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Logout dari Firebase
      Get.offAllNamed('/login'); // Arahkan ke halaman login
    } catch (e) {
      Get.snackbar("Error", "Logout gagal: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
