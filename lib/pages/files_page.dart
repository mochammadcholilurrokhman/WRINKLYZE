import 'package:flutter/material.dart';
import 'package:wrinklyze_6/data/dummy_recognition.dart';
import 'package:wrinklyze_6/pages/camera_page.dart'; // Import CameraPage

class FilesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: dummyRecognitions.length,
                itemBuilder: (BuildContext context, int index) {
                  return RecentFile(
                    imagePath: "assets/images/person1.png",
                    title: dummyRecognitions[index].name,
                    date: dummyRecognitions[index].createdAt,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final imagePath = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CameraPage()), // Navigate to CameraPage
          );
          if (imagePath != null) {
            print('Image captured at path: $imagePath');
          }
        },
        backgroundColor: Colors.blue, // Button color
        child: const Icon(Icons.camera_alt, color: Colors.white), // Camera icon
      ),
    );
  }
}

class RecentFile extends StatelessWidget {
  final String imagePath;
  final String title;
  final DateTime date;

  const RecentFile({
    required this.imagePath,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(
                "${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
