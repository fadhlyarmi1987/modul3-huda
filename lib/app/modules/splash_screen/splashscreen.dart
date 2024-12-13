import 'dart:io'; // Untuk memeriksa koneksi internet
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../routes/app_pages.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String connectionStatus = "Memeriksa koneksi...";
  bool hasInternet = false; // Untuk menyimpan status akses internet

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  void _checkInternetConnection() async {
    final connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();

    // Periksa apakah perangkat terhubung ke jaringan
    if (result != ConnectivityResult.none) {
      hasInternet = await _checkInternetAccess(); // Validasi akses internet
    }

    setState(() {
      if (result == ConnectivityResult.none) {
        connectionStatus = "Tidak ada koneksi internet";
      } else if (!hasInternet) {
        connectionStatus = "Tidak dapat mengakses internet";
      } else if (result == ConnectivityResult.wifi) {
        connectionStatus = "Terhubung ke Wi-Fi";
      } else if (result == ConnectivityResult.mobile) {
        connectionStatus = "Terhubung ke data seluler";
      }
    });

    // Jika ada internet, otomatis masuk ke halaman utama setelah 3 detik
    if (hasInternet) {
      await Future.delayed(Duration(seconds: 3));
      Get.offNamed('/home');
    }
  }

  Future<bool> _checkInternetAccess() async {
    try {
      // Coba akses server Google
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Berhasil mengakses internet
      }
    } catch (_) {
      return false; // Gagal mengakses internet
    }
    return false;
  }

  Future<void> _refreshConnection() async {
    setState(() {
      connectionStatus = "Memeriksa koneksi...";
    });
    _checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: RefreshIndicator(
        onRefresh: _refreshConnection, // Fungsi untuk refresh status koneksi
        child: Center( // Membungkus seluruh layar dengan Center untuk menempatkan logo di tengah
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(), // Agar RefreshIndicator bisa digunakan
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // Menjaga agar kolom tetap di tengah
              children: [
                // Logo atau animasi di SplashScreen
                Icon(
                  Icons.wifi,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                // Menampilkan status koneksi
                Text(
                  connectionStatus,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Tombol "Tetap Lanjutkan Secara Offline" jika tidak ada internet
                if (!hasInternet)
                  ElevatedButton(
                    onPressed: () {
                      Get.offNamed('/home'); // Navigasi ke halaman utama secara offline
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                      backgroundColor: Colors.white, // Warna teks
                    ),
                    child: Text("Tetap Lanjutkan Secara Offline"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
