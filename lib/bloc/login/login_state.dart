import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool passwordVisible;

  const LoginState({
    required this.email,
    required this.password,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isFailure = false,
    this.passwordVisible = false,
  });

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    bool? passwordVisible,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      passwordVisible: passwordVisible ?? this.passwordVisible,
    );
  }

  @override
  List<Object> get props =>
      [email, password, isSubmitting, isSuccess, isFailure];
}
