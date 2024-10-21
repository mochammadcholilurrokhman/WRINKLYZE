// File: pages/main_page.dart
import 'package:flutter/material.dart';
import 'package:wrinklyze_6/pages/account_page.dart';
import 'package:wrinklyze_6/pages/files_page.dart';
import 'package:wrinklyze_6/pages/home_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0; // Index untuk halaman yang aktif

  final List<Widget> _pages = [
    HomePage(), // Halaman Home
    FilesPage(), // Halaman Files (dengan tombol kamera)
    AccountPage(), // Halaman Account
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Memilih halaman berdasarkan index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // Ubah halaman ketika di-tap
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
