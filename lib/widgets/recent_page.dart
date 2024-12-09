import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecentFile extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String captureId;
  final VoidCallback onDelete;

  const RecentFile({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.date,
    required this.captureId,
    required this.onDelete,
  }) : super(key: key);

  Future<void> _deleteCapture(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || captureId.isEmpty) {
        throw Exception("User is not logged in or captureId is empty");
      }

      final captureDocPath = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('face_results')
          .doc(captureId);

      final docSnapshot = await captureDocPath.get();
      if (!docSnapshot.exists) {
        throw Exception("Capture document not found");
      }

      String imagePath = docSnapshot['imagePath'];

      await captureDocPath.delete();
      await FirebaseStorage.instance.refFromURL(imagePath).delete();

      onDelete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Capture deleted successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete capture: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Wrap(
                    children: [
                      ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text("Delete"),
                        onTap: () {
                          _deleteCapture(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
