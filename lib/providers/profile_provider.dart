import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile {
  String username;
  String dateOfBirth;
  String gender;

  Profile({
    required this.username,
    required this.dateOfBirth,
    required this.gender,
  });
}

class ProfileNotifier extends StateNotifier<Profile> {
  ProfileNotifier()
      : super(Profile(username: '', dateOfBirth: '', gender: 'Male'));

  void updateProfile(String username, String dateOfBirth, String gender) {
    state =
        Profile(username: username, dateOfBirth: dateOfBirth, gender: gender);
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, Profile>((ref) {
  return ProfileNotifier();
});
