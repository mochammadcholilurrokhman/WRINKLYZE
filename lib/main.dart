import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wrinklyze_6/pages/account_page.dart';
import 'package:wrinklyze_6/pages/bottom_navbar.dart';
import 'package:wrinklyze_6/pages/camera_page.dart';
import 'package:wrinklyze_6/pages/home_page.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrinklyze_6/pages/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wrinklyze',
      theme: ThemeData(
        primaryColor: Color(0xFFE9EEF0),
        scaffoldBackgroundColor: Color(0xFFE9EEF0),
      ),
      home: SplashScreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _bottomNavIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    CameraPage(),
    AccountPage(),
  ];

  void _onCameraTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavBar(
      selectedIndex: _bottomNavIndex,
      onItemTapped: (index) {
        setState(() {
          _bottomNavIndex = index;
        });
      },
      onCameraTapped: _onCameraTapped,
      pages: _pages,
    );
  }
}
