import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  int _selectedCameraIndex = 0;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera(_selectedCameraIndex);
  }

  Future<void> initializeCamera(int cameraIndex) async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(
        cameras![cameraIndex],
        ResolutionPreset.high,
      );
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void switchCamera() {
    if (cameras != null && cameras!.length > 1) {
      setState(() {
        _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras!.length;
        initializeCamera(_selectedCameraIndex);
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
          // Bagian tengah untuk menampilkan kamera
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
                                  cameras![_selectedCameraIndex]
                                          .lensDirection ==
                                      CameraLensDirection.front
                              ? Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(
                                      3.14159), // Mirror untuk kamera depan
                                  child: CameraPreview(_cameraController!),
                                )
                              : CameraPreview(_cameraController!),
                        ),
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          ),

          // Bagian bawah: Tombol kamera dan switch kamera
          Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            color: Color(0xff052135),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: switchCamera,
                  icon: Icon(Icons.switch_camera, color: Colors.white),
                  iconSize: 40,
                ),
                // Tombol kamera di tengah
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

                // Tombol switch kamera di sebelah kanan
                IconButton(
                  onPressed: switchCamera,
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
