import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wrinklyze_6/bloc/sign_up/sign_up_bloc.dart';
import 'package:wrinklyze_6/bloc/sign_up/sign_up_event.dart';
import 'package:wrinklyze_6/bloc/sign_up/sign_up_state.dart';
import 'package:wrinklyze_6/pages/login_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SignUpBloc(FirebaseAuth.instance, FirebaseFirestore.instance),
      child: Scaffold(
        body: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) {
            final bloc = context.read<SignUpBloc>();

            if (state.errorMessage != null) {
              Future.microtask(() {
                final snackBar = SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            }

            if (state.isSuccess) {
              Future.microtask(() {
                final snackBar = SnackBar(
                  content: const Text('Account has been successfully created.'),
                  backgroundColor: Colors.green,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              });
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 66.0),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF052135),
                            ),
                          ),
                          const SizedBox(height: 50),

                          // Username TextField
                          _buildTextField(
                            labelText: 'Username',
                            controller: _usernameController,
                            onChanged: (value) =>
                                bloc.add(SignUpUsernameChanged(value)),
                          ),

                          const SizedBox(height: 20),

                          // Email TextField
                          _buildTextField(
                            labelText: 'Email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) =>
                                bloc.add(SignUpEmailChanged(value)),
                          ),

                          const SizedBox(height: 20),

                          // Password TextField
                          _buildTextField(
                            labelText: 'Password',
                            controller: _passwordController,
                            obscureText: true,
                            onChanged: (value) =>
                                bloc.add(SignUpPasswordChanged(value)),
                          ),

                          const SizedBox(height: 20),

                          // Confirm Password TextField
                          _buildTextField(
                            labelText: 'Confirm Password',
                            controller: _confirmPasswordController,
                            obscureText: true,
                            onChanged: (value) =>
                                bloc.add(SignUpConfirmPasswordChanged(value)),
                          ),

                          const SizedBox(height: 10),

                          // Terms and Conditions Checkbox
                          Container(
                            width: 360,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: state.termsAccepted,
                                  onChanged: (value) => bloc
                                      .add(SignUpTermsAcceptedToggled(value!)),
                                ),
                                const Text(
                                  'I have read and agree to the Terms \nand Conditions',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    color: Color(0xFF797979),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Sign Up Button
                          ElevatedButton(
                            onPressed: state.isSignUpButtonEnabled
                                ? () => bloc.add(SignUpSubmitted())
                                : null,
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(350, 60),
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: const Color(0xFF052135),
                            ),
                            child: state.isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),

                          // Divider with "or"
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 3,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    'or',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
                                      color: Color(0xFF797979),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 3,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Google Sign-In Button
                          ElevatedButton(
                            onPressed: () {
                              // Google login logic (to be implemented)
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(350, 60),
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/google_icon.png',
                                  width: 25,
                                  height: 25,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Color(0xFF052135),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Already have an account
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    color: Color(0xFF797979),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                    );
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
                                      color: Color(0xFF052135),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Container(
      width: 350,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Color(0xFF797979),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
