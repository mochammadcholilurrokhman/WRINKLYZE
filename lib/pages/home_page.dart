import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wrinklyze_6/pages/face_result_page.dart';
import 'package:wrinklyze_6/pages/wrinklepedia_page.dart';
import 'package:wrinklyze_6/widgets/recent_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrinklyze_6/providers/home_provider.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 45),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi! ${homeState.userName}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Let's see the wrinkles on your face!",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WrinklepediaPage()),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/wrinkpedia.png',
                    width: 65,
                    height: 65,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Wrinklepedia",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        "Decode the Secrets of Early Aging",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                  SizedBox(width: 25),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          // Container for Recent Files
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFE9EEF0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream:
                            _getFaceResults(), // Use the new method to get face results
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          final faceResults = snapshot.data!;
                          if (faceResults.isEmpty) {
                            return Center(
                              child: Text(
                                'No face scan results found.',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: faceResults.length,
                            itemBuilder: (context, index) {
                              final result = faceResults[index];

                              return GestureDetector(
                                onTap: () {
                                  // Navigate to FaceScanResultPage
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FaceScanResultPage(
                                        skinType: result['skinType'],
                                        confidence: result['confidence'],
                                        probabilities: result['probabilities'],
                                        imagePath: result['imagePath'],
                                      ),
                                    ),
                                  );
                                },
                                child: RecentFile(
                                  imagePath: result['imagePath'],
                                  title: result['skinType'],
                                  date: result['timestamp'].toString(),
                                  captureId: result['captureId'],
                                  onDelete: () {},
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> _getFaceResults() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('face_results')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => {
                    'skinType': doc['skinType'],
                    'confidence': doc['confidence'],
                    'probabilities': doc['probabilities'],
                    'imagePath': doc['imagePath'],
                    'timestamp': (doc['timestamp'] as Timestamp).toDate(),
                    'captureId': doc.id, // Add captureId here
                  })
              .toList());
    }
    return const Stream.empty();
  }
}
