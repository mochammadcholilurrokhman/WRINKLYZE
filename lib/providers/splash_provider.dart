import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final splashProvider =
    StateNotifierProvider<SplashNotifier, SplashState>((ref) {
  return SplashNotifier();
});

class SplashState {
  final bool isLoading;
  final User? currentUser;

  SplashState({
    this.isLoading = true,
    this.currentUser,
  });
}

class SplashNotifier extends StateNotifier<SplashState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SplashNotifier() : super(SplashState()) {
    _checkUserAuth();
  }

  Future<void> _checkUserAuth() async {
    try {
      await Future.delayed(Duration(seconds: 3));

      final User? user = _auth.currentUser;

      state = SplashState(isLoading: false, currentUser: user);
    } catch (e) {
      print('Error saat cek autentikasi: $e');
      state = SplashState(isLoading: false);
    }
  }
}
