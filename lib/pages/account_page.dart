import 'package:flutter/material.dart';
import 'package:wrinklyze_6/pages/about_page.dart';
import 'package:wrinklyze_6/pages/change_password_page.dart';
import 'package:wrinklyze_6/pages/change_profile_page.dart';
import 'package:wrinklyze_6/pages/login.dart';

class AccountPage extends StatelessWidget {
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
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  SizedBox(width: 30), // distance between image and text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'User',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'walterwhite69@gmail.com',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Notification and Dark Mode
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 16.0),
            //   padding: EdgeInsets.all(16.0),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(1.0),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey.withOpacity(0.3),
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     children: [
            //       ListTile(
            //         leading: Icon(Icons.notifications),
            //         title: Text(
            //           'Notification',
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         trailing: Switch(
            //           value: true, // Set initial value here
            //           onChanged: (value) {
            //             // Handle switch toggle
            //           },
            //           activeColor: Colors.white,
            //           activeTrackColor: Colors.black,
            //           inactiveThumbColor: Colors.black,
            //           inactiveTrackColor: Colors.white,
            //         ),
            //       ),
            //       ListTile(
            //         leading: Icon(Icons.dark_mode),
            //         title: Text(
            //           'Dark Mode',
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         trailing: Switch(
            //           value: false, // Set initial value here
            //           onChanged: (value) {
            //             // Handle switch toggle
            //           },
            //           activeColor: Colors.white,
            //           activeTrackColor: Colors.black,
            //           inactiveThumbColor: Colors.black,
            //           inactiveTrackColor: Colors.white,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 20),

            // Change Profile, Change Password, & About the App
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 20),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => ProfilePage()),
                      // );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text(
                      'Change Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 20),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => ChangePassword()),
                      // );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text(
                      'About the App',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
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
                  // Show confirmation dialog before logging out
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // Rounded corners
                        ),
                        backgroundColor:
                            Colors.blueGrey[50], // Lighter background color
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
                          'Are you sure to log out?',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.blueGrey[600],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
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
                              Navigator.of(context).pop(); // Close the dialog
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
                                fontSize: 16,
                                color: Colors.red, // Red color for Log Out
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
