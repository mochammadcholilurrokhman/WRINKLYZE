import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(Icons.home_filled, size: 30, color: Colors.white),
          Icon(Icons.camera_alt, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        color: Color(0xFF052135),
        buttonBackgroundColor: Color(0xFF052135),
        backgroundColor: Color(0xFFe9f0ef),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        index: selectedIndex,
        onTap: (index) {
          if (index == 1) {
            onCameraTapped();
          } else {
            onItemTapped(index);
          }
        },
        height: 60,
      ),
    );
  }
}
