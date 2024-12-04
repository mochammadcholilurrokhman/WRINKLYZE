import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wrinklyze_6/main.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final String email;
  final String password;
  final bool isLoading;
  final String? errorMessage;
  final bool isPasswordVisible;

  AuthState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.errorMessage,
    this.isPasswordVisible = false,
  });
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthNotifier() : super(AuthState());

  void setEmail(String email) {
    state = AuthState(
        email: email,
        password: state.password,
        isLoading: state.isLoading,
        isPasswordVisible: state.isPasswordVisible);
  }

  void setPassword(String password) {
    state = AuthState(
        email: state.email,
        password: password,
        isLoading: state.isLoading,
        isPasswordVisible: state.isPasswordVisible);
  }

  void togglePasswordVisibility() {
    state = AuthState(
      email: state.email,
      password: state.password,
      isLoading: state.isLoading,
      isPasswordVisible: !state.isPasswordVisible,
    );
  }

  Future<void> signIn(BuildContext context) async {
    if (state.isLoading) return;

    state = AuthState(
        email: state.email,
        password: state.password,
        isLoading: true,
        isPasswordVisible: state.isPasswordVisible);

    try {
      await _auth.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid email or password'),
          backgroundColor: Colors.red,
        ),
      );

      state = AuthState(
          email: state.email,
          password: state.password,
          isLoading: false,
          errorMessage: 'Incorrect email or password',
          isPasswordVisible: state.isPasswordVisible);
    } finally {
      state = AuthState(
          email: state.email,
          password: state.password,
          isLoading: false,
          isPasswordVisible: state.isPasswordVisible);
    }
  }
}
