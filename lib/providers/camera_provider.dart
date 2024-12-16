// camera_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class CameraState {
  final CameraController? cameraController;
  final List<CameraDescription>? cameras;
  final int? selectedCameraIndex;
  final bool isCameraInitialized;
  final bool isCameraSwitching;

  CameraState({
    this.cameraController,
    this.cameras,
    this.selectedCameraIndex,
    this.isCameraInitialized = false,
    this.isCameraSwitching = false,
  });

  CameraState copyWith({
    CameraController? cameraController,
    List<CameraDescription>? cameras,
    int? selectedCameraIndex,
    bool? isCameraInitialized,
    bool? isCameraSwitching,
  }) {
    return CameraState(
      cameraController: cameraController ?? this.cameraController,
      cameras: cameras ?? this.cameras,
      selectedCameraIndex: selectedCameraIndex ?? this.selectedCameraIndex,
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
      isCameraSwitching: isCameraSwitching ?? this.isCameraSwitching,
    );
  }
}

class CameraNotifier extends StateNotifier<CameraState> {
  CameraNotifier() : super(CameraState());

  Future<void> initializeCameras() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      state = state.copyWith(
        cameras: cameras,
        selectedCameraIndex: cameras.indexWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back),
      );
      await initializeCamera(state.selectedCameraIndex!);
    }
  }

  Future<void> initializeCamera(int cameraIndex) async {
    state = state.copyWith(isCameraSwitching: true);
    final controller = CameraController(
      state.cameras![cameraIndex],
      // ResolutionPreset.medium,
      ResolutionPreset.high,
    );

    await controller.initialize();
    state = state.copyWith(
      cameraController: controller,
      isCameraInitialized: true,
      isCameraSwitching: false,
    );
  }

  Future<void> switchCamera() async {
    if (state.cameras != null && !state.isCameraSwitching) {
      state = state.copyWith(isCameraSwitching: true);
      final newIndex = state.selectedCameraIndex ==
              state.cameras!.indexWhere(
                  (camera) => camera.lensDirection == CameraLensDirection.back)
          ? state.cameras!.indexWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front)
          : state.cameras!.indexWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back);
      await initializeCamera(newIndex);
      state = state.copyWith(selectedCameraIndex: newIndex);
    }
  }

  Future<File> saveImageLocally(XFile imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'IMG_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = p.join(appDir.path, fileName);
    return File(filePath)..writeAsBytes(await imageFile.readAsBytes());
  }
}

final cameraProvider =
    StateNotifierProvider<CameraNotifier, CameraState>((ref) {
  return CameraNotifier()..initializeCameras();
});
