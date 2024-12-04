import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wrinklyze_6/pages/login_page.dart';

final signUpProvider =
    StateNotifierProvider<SignUpNotifier, SignUpState>((ref) {
  return SignUpNotifier();
});

class SignUpState {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final bool termsAccepted;
  final String? errorMessage;

  SignUpState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.termsAccepted = false,
    this.errorMessage,
  });
}

class SignUpNotifier extends StateNotifier<SignUpState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SignUpNotifier() : super(SignUpState());

  void setUsername(String username) {
    state = SignUpState(
      username: username,
      email: state.email,
      password: state.password,
      confirmPassword: state.confirmPassword,
      isLoading: state.isLoading,
      termsAccepted: state.termsAccepted,
    );
  }

  void setEmail(String email) {
    state = SignUpState(
      username: state.username,
      email: email,
      password: state.password,
      confirmPassword: state.confirmPassword,
      isLoading: state.isLoading,
      termsAccepted: state.termsAccepted,
    );
  }

  void setPassword(String password) {
    state = SignUpState(
      username: state.username,
      email: state.email,
      password: password,
      confirmPassword: state.confirmPassword,
      isLoading: state.isLoading,
      termsAccepted: state.termsAccepted,
    );
  }

  void setConfirmPassword(String confirmPassword) {
    state = SignUpState(
      username: state.username,
      email: state.email,
      password: state.password,
      confirmPassword: confirmPassword,
      isLoading: state.isLoading,
      termsAccepted: state.termsAccepted,
    );
  }

  void setTermsAccepted(bool accepted) {
    state = SignUpState(
      username: state.username,
      email: state.email,
      password: state.password,
      confirmPassword: state.confirmPassword,
      isLoading: state.isLoading,
      termsAccepted: accepted,
    );
  }

  Future<void> signUp(BuildContext context) async {
    if (state.isLoading) return;

    state = SignUpState(
      username: state.username,
      email: state.email,
      password: state.password,
      confirmPassword: state.confirmPassword,
      isLoading: true,
      termsAccepted: state.termsAccepted,
    );

    if (state.password.length < 8) {
      state = SignUpState(
        username: state.username,
        email: state.email,
        password: state.password,
        confirmPassword: state.confirmPassword,
        isLoading: false,
        termsAccepted: state.termsAccepted,
        errorMessage: 'Your password should be at least 8 characters long',
      );
      return;
    }

    if (state.password == state.confirmPassword) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: state.email.trim(),
          password: state.password.trim(),
        );

        await userCredential.user?.updateDisplayName(state.username.trim());
        await _createUserDocument(userCredential.user!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        state = SignUpState(
          username: state.username,
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
          isLoading: false,
          termsAccepted: state.termsAccepted,
          errorMessage: 'Invalid email',
        );
      } finally {
        state = SignUpState(
          username: state.username,
          email: state.email,
          password: state.password,
          confirmPassword: state.confirmPassword,
          isLoading: false,
          termsAccepted: state.termsAccepted,
        );
      }
    } else {
      state = SignUpState(
        username: state.username,
        email: state.email,
        password: state.password,
        confirmPassword: state.confirmPassword,
        isLoading: false,
        termsAccepted: state.termsAccepted,
        errorMessage: 'Passwords do not match',
      );
    }
  }

  Future<void> _createUserDocument(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'username': state.username.trim(),
      'email': user.email,
      'profilePic': user.photoURL ?? '',
      'createdAt': Timestamp.now(),
      'lastLogin': Timestamp.now(),
    });
  }
}
