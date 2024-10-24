import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 66.0), // Jarak dari atas untuk konten utama
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF052135), // Set text color to 052135
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Gambar (Ikon)
                  Image.asset(
                    'assets/logo.png',
                    width: 230, // 2 * radius of CircleAvatar
                    height: 230, // 2 * radius of CircleAvatar
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 50),
                  // Formulir
                  Container(
                    width: 350,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: Color(0xFF797979),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 350,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              obscureText:
                                  passwordVisible, // Menyembunyikan teks password
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  color: Color(0xFF797979),
                                ),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off, // Ikon toggle
                                    color: const Color(0xFF797979),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible =
                                          !passwordVisible; // Toggle visibilitas password
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Implementasi logika saat tombol ditekan
                        },
                        child: const Text(
                          'Forgot your Password?',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: Color(0xFF797979),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Tombol Login
                  ElevatedButton(
                    onPressed: () {
                      // Implementasi logika saat tombol ditekan
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(350, 60),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: const Color(0xFF052135),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 3,
                            color: Colors.grey, // Color of the line
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'or',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              color: Color(0xFF797979), // Color of the text
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 3,
                            color: Colors.grey, // Color of the line
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tombol Login dengan Google
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implementasi login dengan Google
                    },
                    icon: const Icon(Icons.g_translate),
                    label: const Text(
                      'Continue with Google',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Color(0xFF052135),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(350, 60), // Set width and height
                      side: const BorderSide(
                          color: Colors.grey), // Add grey border
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Add border radius
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Link Register
                  TextButton(
                    onPressed: () {
                      // Navigasi ke halaman register
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Don’t have an account?',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: Color(0xFF797979),
                          ),
                        ),
                        SizedBox(width: 4), // Add some space between the texts
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: Color(0xFF052135), // Change color to 052135
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Posisi ikon panah diatur dengan Positioned
          Positioned(
            left: 3, // Koordinat X
            top: 20, // Koordinat Y
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF052135), size: 30),
              onPressed: () {
                // Implementasi logika saat tombol panah ditekan
              },
            ),
          ),
        ],
      ),
    );
  }
}
