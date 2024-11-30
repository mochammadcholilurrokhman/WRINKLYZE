import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  SignUpBloc(this._auth, this._firestore) : super(const SignUpState()) {
    on<SignUpEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<SignUpPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<SignUpConfirmPasswordChanged>((event, emit) {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    });

    on<SignUpUsernameChanged>((event, emit) {
      emit(state.copyWith(username: event.username));
    });

    on<SignUpTermsAcceptedToggled>((event, emit) {
      emit(state.copyWith(termsAccepted: event.isAccepted));
    });

    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
      SignUpSubmitted event, Emitter<SignUpState> emit) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));

    if (state.password.trim().length < 8) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Password must be at least 8 characters.',
      ));
      return;
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );

      await userCredential.user?.updateDisplayName(state.username.trim());

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': state.username.trim(),
        'email': state.email.trim(),
        'profilePic': userCredential.user?.photoURL ?? '',
        'createdAt': Timestamp.now(),
        'lastLogin': Timestamp.now(),
      });

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'This email is already registered.',
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'An error occurred. Please try again.',
        ));
      }
    }
  }
}
