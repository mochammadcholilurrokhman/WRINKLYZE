import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:wrinklyze_6/pages/face_result_page.dart';
import 'dart:convert';
import 'dart:io';

final imageProvider = StateNotifierProvider<ImageNotifier, ImageState>((ref) {
  return ImageNotifier();
});

class ImageState {
  final bool isUploading;
  final String? downloadUrl;
  final String? errorMessage;

  ImageState({this.isUploading = false, this.downloadUrl, this.errorMessage});
}

class ImageNotifier extends StateNotifier<ImageState> {
  ImageNotifier() : super(ImageState());

  Future<String?> uploadImage(File imageFile) async {
    state = ImageState(isUploading: true);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      state = ImageState(
          isUploading: false, errorMessage: "You must be logged in to upload.");
      return null;
    }

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_uploads/${user.uid}/$fileName');

      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      state = ImageState(isUploading: false, downloadUrl: downloadUrl);
      return downloadUrl;
    } catch (e) {
      state = ImageState(
          isUploading: false, errorMessage: "Failed to upload image.");
      return null;
    }
  }

  Future<void> sendImageToPredictApi(
      BuildContext context, String imageUrl) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.7:5000/upload_file'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image_url': imageUrl}),
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        String skinType = responseJson['prediction'] ?? 'Unknown';
        String title = responseJson['title'] ?? 'Unknown';
        double confidence = responseJson['confidence'] ?? 0.0;
        List<dynamic> probabilities = responseJson['probabilities'] ?? [];

        // Navigate to the FaceScanResultPage with the results
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FaceScanResultPage(
              skinType: skinType,
              confidence: confidence,
              probabilities: probabilities,
              imagePath: imageUrl,
              title: title,
            ),
          ),
        );
      } else {
        final responseJson = jsonDecode(response.body);
        String errorMessage =
            responseJson['error'] ?? 'Failed to get prediction.';
        bool faceDetected = responseJson['face_detected'] ?? true;

        if (!faceDetected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("No face detected in the image."),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An unexpected error occurred."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
