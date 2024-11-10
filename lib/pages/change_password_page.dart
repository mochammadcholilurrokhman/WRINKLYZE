import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_password_page.dart'; // Import the ForgotPasswordPage

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final double textFieldWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Color(0xFF052135),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Your password should be at least 8 characters long',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: Color(0xFF797979),
                ),
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: currentPasswordController,
                labelText: 'Current password',
                obscureText: true,
                width: textFieldWidth,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: newPasswordController,
                labelText: 'New password',
                obscureText: newPasswordVisible,
                width: textFieldWidth,
                toggleVisibility: () {
                  setState(() {
                    newPasswordVisible = !newPasswordVisible;
                  });
                },
                visible: newPasswordVisible,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: confirmPasswordController,
                labelText: 'Confirm new password',
                obscureText: confirmPasswordVisible,
                width: textFieldWidth,
                toggleVisibility: () {
                  setState(() {
                    confirmPasswordVisible = !confirmPasswordVisible;
                  });
                },
                visible: confirmPasswordVisible,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: const Text(
                    'Forgot your password?',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      color: Color(0xFF052135),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(textFieldWidth, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: const Color(0xFF052135),
                ),
                child: const Text(
                  'Change password',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('New password and confirmation do not match'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2)),
      );
      return;
    }

    if (newPasswordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('New password should be at least 8 characters long'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2)),
      );
      return;
    }

    try {
      User? user = _auth.currentUser;
      String email = user?.email ?? "";

      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPasswordController.text,
      );

      await user?.reauthenticateWithCredential(credential);
      await user?.updatePassword(newPasswordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Password changed successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2)),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to change password. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2)),
      );
    }
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required double width,
    VoidCallback? toggleVisibility,
    bool? visible,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Color(0xFF797979),
            ),
            border: InputBorder.none,
            suffixIcon: toggleVisibility != null
                ? IconButton(
                    icon: Icon(
                      visible! ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF797979),
                    ),
                    onPressed: toggleVisibility,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
