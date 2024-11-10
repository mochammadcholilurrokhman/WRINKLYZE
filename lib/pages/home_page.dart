import 'package:flutter/material.dart';
import 'package:wrinklyze_6/pages/wrinklepedia_page.dart';
import 'package:wrinklyze_6/widgets/recent_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wrinklepedia App',
      theme: ThemeData(
        primaryColor: Color(0xFFE9EEF0),
        scaffoldBackgroundColor: Color(0xFFE9EEF0),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final double topCornerRadius = 16.0; // Adjustable top corner radius
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
              'Home', // Teks pada AppBar
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white, // Make AppBar background transparent
            elevation: 0, // No additional elevation
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20), // Memberi jarak di atas setelah AppBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Aligns items on both ends
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi! Walter White',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 5), // Add some space between the texts
                    Text(
                      "Let's see the wrinkles on your face!",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WrinklepediaPage()),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/wrinkpedia.png', // Tambahkan gambar menu
                    width: 65,
                    height: 65,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Wrinklepedia",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24, // Ukuran teks lebih besar
                        ),
                      ),
                      Text(
                        "Decode the Secrets of Early Aging",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                  SizedBox(width: 15),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          // Container for Recent Files
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFE9EEF0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16.0),
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
                          SizedBox(height: 10),
                          RecentFile(
                            imagePath: 'assets/images/person1.png',
                            title: 'WrinklyzeScanner 15-10-2024 06.15',
                            date: '15/10/2024 06:15',
                          ),
                          SizedBox(height: 10),
                          RecentFile(
                            imagePath: 'assets/images/person1.png',
                            title: 'WrinklyzeScanner 15-10-2024 06.15',
                            date: '15/10/2024 06:15',
                          ),
                          SizedBox(height: 10),
                          RecentFile(
                            imagePath: 'assets/images/person1.png',
                            title: 'WrinklyzeScanner 15-10-2024 06.15',
                            date: '15/10/2024 06:15',
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
            ),
          ),
        ],
      ),
    );
  }
}
