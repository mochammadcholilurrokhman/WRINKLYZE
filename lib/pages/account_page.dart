import 'package:flutter/material.dart';
import 'package:wrinklyze_6/pages/register_page.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Pusatkan kolom secara vertikal
          children: [
            Text("Account screen."),
            SizedBox(height: 20), // Tambah jarak antara teks dan tombol
            ElevatedButton(
              onPressed: () {
                // Navigasi ke RegisterPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Go to Register Page'),
            ),
          ],
        ),
      ),
    );
  }
}
