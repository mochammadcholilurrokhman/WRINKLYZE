import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Function onCameraTapped;
  final List<Widget> pages;

  BottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onCameraTapped,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Color(0xFF052135),
        unselectedItemColor: Color(0xFF7995A4),
        onTap: (index) {
          if (index == 1) {
            onCameraTapped();
          } else {
            onItemTapped(index);
          }
        },
      ),
    );
  }
}
