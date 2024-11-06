import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:wrinklyze_6/pages/home_page.dart';
import 'package:wrinklyze_6/pages/account_page.dart';
import 'package:wrinklyze_6/pages/camera_page.dart';
import 'package:wrinklyze_6/pages/login.dart';
import 'package:wrinklyze_6/pages/onboarding.dart';
import 'package:wrinklyze_6/pages/register_page.dart';
import 'package:wrinklyze_6/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
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
      // home: SignUpPage(),
      // home: LoginPage(),
      // home: OnboardingScreen(),
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

  final List<IconData> iconList = [
    Icons.home_filled,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bottomNavIndex == 1 ? AccountPage() : HomePage(),
      floatingActionButton: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () async {
            final imagePath = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CameraPage()),
            );
            if (imagePath != null) {
              print('Image captured at path: $imagePath');
            }
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF7995A4),
            ),
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 0,
        rightCornerRadius: 0,
        iconSize: 30,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
        activeColor: Color(0xFF052135),
        inactiveColor: Color(0xFF7995A4),
      ),
    );
  }
}
