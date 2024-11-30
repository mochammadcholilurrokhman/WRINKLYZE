import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginPasswordVisibilityToggled extends LoginEvent {}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _firebaseAuth;

  LoginBloc({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super(LoginState.initial()) {
    on<LoginEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<LoginPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<LoginPasswordVisibilityToggled>((event, emit) {
      emit(state.copyWith(passwordVisible: !state.passwordVisible));
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(
          isSubmitting: true, isFailure: false, isSuccess: false));

      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } catch (_) {
        emit(state.copyWith(isSubmitting: false, isFailure: true));
      }
    });
  }
}
