import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrinklyze_6/providers/image_provider.dart';
import 'package:image/image.dart' as img; // Import the image package

class DisplayPictureScreen extends ConsumerWidget {
  final File imageFile;
  final bool isFrontCamera;

  const DisplayPictureScreen({
    Key? key,
    required this.imageFile,
    required this.isFrontCamera,
  }) : super(key: key);

  Future<File> _flipImageHorizontally(File imageFile) async {
    // Read the image file
    final imageBytes = await imageFile.readAsBytes();
    // Decode the image
    img.Image? originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) {
      throw Exception("Could not decode image");
    }
    // Flip the image horizontally
    img.Image flippedImage =
        img.copyFlip(originalImage, direction: img.FlipDirection.horizontal);
    // Encode the flipped image back to bytes
    final flippedImageBytes = img.encodeJpg(flippedImage);
    // Create a new file to save the flipped image
    final flippedImageFile =
        File(imageFile.path.replaceFirst('.jpg', '_flipped.jpg'));
    await flippedImageFile.writeAsBytes(flippedImageBytes);
    return flippedImageFile; // Return the flipped image file
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageProvider);

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
              child: isFrontCamera
                  ? Transform(
                      alignment: Alignment.center,
                      transform:
                          Matrix4.rotationY(3.14159), // Mirror the image in UI
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
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            color: Color(0xff052135),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: imageState.isUploading
                      ? null
                      : () async {
                          File uploadFile =
                              imageFile; // Default to original file
                          if (isFrontCamera) {
                            // Flip the image if using the front camera
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
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: imageState.isUploading
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
