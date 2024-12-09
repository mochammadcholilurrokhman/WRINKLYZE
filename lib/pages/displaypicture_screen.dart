import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'face_result_page.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DisplayPictureScreen extends StatefulWidget {
  final File imageFile;
  final bool isFrontCamera;

  const DisplayPictureScreen({
    Key? key,
    required this.imageFile,
    required this.isFrontCamera,
  }) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  bool _isUploading = false;
  String? _predictionResult;
  String? _predictionDetails;

  Future<File> _saveImageLocally(XFile imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = p.join(appDir.path, fileName);

    return File(filePath)..writeAsBytes(await imageFile.readAsBytes());
  }

  Future<String?> _uploadToFirebaseStorage() async {
    setState(() {
      _isUploading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You must be logged in to upload."),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_uploads/${user.uid}/$fileName');

      // Upload the image to Firebase Storage
      await ref.putFile(widget.imageFile);
      final downloadUrl = await ref.getDownloadURL();

      setState(() {
        _isUploading = false;
      });

      return downloadUrl;
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print("Failed to upload image: $e");
      return null;
    }
  }

  Future<void> _sendImageToPredictApi(String imageUrl) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.215.155:5000/upload_file'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image_url': imageUrl}),
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        String skinType = responseJson['prediction'] ?? 'Unknown';
        String title = responseJson['title'] ?? 'Unknown';
        double confidence = responseJson['confidence'] ?? 0.0;
        List<dynamic> probabilities = responseJson['probabilities'] ?? [];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FaceScanResultPage(
                skinType: skinType,
                confidence: confidence,
                probabilities: probabilities,
                imagePath: imageUrl,
                title: title),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to get prediction."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error sending image URL to API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff052135),
        title: Text('Captured Image', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.file(
                widget.imageFile,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            color: Color(0xff052135),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _isUploading
                      ? null
                      : () async {
                          final downloadUrl = await _uploadToFirebaseStorage();
                          if (downloadUrl != null) {
                            await _sendImageToPredictApi(downloadUrl);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Failed to upload image."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: _isUploading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF7995A4)),
                          )
                        : Icon(
                            Icons.check,
                            color: Color(0xFF7995A4),
                            size: 40,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
