import 'dart:async';
import 'package:flutter/material.dart';

class SaveProductSplashScreen extends StatelessWidget {
  final String productName;

  // Constructor untuk menerima nama produk
  SaveProductSplashScreen({required this.productName});

  @override
  Widget build(BuildContext context) {
    // Timer untuk menunggu selama beberapa detik sebelum mengalihkan ke halaman sebelumnya
    Timer(Duration(seconds: 2), () {
      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah 2 detik
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallpapperlogo.png'),  // Ganti dengan path gambar Anda
            fit: BoxFit.cover,  // Mengatur gambar agar menutupi seluruh layar
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              CircularProgressIndicator(color: const Color.fromARGB(255, 0, 0, 0)), // Indikator loading
              SizedBox(height: 20),
              Text(
                'Menyimpan...',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 16, 16, 16), // Warna teks putih agar kontras dengan gambar latar belakang
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
