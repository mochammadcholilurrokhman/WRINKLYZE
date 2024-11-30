import 'package:equatable/equatable.dart';

class SignUpState extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;
  final String username;
  final bool termsAccepted;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const SignUpState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.username = '',
    this.termsAccepted = false,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  bool get isSignUpButtonEnabled =>
      username.isNotEmpty &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      password == confirmPassword &&
      termsAccepted &&
      !isLoading;

  SignUpState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? username,
    bool? termsAccepted,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      username: username ?? this.username,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        username,
        termsAccepted,
        isLoading,
        errorMessage
      ];
}
