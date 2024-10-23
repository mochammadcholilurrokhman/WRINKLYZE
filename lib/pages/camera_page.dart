import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
      // Set initial camera to back camera
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

  Future<void> pickImageFromGallery() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      print("Image selected: ${image.path}");
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
                ? Center(
                    child: AspectRatio(
                      aspectRatio: _cameraController!.value.aspectRatio,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: _cameraController != null &&
                                  cameras != null &&
                                  cameras![_selectedCameraIndex!]
                                          .lensDirection ==
                                      CameraLensDirection.front
                              ? Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(3.14159),
                                  child: CameraPreview(_cameraController!),
                                )
                              : CameraPreview(_cameraController!),
                        ),
                      ),
                    ),
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
                FloatingActionButton(
                  onPressed: () async {
                    try {
                      final image = await _cameraController!.takePicture();
                      Navigator.pop(context, image.path);
                    } catch (e) {
                      print('Error capturing image: $e');
                    }
                  },
                  backgroundColor: Colors.white,
                  child: Icon(Icons.camera_alt, color: Colors.black),
                ),
                IconButton(
                  onPressed: !_isCameraSwitching ? switchCamera : null,
                  icon: Icon(Icons.switch_camera, color: Colors.white),
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
