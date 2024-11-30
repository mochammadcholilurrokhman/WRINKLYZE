import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wrinklyze_6/pages/about_page.dart';
import 'package:wrinklyze_6/pages/change_password_page.dart';
import 'package:wrinklyze_6/pages/change_profile_page.dart';
import 'package:wrinklyze_6/pages/login_page.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userEmail = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    _getCurrentUserEmail();
    _getCurrentUserName();
  }

  Future<void> _getCurrentUserEmail() async {
    User? user = _auth.currentUser;
    if (mounted) {
      setState(() {
        userEmail = user?.email ?? 'Not logged in';
      });
    }
  }

  Future<void> _getCurrentUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (mounted) {
        setState(() {
          userName = doc['username'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.blueGrey,
              padding: EdgeInsets.only(bottom: 50.0, left: 30.0, right: 30.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 60,
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          userEmail,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      'Profile',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage()),
                      ).then((updatedUsername) {
                        if (updatedUsername != null &&
                            updatedUsername is String) {
                          setState(() {
                            userName = updatedUsername;
                          });
                        }
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text(
                      'Change Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text(
                      'About the App',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Log Out
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.blueGrey[50],
                        title: Text(
                          'Confirm Logout',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                        content: Text(
                          'Are you sure to log out?                 ',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.blueGrey[600],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.blueGrey[600],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _auth.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                            child: Text(
                              'Log Out',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 20),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
