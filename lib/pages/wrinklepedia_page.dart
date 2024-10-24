import 'package:flutter/material.dart';

class WrinklepediaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // Set the preferred height
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Background color of AppBar
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Shadow color
                blurRadius: 4.0, // Blur radius
                offset: Offset(0, 2), // Offset for the shadow
              ),
            ],
          ),
          child: AppBar(
            title: Text(
                'Wrinklepedia'), // Tambahkan AppBar untuk halaman Wrinklepedia
            backgroundColor: Colors.white, // Make AppBar background transparent
            elevation: 0, // No additional elevation
          ),
        ),
      ),
      body: Center(
        child: Text(
          "Welcome to Wrinklepedia!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
