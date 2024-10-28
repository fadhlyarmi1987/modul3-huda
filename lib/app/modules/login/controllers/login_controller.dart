import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  // Instance FirebaseAuth dan FirebaseFirestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controller untuk input email dan password dari user
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Fungsi untuk melakukan login
  Future<void> login() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      // Login dengan email dan password di Firebase Authentication
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Ambil data pengguna dari Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(email).get();

      // Cek apakah dokumen pengguna ada
      if (userDoc.exists) {
        String username = userDoc['name']; // Ambil nama dari dokumen
        final name = userDoc['name'];
        GetStorage().write('username', name);
        Get.snackbar(
          "Success",
          "Login berhasil! Selamat datang, $username",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(213, 76, 175, 79),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Pengguna tidak ditemukan di koleksi users.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return; // Hentikan proses jika pengguna tidak ditemukan
      }

      // Jika berhasil, arahkan ke halaman HOME
      Get.offNamed(Routes.HOME);
    } on FirebaseAuthException catch (e) {
      // Menangani error Firebase
      String message = "Terjadi kesalahan saat login.";
      if (e.code == 'user-not-found') {
        message = 'Pengguna tidak ditemukan. Periksa kembali email Anda.';
      } else if (e.code == 'wrong-password') {
        message = 'Password salah. Coba lagi.';
      }

      // Tampilkan pesan error menggunakan snackbar
      Get.snackbar(
        "Error",
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    @override
    void onClose() {
      // Hapus controller saat tidak digunakan
      emailController.dispose();
      passwordController.dispose();
      super.onClose();
    }
  }
}
