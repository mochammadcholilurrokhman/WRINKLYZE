import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'displaypicture_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class OvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.8,
        height: size.height * 0.7,
      ))
      ..fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(OvalClipper oldClipper) => false;
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  int? _selectedCameraIndex;
  int? _frontCameraIndex;
  int? _backCameraIndex;
  bool _isCameraInitialized = false;
  bool _isCameraSwitching = false;

  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    initializeCameras();
  }

  Future<void> uploadImageToFlask(BuildContext context, File imageFile) async {
    try {
      final uri = Uri.parse(
          'http://192.168.1.12:5000/upload_file'); // ganti sesuai ip masing-masing

      if (!await imageFile.exists()) {
        print('File does not exist.');
        return;
      }

      var request = http.MultipartRequest('POST', uri);
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        Map<String, dynamic> data = json.decode(responseData.body);

        String prediction = data['prediction'] ?? 'Unknown';
        double confidence = (data['confidence'] ?? 0.0).toDouble();

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Prediction Result"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Prediction: $prediction'),
                  Text('Confidence: ${confidence.toStringAsFixed(2)}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Upload failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> initializeCameras() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      for (int i = 0; i < cameras!.length; i++) {
        if (cameras![i].lensDirection == CameraLensDirection.front) {
          _frontCameraIndex = i;
        } else if (cameras![i].lensDirection == CameraLensDirection.back) {
          _backCameraIndex = i;
        }
      }
      _selectedCameraIndex = _backCameraIndex;
      if (_selectedCameraIndex != null) {
        await initializeCamera(_selectedCameraIndex!);
      }
    }
  }

  Future<void> initializeCamera(int cameraIndex) async {
    setState(() {
      _isCameraInitialized = false;
      _isCameraSwitching = true;
    });

    _cameraController = CameraController(
      cameras![cameraIndex],
      ResolutionPreset.high,
    );

    await _cameraController!.initialize();

    setState(() {
      _isCameraInitialized = true;
      _isCameraSwitching = false;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> switchCamera() async {
    if (cameras != null && !_isCameraSwitching) {
      setState(() {
        _isCameraSwitching = true;
      });

      if (_selectedCameraIndex == _backCameraIndex) {
        _selectedCameraIndex = _frontCameraIndex;
      } else {
        _selectedCameraIndex = _backCameraIndex;
      }

      if (_selectedCameraIndex != null) {
        await initializeCamera(_selectedCameraIndex!);
      }

      setState(() {
        _isCameraSwitching = false;
      });
    }
  }

  Future<File> _saveImageLocally(XFile imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = p.join(appDir.path, fileName);

    return File(filePath)..writeAsBytes(await imageFile.readAsBytes());
  }

  Future<String?> _uploadToFirebaseStorage(File imageFile) async {
    try {
      final ref = _storage
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = await ref.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Failed to upload to Firebase Storage: $e');
      return null;
    }
  }

  Future<void> pickImageFromGallery() async {
    User? user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to upload images')),
      );
      return;
    }

    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final File savedFile = await _saveImageLocally(image);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imageFile: savedFile,
            isFrontCamera: false,
          ),
        ),
      );
    } else {
      print("No image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff052135),
        title: Text('Camera Page', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isCameraInitialized
                ? Stack(
                    children: [
                      Positioned.fill(
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: _cameraController!.value.aspectRatio,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: _selectedCameraIndex == _frontCameraIndex
                                    ? Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(3.14159),
                                        child:
                                            CameraPreview(_cameraController!),
                                      )
                                    : CameraPreview(_cameraController!),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: ClipPath(
                          clipper: OvalClipper(),
                          child: Container(
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            color: Color(0xff052135),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: pickImageFromGallery,
                  icon: Icon(Icons.photo_library, color: Colors.white),
                  iconSize: 40,
                ),
                GestureDetector(
                  onTap: () async {
                    try {
                      if (_cameraController!.value.isInitialized) {
                        final XFile image =
                            await _cameraController!.takePicture();
                        final File savedFile = await _saveImageLocally(image);

                        // Call the upload function
                        await uploadImageToFlask(context, savedFile);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayPictureScreen(
                              imageFile: savedFile,
                              isFrontCamera:
                                  _selectedCameraIndex == _frontCameraIndex,
                            ),
                          ),
                        );

                        // Optionally navigate to another screen
                      }
                    } catch (e) {
                      print("Error capturing image: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Failed to capture or upload image. Please try again."),
                        ),
                      );
                    }
                    // try {
                    //   if (_cameraController!.value.isInitialized) {
                    //     final XFile image =
                    //         await _cameraController!.takePicture();
                    //     final File savedFile = await _saveImageLocally(image);

                    //     // Panggil fungsi upload
                    //     await uploadImageToFlask(savedFile);

                    //     // Navigasi ke layar berikutnya
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => DisplayPictureScreen(
                    //           imageFile: savedFile,
                    //           isFrontCamera:
                    //               _selectedCameraIndex == _frontCameraIndex,
                    //         ),
                    //       ),
                    //     );
                    //   }
                    // } catch (e) {
                    //   print("Error capturing image: $e");
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //         content: Text(
                    //             "Failed to capture image. Please try again.")),
                    //   );
                    // }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF7995A4),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD9D9D9),
                        ),
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE9EEF0),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: !_isCameraSwitching ? switchCamera : null,
                  icon: Icon(Icons.flip_camera_android_rounded,
                      color: Colors.white),
                  iconSize: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
