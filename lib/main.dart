// File: main.dart
import 'package:flutter/material.dart';
import 'package:wrinklyze_6/pages/splash_screen.dart'; // Import SplashScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wrinklyze',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Tampilkan SplashScreen saat pertama kali
    );
  }
}
