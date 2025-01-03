import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SaveProductSplashScreen extends StatelessWidget {
  final String productName;
  SaveProductSplashScreen({required this.productName});

  @override
  Widget build(BuildContext context) {
    final randomDuration = [800, 800, 800, 900, 900, 1000, 1000, 1100, 1200, 1500][Random().nextInt(10)];
    Future.delayed(Duration(milliseconds: randomDuration), () {
      Navigator.pop(context); 
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Lottie.asset(
              'assets/animasi/upload.json', 
              width: 250, 
              height: 250, 
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            
            Text(
              'Sedang Mengupload...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Warna teks
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
