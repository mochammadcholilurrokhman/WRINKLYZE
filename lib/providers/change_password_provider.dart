import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final changePasswordProvider =
    StateNotifierProvider<ChangePasswordNotifier, ChangePasswordState>((ref) {
  return ChangePasswordNotifier();
});

class ChangePasswordState {
  final bool isLoading;
  final String? errorMessage;
  final bool newPasswordVisible;
  final bool confirmPasswordVisible;
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  ChangePasswordState({
    this.isLoading = false,
    this.errorMessage,
    this.newPasswordVisible = false,
    this.confirmPasswordVisible = false,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
  });
}

class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChangePasswordNotifier()
      : super(ChangePasswordState(
          currentPasswordController: TextEditingController(),
          newPasswordController: TextEditingController(),
          confirmPasswordController: TextEditingController(),
        ));

  @override
  void dispose() {
    state.currentPasswordController.dispose();
    state.newPasswordController.dispose();
    state.confirmPasswordController.dispose();
    super.dispose();
  }

  void toggleNewPasswordVisibility() {
    state = ChangePasswordState(
      isLoading: state.isLoading,
      errorMessage: state.errorMessage,
      newPasswordVisible: !state.newPasswordVisible,
      confirmPasswordVisible: state.confirmPasswordVisible,
      currentPasswordController: state.currentPasswordController,
      newPasswordController: state.newPasswordController,
      confirmPasswordController: state.confirmPasswordController,
    );
  }

  void toggleConfirmPasswordVisibility() {
    state = ChangePasswordState(
      isLoading: state.isLoading,
      errorMessage: state.errorMessage,
      newPasswordVisible: state.newPasswordVisible,
      confirmPasswordVisible: !state.confirmPasswordVisible,
      currentPasswordController: state.currentPasswordController,
      newPasswordController: state.newPasswordController,
      confirmPasswordController: state.confirmPasswordController,
    );
  }

  Future<void> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    if (newPassword != confirmPassword) {
      state = ChangePasswordState(
          errorMessage: 'New password and confirmation do not match',
          currentPasswordController: state.currentPasswordController,
          newPasswordController: state.newPasswordController,
          confirmPasswordController: state.confirmPasswordController);
      return;
    }

    if (newPassword.length < 8) {
      state = ChangePasswordState(
          errorMessage: 'New password should be at least 8 characters long',
          currentPasswordController: state.currentPasswordController,
          newPasswordController: state.newPasswordController,
          confirmPasswordController: state.confirmPasswordController);
      return;
    }

    try {
      User? user = _auth.currentUser;
      String email = user?.email ?? "";

      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      await user?.reauthenticateWithCredential(credential);
      await user?.updatePassword(newPassword);

      state = ChangePasswordState(
        currentPasswordController: TextEditingController(),
        newPasswordController: TextEditingController(),
        confirmPasswordController: TextEditingController(),
      );
    } catch (e) {
      state = ChangePasswordState(
          errorMessage: 'Failed to change password. Please try again.',
          currentPasswordController: state.currentPasswordController,
          newPasswordController: state.newPasswordController,
          confirmPasswordController: state.confirmPasswordController);
    }
  }
}
