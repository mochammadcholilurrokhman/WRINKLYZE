import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordNotifier, ForgotPasswordState>((ref) {
  return ForgotPasswordNotifier();
});

class ForgotPasswordState {
  final bool isLoading;
  final String? errorMessage;

  ForgotPasswordState({
    this.isLoading = false,
    this.errorMessage,
  });
}

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ForgotPasswordNotifier() : super(ForgotPasswordState());

  Future<void> sendPasswordResetEmail(String email) async {
    state = ForgotPasswordState(isLoading: true);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      state = ForgotPasswordState(isLoading: false);
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'Email is not registered. Please check and try again.';
      } else {
        message = 'Failed to send password reset email. Please try again.';
      }
      state = ForgotPasswordState(isLoading: false, errorMessage: message);
    }
  }
}
