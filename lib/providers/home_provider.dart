import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wrinklyze_6/providers/profile_provider.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(ref);
});

class HomeState {
  final String userName;
  final bool isLoading;
  final String? errorMessage;

  HomeState({
    this.userName = '',
    this.isLoading = false,
    this.errorMessage,
  });
}

class HomeNotifier extends StateNotifier<HomeState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  HomeNotifier(Ref ref) : super(HomeState()) {
    _getCurrentUserName();
    ref.listen<Profile>(profileProvider, (previous, next) {
      state = HomeState(userName: next.username, isLoading: false);
    });
  }

  Future<void> _getCurrentUserName() async {
    state = HomeState(userName: state.userName, isLoading: true);
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        state = HomeState(userName: doc['username'] ?? '', isLoading: false);
      } catch (e) {
        state = HomeState(
            userName: state.userName,
            isLoading: false,
            errorMessage: 'Failed to load username');
      }
    } else {
      state = HomeState(
          userName: state.userName,
          isLoading: false,
          errorMessage: 'User not logged in');
    }
  }

  Future<void> updateUserName(String newUserName) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'username': newUserName});

        state = HomeState(userName: newUserName, isLoading: false);
      } catch (e) {
        state = HomeState(
            userName: state.userName,
            isLoading: false,
            errorMessage: 'Failed to update username');
      }
    }
  }
}
