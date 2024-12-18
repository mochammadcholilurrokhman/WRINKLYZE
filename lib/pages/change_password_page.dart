import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrinklyze_6/pages/forgot_password_page.dart';
import 'package:wrinklyze_6/providers/change_password_provider.dart';

class ChangePasswordPage extends ConsumerWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changePasswordState = ref.watch(changePasswordProvider);
    final changePasswordNotifier = ref.read(changePasswordProvider.notifier);

    final double textFieldWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                controller: changePasswordState.currentPasswordController,
                labelText: 'Current password',
                obscureText: true,
                width: textFieldWidth,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: changePasswordState.newPasswordController,
                labelText: 'New password',
                obscureText: !changePasswordState.newPasswordVisible,
                width: textFieldWidth,
                toggleVisibility: () {
                  changePasswordNotifier.toggleNewPasswordVisibility();
                },
                visible: changePasswordState.newPasswordVisible,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: changePasswordState.confirmPasswordController,
                labelText: 'Confirm new password',
                obscureText: !changePasswordState.confirmPasswordVisible,
                width: textFieldWidth,
                toggleVisibility: () {
                  changePasswordNotifier.toggleConfirmPasswordVisibility();
                },
                visible: changePasswordState.confirmPasswordVisible,
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
                onPressed: () {
                  changePasswordNotifier.changePassword(
                    changePasswordState.currentPasswordController.text,
                    changePasswordState.newPasswordController.text,
                    changePasswordState.confirmPasswordController.text,
                  );
                  if (changePasswordState.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(changePasswordState.errorMessage!),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password changed successfully'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
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
