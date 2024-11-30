import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wrinklyze_6/main.dart';
import 'package:wrinklyze_6/pages/welcome_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnAuth();
  }

  Future<void> _navigateBasedOnAuth() async {
    try {
      // Simulasi waktu splash screen
      await Future.delayed(Duration(seconds: 3));

      // Cek status pengguna dengan FirebaseAuth
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Jika pengguna sudah login, navigasi ke MainPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        // Jika belum login, navigasi ke WelcomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
      }
    } catch (e) {
      // Tangani error jika ada
      print('Error saat cek autentikasi: $e');
      // Navigasikan ke halaman welcome jika ada error
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9EEF0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash_logo.png',
              width: 250,
              height: 250,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // Tambahkan loading indicator
          ],
        ),
      ),
    );
  }
}
