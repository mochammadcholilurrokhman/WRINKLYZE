import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'displaypicture_screen.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
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

  @override
  void initState() {
    super.initState();
    initializeCameras();
  }

  Future<File> _saveImageLocally(XFile imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = p.join(appDir.path, fileName);

    return File(filePath)..writeAsBytes(await imageFile.readAsBytes());
  }

  Future<void> takePicture(BuildContext context) async {
    final controller = _cameraController;

    if (controller == null || !controller.value.isInitialized) {
      print('Error: Camera not initialized.');
      return;
    }

    try {
      final image = await controller.takePicture();
      print('Image captured: ${image.path}');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imageFile: File(image.path),
            isFrontCamera: _selectedCameraIndex == _frontCameraIndex,
          ),
        ),
      );
    } catch (e) {
      print('Error capturing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to capture image. Please try again."),
        ),
      );
    }
  }

  Future<void> pickImageFromGallery(BuildContext context) async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      print('Image selected: ${imageFile.path}');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imageFile: imageFile,
            isFrontCamera: false,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No image selected."),
        ),
      );
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
      // ResolutionPreset.high,
      ResolutionPreset.medium,
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
                  onPressed: () => pickImageFromGallery(context),
                  icon: Icon(Icons.photo_library, color: Colors.white),
                  iconSize: 40,
                ),
                GestureDetector(
                  onTap: () => takePicture(context),
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
