import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrinklyze_6/providers/image_provider.dart';
import 'package:image/image.dart' as img; 

class DisplayPictureScreen extends ConsumerWidget {
  final File imageFile;
  final bool isFrontCamera;

  const DisplayPictureScreen({
    super.key,
    required this.imageFile,
    required this.isFrontCamera,
  });

  Future<File> _flipImageHorizontally(File imageFile) async {

    final imageBytes = await imageFile.readAsBytes();

    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) {
      throw Exception("Could not decode image");
    }

    img.Image flippedImage =
        img.copyFlip(originalImage, direction: img.FlipDirection.horizontal);

    final flippedImageBytes = img.encodeJpg(flippedImage);

    final flippedImageFile =
        File(imageFile.path.replaceFirst('.jpg', '_flipped.jpg'));
    await flippedImageFile.writeAsBytes(flippedImageBytes);
    return flippedImageFile; 
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff052135),
        title: const Text('Captured Image', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: isFrontCamera
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.14159),
                      child: Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            color: const Color(0xff052135),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: imageState.isUploading
                      ? null
                      : () async {
                          File uploadFile = imageFile;
                          if (isFrontCamera) {
                            uploadFile =
                                await _flipImageHorizontally(imageFile);
                          }
                          final downloadUrl = await ref
                              .read(imageProvider.notifier)
                              .uploadImage(uploadFile);
                          if (downloadUrl != null) {
                            await ref
                                .read(imageProvider.notifier)
                                .sendImageToPredictApi(context, downloadUrl);
                          } else if (imageState.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(imageState.errorMessage!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: imageState.isUploading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF7995A4)),
                          )
                        : const Icon(
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
