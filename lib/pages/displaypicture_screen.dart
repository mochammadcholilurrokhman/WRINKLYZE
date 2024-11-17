import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image/image.dart' as img;
import 'package:wrinklyze_6/pages/face_result_page.dart';

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

      File fileToUpload = widget.imageFile;

      if (widget.isFrontCamera) {
        final originalImageBytes = await fileToUpload.readAsBytes();
        final originalImage = img.decodeImage(originalImageBytes);
        if (originalImage != null) {
          final mirroredImage = img.flipHorizontal(originalImage);
          final mirroredImageBytes = img.encodeJpg(mirroredImage);

          final tempDir = Directory.systemTemp;
          final mirroredFile = File('${tempDir.path}/$fileName');
          await mirroredFile.writeAsBytes(mirroredImageBytes);

          fileToUpload = mirroredFile;
        }
      }

      final uploadTask = await ref.putFile(fileToUpload);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('captures')
          .add({
        'url': downloadUrl,
        'filename': fileName,
        'timestamp': DateTime.now(),
      });

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
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: widget.isFrontCamera
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(3.14159),
                            child: Image.file(
                              widget.imageFile,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.file(
                            widget.imageFile,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FaceScanResultPage(
                                  skinType: "Wrinkles at Rest (Kerutan Sedang)",
                                  details:
                                      "Kerutan tetap terlihat meskipun wajah dalam keadaan rileks. Menunjukkan penuaan yang lebih lanjut.",
                                  imagePath: downloadUrl,
                                ),
                              ),
                            );
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
