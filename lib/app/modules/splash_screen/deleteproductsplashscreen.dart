import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Deleteproductsplashscreen extends StatelessWidget {
  final String productName;
  Deleteproductsplashscreen({required this.productName});

  @override
  Widget build(BuildContext context) {
    final randomDuration = [1500, 1500, 1600, 1600, 1600, 1700][Random().nextInt(6)];
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
              'assets/animasi/delete.json', 
              width: 150, 
              height: 150, 
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            
            Text(
              'Menghapus....',
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
