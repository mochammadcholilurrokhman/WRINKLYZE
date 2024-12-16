import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:wrinklyze_6/main.dart';

class FaceScanResult {
  final String skinType;
  final double confidence;
  final List<dynamic> probabilities;
  final String imagePath;
  final String title;

  FaceScanResult({
    required this.skinType,
    required this.confidence,
    required this.probabilities,
    required this.imagePath,
    required this.title,
  });
}

final faceScanResultProvider =
    StateNotifierProvider<FaceScanResultNotifier, FaceScanResult?>((ref) {
  return FaceScanResultNotifier();
});

class FaceScanResultNotifier extends StateNotifier<FaceScanResult?> {
  FaceScanResultNotifier() : super(null);

  void setFaceScanResult(FaceScanResult result) {
    state = result;
  }

  Future<void> saveToFirestore(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    if (user != null && state != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('face_results')
            .add({
          'title': state!.title,
          'skinType': state!.skinType,
          'confidence': state!.confidence,
          'probabilities': state!.probabilities,
          'imagePath': state!.imagePath,
          'timestamp': formattedDate,
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save data: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
