import 'package:flutter/material.dart';
import 'package:wrinklyze_6/pages/register_page.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'), // Tambahkan judul yang relevan
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Account screen."),
              SizedBox(height: 20), // Jarak antara teks dan tombol
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke RegisterPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text('Register Page'),
              ),
              SizedBox(height: 20),

              // Profile Container
              Container(
                color: Colors.blueGrey,
                padding: EdgeInsets.only(bottom: 50.0, left: 30.0, right: 30.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                    SizedBox(width: 30), // jarak antara gambar dan teks
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Walter White',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'walterwhite69@gmail.com',
                          style: TextStyle(
                            fontSize: 12,
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0), // Perbaiki radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text(
                        'Notification',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Switch(
                        value: true, // Set initial value here
                        onChanged: (value) {
                          // Handle switch toggle
                        },
                        activeColor: Colors.white,
                        activeTrackColor: Colors.black,
                        inactiveThumbColor: Colors.black,
                        inactiveTrackColor: Colors.white,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.dark_mode),
                      title: Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Switch(
                        value: false, // Set initial value here
                        onChanged: (value) {
                          // Handle switch toggle
                        },
                        activeColor: Colors.white,
                        activeTrackColor: Colors.black,
                        inactiveThumbColor: Colors.black,
                        inactiveTrackColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Change Profile, Change Password, & About the App
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0), // Perbaiki radius
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
                        'Change Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      onTap: () {
                        // Navigasi ke halaman ubah profil
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
                        // Navigasi ke halaman ubah kata sandi
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
                        // Navigasi ke halaman tentang aplikasi
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
                    // Handle log out
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
