import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreenToPage extends StatelessWidget {
  final Widget targetPage;

  SplashScreenToPage({required this.targetPage});

  @override
  Widget build(BuildContext context) {
    final randomDuration = [900, 1000, 1100, 1200, 1500][Random().nextInt(5)];
    Future.delayed(Duration(milliseconds: randomDuration), () {
      Get.off(() => targetPage);
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallpapperlogo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animasi/Splash3.json',
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
