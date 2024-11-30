import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wrinklyze_6/bloc/login/login_bloc.dart';
import 'package:wrinklyze_6/bloc/login/login_event.dart';
import 'package:wrinklyze_6/bloc/login/login_state.dart';
import 'package:wrinklyze_6/main.dart';
import 'package:wrinklyze_6/pages/forgot_password_page.dart';
import 'package:wrinklyze_6/pages/signup_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(), // Menyediakan LoginBloc di sini
      child: Scaffold(
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                (route) => false,
              );
            } else if (state.isFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Incorrect email or password'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final loginBloc = context.read<LoginBloc>();

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
                            'Login',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF052135),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Image.asset(
                            'assets/images/welcome_logo.png',
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 50),
                          // Email TextField
                          Container(
                            width: 350,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                onChanged: (email) =>
                                    loginBloc.add(LoginEmailChanged(email)),
                                decoration: const InputDecoration(
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
                          // Password TextField
                          Container(
                            width: 350,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                onChanged: (password) => loginBloc
                                    .add(LoginPasswordChanged(password)),
                                obscureText: !state
                                    .passwordVisible, // Toggled based on passwordVisible
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
                                      state.passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: const Color(0xFF797979),
                                    ),
                                    onPressed: () {
                                      loginBloc.add(
                                          LoginPasswordVisibilityToggled()); // Toggle visibility
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordPage()),
                                  );
                                },
                                child: const Text(
                                  'Forgot your Password?',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    color: Color(0xFF797979),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: state.isSubmitting
                                ? null
                                : () => loginBloc.add(LoginSubmitted()),
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(350, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: const Color(0xFF052135),
                            ),
                            child: state.isSubmitting
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : const Text(
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
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account? ',
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
                                          builder: (context) => SignUpPage()),
                                    );
                                  },
                                  child: const Text(
                                    'Sign Up',
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
                          )
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
}
