import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  // Instance FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controller untuk input nama, email, dan password dari user
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Fungsi untuk melakukan registrasi
  Future<void> register() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final name = nameController.text.trim();

      // Buat akun baru di Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ambil UID pengguna baru
      final uid = userCredential.user?.uid;

      // Simpan nama pengguna ke Firestore
      await _firestore.collection('users').doc(email).set({
        'uid': uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Tampilkan pesan sukses dan arahkan ke halaman berikutnya
      Get.snackbar(
        "Success",
        "Akun berhasil dibuat!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offNamed(Routes.LOGIN);
    } on FirebaseAuthException catch (e) {
      // Menangani error Firebase Authentication
      String message = "Terjadi kesalahan saat mendaftar.";
      if (e.code == 'email-already-in-use') {
        message = 'Email sudah digunakan. Coba email lain.';
      }

      // Tampilkan pesan error
      Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    // Hapus controller saat tidak digunakan
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
