import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Cek apakah pengguna sudah login
    final user = FirebaseAuth.instance.currentUser;

    // Jika pengguna belum login, arahkan ke halaman login
    if (user == null) {
      return const RouteSettings(name: '/login'); // Ganti dengan route login Anda
    }
    return null; // Jika pengguna sudah login, izinkan akses ke route yang diminta
  }
}
