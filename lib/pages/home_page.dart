// home_page.dart
import 'package:flutter/material.dart';
import 'package:wrinklyze_6/widgets/recent_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Text(
                'Hi! Walter White',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Spacer(),
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Ayo lihat keriput di wajahmu!',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Recents',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  RecentFile(
                    imagePath: 'assets/images/person1.png',
                    title: 'WrinklyzeScanner 15-10-2024 05.27',
                    date: '15/10/2024 05:27',
                  ),
                  SizedBox(height: 10),
                  RecentFile(
                    imagePath: 'assets/images/person1.png',
                    title: 'WrinklyzeScanner 15-10-2024 06.15',
                    date: '15/10/2024 06:15',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
