// File: pages/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:wrinklyze_6/main.dart';
import 'dart:async';
import 'package:wrinklyze_6/pages/main_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainPage()), // Pindah ke MainPage
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9EEF0),
      body: Center(
        child: Image.asset(
          'assets/images/logo_splash.png', // Gambar logo untuk splash screen
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}
