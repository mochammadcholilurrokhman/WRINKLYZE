import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wrinklyze_6/providers/camera_provider.dart';
import 'displaypicture_screen.dart';
import 'dart:io';

class CameraPage extends ConsumerWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff052135),
        title: const Text('Camera Page', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: cameraState.isCameraInitialized
                ? Stack(
                    children: [
                      Positioned.fill(
                        child: Center(
                          child: AspectRatio(
                            aspectRatio:
                                cameraState.cameraController!.value.aspectRatio,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: cameraState.selectedCameraIndex ==
                                        cameraState.cameras!.indexWhere(
                                            (camera) =>
                                                camera.lensDirection ==
                                                CameraLensDirection.front)
                                    ? Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(3.14159),
                                        child: CameraPreview(
                                            cameraState.cameraController!),
                                      )
                                    : CameraPreview(
                                        cameraState.cameraController!),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            color: const Color(0xff052135),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () async {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      final imageFile = File(pickedFile.path);
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
                        const SnackBar(
                          content: Text("No image selected."),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.photo_library, color: Colors.white),
                  iconSize: 40,
                ),
                GestureDetector(
                  onTap: () async {
                    final controller = cameraState.cameraController;
                    if (controller != null && controller.value.isInitialized) {
                      try {
                        final image = await controller.takePicture();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayPictureScreen(
                              imageFile: File(image.path),
                              isFrontCamera: cameraState.selectedCameraIndex ==
                                  cameraState.cameras!.indexWhere((camera) =>
                                      camera.lensDirection ==
                                      CameraLensDirection.front),
                            ),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Failed to capture image. Please try again."),
                          ),
                        );
                      }
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF7995A4),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD9D9D9),
                        ),
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE9EEF0),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: !cameraState.isCameraSwitching
                      ? () => ref.read(cameraProvider.notifier).switchCamera()
                      : null,
                  icon: const Icon(Icons.flip_camera_android_rounded,
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
