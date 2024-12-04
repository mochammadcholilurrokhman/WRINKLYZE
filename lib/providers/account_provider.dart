import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String email;
  final String username;

  UserData({required this.email, required this.username});
}

final userProvider = StateNotifierProvider<UserNotifier, UserData?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserData?> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserNotifier() : super(null) {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      state = UserData(
        email: user.email ?? 'Not logged in',
        username: doc['username'] ?? '',
      );
    } else {
      state = null;
    }
  }

  void updateUsername(String newUsername) {
    if (state != null) {
      state = UserData(email: state!.email, username: newUsername);
    }
  }
}
